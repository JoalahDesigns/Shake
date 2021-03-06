//
//  JdStepSignal.m
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

#import "JdStepSignal.h"

#pragma mark - Implementation
@implementation JdStepSignal
{
    uint leadInSamples; // Number of "zero" samples that have already been generated
}

#pragma mark - Synthesize
@synthesize tag;
@synthesize amplitude;
@synthesize leadIn;

#pragma mark - Instance Methods

// Initialise the class
-(id)initWithAmplitude:(float)newAmplitude LeadIn:(uint)newLeadIn
{
    if(!(self = [super init])) return self;
    
    amplitude = newAmplitude;
    leadIn = newLeadIn;
    
    [self reset];

    return self;
}

// Reset all calculated data in the signal generator
-(void)reset
{
    leadInSamples = 0;
}

// Set the Amplitude of the Step Response and reset all calculated data
-(void)setAmplitude:(double)value
{
    amplitude = value;
    [self reset];
}

// Set the number of lead In samples of the generator and reset all calculated data
-(void)setLeadIn:(uint)value
{
    leadIn = value;
    [self reset];
}

// Generate a new sample from the signal generator
-(double)sample
{
    leadInSamples++;
    return (leadInSamples<=leadIn)?0.0:amplitude;
}

@end
