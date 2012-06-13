//
//  JdAxis.h
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

#import <Foundation/Foundation.h>
#import "JdFilterTypes.h"
#import "JdAxisList.h"

#pragma mark - Class Enums

// Enum of possible signal sources
typedef enum
{
    kSignalInput,
    kSignalSine,
    kSignalStep,
    kSignalImpulse,
    kSIGNALNAMECOUNT,
} SignalSourceEnum;


#pragma mark - Forward Declaration
@class JdFilterList;

#pragma mark - Public Interface
@interface JdAxis : NSObject
{
    @protected
    // Backing variables for properties that are read only
    double _raw;        // Raw signal being fed into a filter
    double _filtered;   // The output signal from a filter
    double _rms;        // The RMS value of the filtered signal
    double _detection;  // INdication that the RMS level has exceeded a fixe dlevel
}

#pragma mark - Properties

@property (nonatomic) AxisListEnum tag;                 // Axis that this object represents

@property (nonatomic) SignalSourceEnum signalSource;    // Source of the signal that the axis processes

@property (nonatomic) double sineAmplitude;             // Amplitude of the Sine signal generator
@property (nonatomic) double sineFrequency;             // Frequency of the Sine signal generator

@property (nonatomic) FilterTypeEnum filterType;        // Type of filter that this axis uses

@property (nonatomic) uint calculationWindow;           // Number of samples used to calculate the RMS value of the filtered signal
@property (nonatomic) uint detectionWindow;             // Number of samples that the RMS level must exceed the detection level
@property (nonatomic) double detectionLevel;            // RMS detection level threshold

@property (nonatomic) double input;                     // Accelerometer data fed into the axis (but may not be used)
@property (nonatomic, readonly) double raw;             // Current Raw signal
@property (nonatomic, readonly) double filtered;        // Current Filtered signal
@property (nonatomic, readonly) double rms;             // Current RMS signal
@property (nonatomic, readonly) double detection;       // Current RMS Detection signal

@property (nonatomic, readonly) NSString* axisName;             // Name of this axis
@property (nonatomic, readonly) NSString* signalName;           // Name of the signal source in use
@property (nonatomic, readonly) NSString* filterName;           // Name of the filter in use
@property (nonatomic, readonly) NSString* filterDescription;    // Basic description of the filter in use
@property (nonatomic, readonly) NSString* signalSummary;        // Summary of the signal in use (inlcudes signal specific details)
@property (nonatomic, readonly) NSString* filterSummary;        // Summary of the filter in use (inlcudes filter specific details)
@property (nonatomic, readonly) NSString* detectionSummary;     // Summary of the RMS detection in use (inlcudes specific details)

@property (nonatomic, readonly) NSString* setupSummary;         // Summary of signal source, filter and RMS detection all in one

@property (nonatomic) BOOL allConfig;                   // Does this axis represent the configuration state of all the other axes
@property (nonatomic) BOOL allConfigConfirm;            // Copy this axis' configuration to all other axes

#pragma mark - Instance Methods

-(id)initAxis:(NSString*)axisName WithFilters:(JdFilterList*)filters SampleFrequency:(double)sampleFrequency;
-(void)reset;

-(NSString*)signalNameForSource:(SignalSourceEnum)thisSignalSource;
-(NSString*)signalDescriptionForSource:(SignalSourceEnum)thisSignalSource;

-(NSString*)filterNameForType:(FilterTypeEnum)forFilterType;
-(NSString*)filterDescriptionForType:(FilterTypeEnum)forFilterType;

#pragma mark - Class Methods

+(double)maxAmplitude;
@end
