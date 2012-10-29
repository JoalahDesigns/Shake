//
//  JdSimpleLP.m
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

#import "JdSimpleLP.h"

#pragma mark - Implementation
@implementation JdSimpleLP

#pragma mark - Instance Methods

// Initialise the class
-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq
{
    if(!(self = [super initWithSampleRate:rate cutoffFrequency:freq])) return self;
    
    _name = @"Simple Low Pass";
    _description = [NSString stringWithFormat:@"Apple's Low Pass Filter %0.0f Hz cutoff", cutoffFrequency];

    return self;
}

// Calculate the filter constant for a simple low pass filter
-(double)determineFilterConstant
{
    double dt = 1.0 / sampleRate;
    double RC = 1.0 / cutoffFrequency;
    return dt / (dt + RC);
}

// Calculate the response to a new input to the filter
// NOTE that this is called from the ultimate base class
-(double)calculate
{
    return filterConstant * _input + (1.0 - filterConstant) * _output;
}

// Create an independent copy of this filter
-(id)copyWithZone:(NSZone *)zone
{
    return [[JdSimpleLP allocWithZone:zone] initWithSampleRate:sampleRate cutoffFrequency:cutoffFrequency];
}

@end
