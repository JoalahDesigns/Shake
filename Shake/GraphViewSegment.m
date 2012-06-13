// NOTE - These files are hcked out of Apple's code, but modified to provide 
//        the functionality that I want.  So they are a bastard child from
//        a union of myself and Apple.  As such I have no idea under what license
//        they actually fall.  So for the hell of it I am leaving in Apple's
//        license as well as my own.   

//  GraphViewSegment.m
//
// Copyright (c) 2012, Joalah Designs LLC
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
//    1. Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
// 
//    2. Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
// 
//    3. Neither the name of Joalah Designs LLC nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL JOALAH DESIGNS LLC BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


/*
 File: GraphView.h
 Abstract: Displays a graph of accelerometer output using. This class uses Core Animation techniques to avoid needing to render the entire graph every update
 Version: 2.5
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "GraphViewSegment.h"

#import "QuartzHelpers.h"

#pragma mark - Implementation
@implementation GraphViewSegment
{
    CGRect bounds;
}

#pragma mark - Synthesize
@synthesize layer;

#pragma mark - Instance Methods
-(id)initWithRect:(CGRect)rect
{
	self = [super init];
	if(self != nil)
	{
        bounds = rect;
        
		layer = [[CALayer alloc] init];
		// the layer will call our -drawLayer:inContext: method to provide content
		// and our -actionForLayer:forKey: for implicit animations
		layer.delegate = self;
		// This sets our coordinate system such that it has an origin of 0.0,-56 and a size of 32,112.
		// This would need to be changed if you change either the number of pixel values that a segment
		// represented, or if you changed the size of the graph view.
		layer.bounds = bounds;
		// Disable blending as this layer consists of non-transperant content.
		// Unlike UIView, a CALayer defaults to opaque=NO
		layer.opaque = YES;
		// Index represents how many slots are left to be filled in the graph,
		// which is also +1 compared to the array index that a new entry will be added
		index = 33;
	}
	return self;
}

-(void)dealloc
{
}

-(void)reset
{
	// Clear out our components and reset the index to 33 to start filling values again...
	memset(rawHistory,      0, sizeof(rawHistory));
	memset(filteredHistory, 0, sizeof(filteredHistory));
	memset(rmsHistory,      0, sizeof(rmsHistory));
	memset(triggerHistory,  0, sizeof(triggerHistory));
    
    
	index = 33;
	// Inform Core Animation that we need to redraw this layer.
	[layer setNeedsDisplay];
}

-(BOOL)isFull
{
	// Simple, this segment is full if there are no more space in the history.
	return index == 0;
}

-(BOOL)isVisibleInRect:(CGRect)r
{
	// Just check if there is an intersection between the layer's frame and the given rect.
	return CGRectIntersectsRect(r, layer.frame);
}

-(BOOL)addRaw:(double)raw filtered:(double)filtered rms:(double)rms trigger:(double)trigger
{
	// If this segment is not full, then we add a new acceleration value to the history.
	if(index > 0)
	{
		// First decrement, both to get to a zero-based index and to flag one fewer position left
		--index;
		rawHistory[index] = raw;
		filteredHistory[index] = filtered;
		rmsHistory[index] = rms;
		triggerHistory[index] = trigger;
		// And inform Core Animation to redraw the layer.
		[layer setNeedsDisplay];
	}
	// And return if we are now full or not (really just avoids needing to call isFull after adding a value).
	return index == 0;
}

-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
	// Fill in the background
	CGContextSetFillColorWithColor(context, segmentBackgroundColor());
	CGContextFillRect(context, layer.bounds);
	
	// Draw the grid lines
	DrawGridlines(context, 0.0, bounds.size.width);
    
	// Draw the graph
	CGPoint lines[64];
	int i;
	
	// raw
	for(i = 0; i < 32; ++i)
	{
        // This gets done once
        // and is used for each graph line
		lines[i*2].x = i;
		lines[i*2].y = -rawHistory[i] * 16.0;
        
        // This is done for each graph line
		lines[i*2+1].x = i + 1;
		lines[i*2+1].y = -rawHistory[i+1] * 16.0;
	}
	CGContextSetStrokeColorWithColor(context, graphRawColor());
	CGContextStrokeLineSegments(context, lines, 64);
    
	// filtered
	for(i = 0; i < 32; ++i)
	{
		lines[i*2].y = -filteredHistory[i] * 16.0;
		lines[i*2+1].y = -filteredHistory[i+1] * 16.0;
	}
	CGContextSetStrokeColorWithColor(context, graphFilteredColor());
	CGContextStrokeLineSegments(context, lines, 64);
    
	// rms
	for(i = 0; i < 32; ++i)
	{
		lines[i*2].y = -rmsHistory[i] * 16.0;
		lines[i*2+1].y = -rmsHistory[i+1] * 16.0;
	}
	CGContextSetStrokeColorWithColor(context, graphRmsColor());
	CGContextStrokeLineSegments(context, lines, 64);


	// trigger
	for(i = 0; i < 32; ++i)
	{
		lines[i*2].y = -triggerHistory[i] * 16.0;
		lines[i*2+1].y = -triggerHistory[i+1] * 16.0;
	}
	CGContextSetStrokeColorWithColor(context, graphTriggerColor());
	CGContextStrokeLineSegments(context, lines, 64);

}

-(id)actionForLayer:(CALayer *)layer forKey :(NSString *)key
{
	// We disable all actions for the layer, so no content cross fades, no implicit animation on moves, etc.
	return [NSNull null];
}

@end

