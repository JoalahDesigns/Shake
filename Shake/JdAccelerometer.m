//
//  JdAccelerometer.m
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

#import "JdAccelerometer.h"

#pragma mark - Implementation
@implementation JdAccelerometer

#pragma mark - Synthesize
@synthesize pause;
@synthesize sampleFrequency;
@synthesize acceleration = _acceleration;
@synthesize outputDelegate;

#pragma mark - Instance Methods

// Initialise this class
-(id)initWithSampleFrequency:(double)sampleFreq
{
    if (sampleFreq<=0.0 || sampleFreq>=100.0) return nil;
    if(!(self = [super init])) return self;
    
    sampleFrequency = sampleFreq;
    pause = YES;
    outputDelegate = nil;
    _acceleration = [[UIAcceleration alloc] init];
    
    @try {
        
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/sampleFrequency];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    }
    
    @catch (NSException * e) {
        
        self = nil;
        return self;
        
    }
    
    
    return self;
}

// Receive the actual accleration data from the hardware accelerometers
// and pass it onto the defined delegate
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
    if (!pause)
    {
        _acceleration = acceleration;
        if (outputDelegate) {
            [outputDelegate acceleration:acceleration];
        }
    }
}

// Set the sampling frequency of the hardware accelerometers
-(void)setSampleFrequency:(double)sampleFreq
{
    if (sampleFreq<=0.0 || sampleFreq>=100.0) return;
    sampleFrequency = sampleFreq;
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/sampleFrequency];
}

@end
