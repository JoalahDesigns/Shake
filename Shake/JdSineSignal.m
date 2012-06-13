//
//  JdSineWave.m
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

#import "JdSineSignal.h"

#pragma mark - Implementation
@implementation JdSineSignal
{
    uint samples;       // Number of samples processed by the signal generator
    uint leadInSamples; // Number of "zero" samples that have already been generated
}

#pragma mark - Synthesize
@synthesize tag;
@synthesize amplitude;
@synthesize frequency;
@synthesize sampleRate;
@synthesize leadIn;

#pragma mark - Instance Methods

// Initialise the class
-(id)initWithAmplitude:(float)amplitudeSet Frequency:(float)frequencySet SampleRate:(float)sampleRateSet LeadIn:(uint)leadInSet
{
    if (sampleRateSet <=0.0f) return nil;
    if (frequencySet <= 0.0f) return nil;
    if (amplitudeSet <= 0.0f) return nil;
    
    if(!(self = [super init])) return self;
    
    amplitude = amplitudeSet;
    frequency = frequencySet;
    sampleRate = sampleRateSet;
    leadIn = leadInSet;
    
    [self reset];
    return self;
}

// Reset all calculated data in the signal generator
-(void)reset
{
    samples = 0;
    leadInSamples = 0;
}

// Set the Amplitude of the Sine Wave and reset all calculated data
-(void)setAmplitude:(double)value
{
    if (value<=0.0) return;
    amplitude = value;
    [self reset];
}

// Set the Frequency of the Sine Wave and reset all calculated data
-(void)setFrequency:(double)frequencySet
{
    if (frequencySet<=0.0) return;
    frequency = frequencySet;
    [self reset];
}

// Set the Sampling Frequency of the signal generator and reset all calculated data
-(void)setSampleRate:(double)sampleRateSet
{
    if (sampleRateSet <=0.0f) return;
    sampleRate = sampleRateSet;
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
    double result = 0.0;
    if ((leadInSamples++)<leadIn) {
     result = 0.0;   
    } else {
        double angle = 2.0 * M_PI * samples * frequency / sampleRate;
        samples++;
        result =  amplitude*sin(angle);
    }
    return result;
    
}

@end
