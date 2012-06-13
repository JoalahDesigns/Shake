//
//  JdRMS.m
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

#import "JdRMS.h"
#import "NSMutableArray+QueueAdditions.h"

#pragma mark - Implementation
@implementation JdRMS
{
    NSMutableArray* data;           // List of samples from which to calulate the RMS value
    uint countAboveTriggerLevel;    // Number of contiguous samples for which the RMS valus is above the trigger threshold
}

#pragma mark - Synthesize
@synthesize tag;
@synthesize retainCount;
@synthesize triggered = _triggered;
@synthesize triggerCount;
@synthesize triggerLevel;

#pragma mark - Instance Methods

// Initialise the class
-(id)init
{
    if(!(self = [super init])) return self;
    
    data = [[NSMutableArray alloc] init];
    retainCount = 0;
    triggerCount = 0;
    triggerLevel = 0;
    _triggered = NO;
    countAboveTriggerLevel = 0;
    
    return self;
}

// Initialise the class with a retained object count
-(id)initRetaining:(uint)count
{
    if (count==0) return nil;
    if(!(self = [self init])) return self;
    
    retainCount = count;
    return self;
}

// Reset all calculated data in the class
-(void)reset
{
    [data removeAllObjects];
    _triggered = NO;
    countAboveTriggerLevel = 0;
}

// Receive a new data sample into the calculation
// If there is no retain count, then all samples are retained,
// otherwise only the "retainCount" number of samples are retained
// for the calculation
// NOTE That this method will not determine any trigger data
-(void)newSample:(double)sample
{
    NSNumber* number = [[NSNumber alloc] initWithDouble:sample];
    if(!retainCount) {
        [data enqueue:number];
    } else {
        [data enqueue:number retainOnly:retainCount];
    }
    
}

// Calculate the RMS value of the current data samples
-(double)calculate
{
    double sum = 0.0;
    double result = 0.0;
    
    if ([data count]>0) {
        for(NSNumber* number in data) {
            sum += [number doubleValue]*[number doubleValue];
        }
        
        result = sqrt(sum/[data count]);
    }

    return result;
}

// Receive a new data sample and return the calculated RMS value of all samples
// Also determine if the RMS value has exceeded the trigger level for the 
// requisite number of contiguous samples
-(double)calculateNewSample:(double)sample
{
    [self newSample:sample];
    double result = [self calculate];
    if (result>triggerLevel) {
        countAboveTriggerLevel++;
        if (countAboveTriggerLevel>=triggerCount) {
            _triggered = YES;
        }
    } else {
        _triggered = NO;
        countAboveTriggerLevel = 0;
    }
    
    return result;
}

// Set the number of data samples retained for the RSM calculation
-(void)setRetainCount:(uint)value
{
    retainCount = value;
    [self reset];
}

// Set the level at which the RMS valus could trigger an event
-(void)setTriggerLevel:(double)value
{
    triggerLevel = value;
    [self reset];
}

// Set the number of samples needed to trigger an event
-(void)setTriggerCount:(uint)value
{
    triggerCount = value;
    [self reset];
}

// Set the tag for this object
-(void)setTag:(int)value
{
    tag = value;
}
@end
