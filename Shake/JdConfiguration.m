//
//  JdConfiguration.m
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

#import "JdConfiguration.h"
#import "JdGenericFilter.h"
#import "JdAxis.h"
#import "JdFilterList.h"

#pragma mark - Constants
const static double kSampleFrequencyDefault = 60.0; // Defined sampling frequency for this system (Hz)

// Array of names for each axis
const char* AxisNames[kAXISCOUNT] = {
    "X Axis",
    "Y Axis",
    "Z Axis"
};


#pragma mark - Private Interface
@interface JdConfiguration()
-(void)FillOutInitialConfiguration;
@end

#pragma mark - Implementation
@implementation JdConfiguration
{
    NSMutableArray* axes;           // Array of all physical axes (x, y & z)
    JdAxis* allAxesConfiguration;   // Dummy axis to hold configuration data to be copied to physical axes
    JdFilterList* filterList;       // List of each possible filter type 
}

#pragma mark - Instance Methods

// Initialise the class
-(id)init
{
    if(!(self = [super init])) return self;

    [self FillOutInitialConfiguration];
    
    return self;
    
}

// Initialise each axis object
-(void)FillOutInitialConfiguration
{
    double defaultFrequency = [JdConfiguration sampleFrequencyDefault];

    filterList = [[JdFilterList alloc] initWithSampleFrequency:defaultFrequency];
    axes = [[NSMutableArray alloc] initWithCapacity:kAXISCOUNT+1];
    for (int i=0; i<kAXISCOUNT; i++) {
        JdAxis* axis = [[JdAxis alloc] initAxis:[NSString stringWithUTF8String:AxisNames[i]] WithFilters:filterList SampleFrequency:defaultFrequency];
        axis.tag = i;
        [axes addObject:axis];
    }
    
    allAxesConfiguration = [[JdAxis alloc] initAxis:@"All Axes" WithFilters:filterList SampleFrequency:defaultFrequency];
    allAxesConfiguration.allConfig = YES;
    allAxesConfiguration.tag = kAXISCOUNT;
    [axes addObject:allAxesConfiguration];
}

// Return the axis object for an arbitrary axis
-(JdAxis*)objectForAxis:(AxisListEnum)axisName
{
    if (axisName > kAXISCOUNT) return nil;
    return [axes objectAtIndex:axisName];
}


#pragma mark - Class Methods
// Return the defautl sampling frequency for the system
+(double) sampleFrequencyDefault
{
    return kSampleFrequencyDefault;
}


@end
