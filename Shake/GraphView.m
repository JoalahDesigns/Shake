// NOTE - These files are hcked out of Apple's code, but modified to provide 
//        the functionality that I want.  So they are a bastard child from
//        a union of myself and Apple.  As such I have no idea under what license
//        they actually fall.  So for the hell of it I am leaving in Apple's
//        license as well as my own.   

//  GraphView.m
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
#import "GraphTextView.h"
#import "GraphView.h"

#import "QuartzHelpers.h"

#pragma mark - Overview of operation

// The GraphView class needs to be able to update the scene quickly in order to track the accelerometer data
// at a fast enough frame rate. The naive implementation tries to draw the entire graph every frame,
// but unfortunately that is too much content to sustain a high framerate. As such this class uses CALayers
// to cache previously drawn content and arranges them carefully to create an illusion that we are
// redrawing the entire graph every frame.

#pragma mark - GraphView

// Finally the actual GraphView class. This class handles the public interface as well as arranging
// the subviews and sublayers to produce the intended effect. 


#pragma mark - Private Interface
@interface GraphView()

// Internal accessors
@property(nonatomic, retain) NSMutableArray *segments;
@property(nonatomic, assign) GraphViewSegment *current;
@property(nonatomic, assign) GraphTextView *text;

// A common init routine for use with -initWithFrame: and -initWithCoder:
-(void)commonInit;

// Creates a new segment, adds it to 'segments', and returns a weak reference to that segment
// Typically a graph will have around a dozen segments, but this depends on the width of the graph view and segments
-(GraphViewSegment*)addSegment;

// Recycles a segment from 'segments' into  'current'
-(void)recycleSegment;
@end

#pragma mark - Constants
static const float kSegmentWidth = 32.0f;
static const float kTextWidth = 14.0f;

#pragma mark - Implementation
@implementation GraphView
{
    CGPoint segmentInitialPosition;
    float graphHeight;
    float graphWidth;
}

#pragma mark - Synthesize
@synthesize segments, current, text;

#pragma mark - Instance Methods
// Designated initializer
-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		[self commonInit];
	}
	return self;
}

// Designated initializer
-(id)initWithCoder:(NSCoder*)decoder
{
	self = [super initWithCoder:decoder];
	if(self != nil)
	{
		[self commonInit];
	}
	return self;
}

-(void)commonInit
{
    graphHeight = self.bounds.size.height;
    graphWidth = self.bounds.size.width;

	// Create the text view and add it as a subview. We keep a weak reference
	// to that view afterwards for laying out the segment layers.
	GraphTextView* text1 = [[GraphTextView alloc] initWithFrame:CGRectMake(0.0, 0.0, kSegmentWidth, graphHeight)];
	[self addSubview:text1];
    text = text1;
	
	// Create a mutable array to store segments, which is required by -addSegment
	segments = [[NSMutableArray alloc] init];

	// Create a new current segment, which is required by -addX:y:z and other methods.
	// This is also a weak reference (we assume that the 'segments' array will keep the strong reference).
    segmentInitialPosition = CGPointMake(kTextWidth, graphHeight/2.0);
	current = [self addSegment];
}

-(void)addRaw:(double)raw filtered:(double)filtered rms:(double)rms trigger:(double)trigger
{
	// First, add the new acceleration value to the current segment
	if([current addRaw:raw filtered:filtered rms:rms trigger:trigger])
	{
		// If after doing that we've filled up the current segment, then we need to
		// determine the next current segment
		[self recycleSegment];
		// And to keep the graph looking continuous, we add the acceleration value to the new segment as well.
		[current addRaw:raw filtered:filtered rms:rms trigger:trigger];
	}
	// After adding a new data point, we need to advance the x-position of all the segment layers by 1 to
	// create the illusion that the graph is advancing.
	for(GraphViewSegment * s in segments)
	{
		CGPoint position = s.layer.position;
		position.x += 1.0;
		s.layer.position = position;
	}
}

// The initial position of a segment that is meant to be displayed on the left side of the graph.
// This positioning is meant so that a few entries must be added to the segment's history before it becomes
// visible to the user. This value could be tweaked a little bit with varying results, but the X coordinate
// should never be larger than 16 (the center of the text view) or the zero values in the segment's history
// will be exposed to the user.
//#define kSegmentInitialPosition CGPointMake(14.0, 56.0);

-(GraphViewSegment*)addSegment
{
	// Create a new segment and add it to the segments array.
	GraphViewSegment * segment = [[GraphViewSegment alloc] initWithRect:CGRectMake(0.0, -graphHeight/2.0, kSegmentWidth, graphHeight)];
	// We add it at the front of the array because -recycleSegment expects the oldest segment
	// to be at the end of the array. As long as we always insert the youngest segment at the front
	// this will be true.
	[segments insertObject:segment atIndex:0];
	
	// Ensure that newly added segment layers are placed after the text view's layer so that the text view
	// always renders above the segment layer.
	[self.layer insertSublayer:segment.layer below:text.layer];
	// Position it properly (see the comment for kSegmentInitialPosition)
	segment.layer.position = segmentInitialPosition;
	
	return segment;
}

-(void)recycleSegment
{
	// We start with the last object in the segments array, as it should either be visible onscreen,
	// which indicates that we need more segments, or pushed offscreen which makes it eligable for recycling.
	GraphViewSegment * last = [segments lastObject];
	if([last isVisibleInRect:self.layer.bounds])
	{
		// The last segment is still visible, so create a new segment, which is now the current segment
		current = [self addSegment];
	}
	else
	{
		// The last segment is no longer visible, so we reset it in preperation to be recycled.
		[last reset];
		// Position it properly (see the comment for kSegmentInitialPosition)
		last.layer.position = segmentInitialPosition;
		// Move the segment from the last position in the array to the first position in the array
		// as it is now the youngest segment.
		[segments insertObject:last atIndex:0];
		[segments removeLastObject];
		// And make it our current segment
		current = last;
	}
}

// The graph view itself exists only to draw the background and gridlines. All other content is drawn either into
// the GraphTextView or into a layer managed by a GraphViewSegment.
-(void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Fill in the background
	CGContextSetFillColorWithColor(context, graphBackgroundColor());
	CGContextFillRect(context, self.bounds);
	
	CGContextTranslateCTM(context, 0.0, graphHeight/2.0);

	// Draw the grid lines
	DrawGridlines(context, 0.0, graphWidth);
}

#pragma mark - Class Methods
+(UIColor*)rawColor
{
    return [UIColor colorWithCGColor:graphRawColor()];
}

+(UIColor*)filteredColor
{
    return [UIColor colorWithCGColor:graphFilteredColor()];
}

+(UIColor*)rmsColor
{
    return [UIColor colorWithCGColor:graphRmsColor()];
}

+(UIColor*)triggeredColor
{
    return [UIColor colorWithCGColor:graphTriggerColor()];
}



@end
