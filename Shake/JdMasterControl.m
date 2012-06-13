//
//  JdMasterControl.m
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

#import "JdMasterControl.h"
#import "JdAccelerometer.h"
#import "GraphView.h"
#import "JdConfiguration.h"
#import "JdAxis.h"

#pragma mark - Private Interface
@interface JdMasterControl()
-(void)commonInit;
@end

#pragma mark - Implementation
@implementation JdMasterControl
{
    JdAccelerometer* accelerometer;     // Accelerometer interface class
}

#pragma mark - Synthesize
@synthesize pause;
@synthesize xAxisGraph;
@synthesize yAxisGraph;
@synthesize zAxisGraph;
@synthesize configuration;

#pragma mark - Instance Methods

// Initialise the class
-(id)initWithConfiguration:(JdConfiguration*)config;
{
    if(!(self = [super init])) return self;
    
    configuration = config;
    
    [self commonInit];
    
    return self;
}

// Initialise common parts of the class
-(void)commonInit
{
    pause = YES;
    accelerometer = [[JdAccelerometer alloc] initWithSampleFrequency:[JdConfiguration sampleFrequencyDefault]];
    accelerometer.outputDelegate = self;
    accelerometer.pause = pause;
    
    xAxisGraph = yAxisGraph = zAxisGraph = nil;
}

// JdAccelerometerProtocol method
// Deal with a new acceleration value
// by feeding each channels data into the appropriate axis,
// (which calculates the response) and then graphing the results
-(void)acceleration:(UIAcceleration *)value
{
    
    for(int i=0; i<kAXISCOUNT; i++)
    {
        double input = 0;
        GraphView* axisGraph = nil;
        switch (i) {
            case kAxisX: 
                input = value.x; 
                axisGraph = xAxisGraph;
                break;
            case kAxisY: 
                input = value.y; 
                axisGraph = yAxisGraph;
                break;
            case kAxisZ: input = value.z; 
                axisGraph = zAxisGraph;
                break;
                
            default:
                break;
        }
        
        JdAxis* axis = [configuration objectForAxis:i];
        if (axis) {
            axis.input = input;
            if (axisGraph) {
                [axisGraph addRaw:axis.raw filtered:axis.filtered rms:axis.rms trigger:axis.detection];
            }
        }
        
    }
     
}

// Pause the generation of the acceleration data
-(void)setPause:(BOOL)value
{
    pause = value;
    accelerometer.pause = pause;
}

// Set a new configuration object
-(void)setConfiguration:(JdConfiguration *)value
{
    configuration = value;
}

@end
