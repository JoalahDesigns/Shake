//
//  JdAxis.m
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

#import "JdAxis.h"
#import "JdFilterBase.h"
#import "JdDigitalFilterDesigns.h"
#import "JdFilterList.h"
#import "JdSineSignal.h"
#import "JdStepSignal.h"
#import "JdImpulseSignal.h"
#import "JdRMS.h"

#pragma mark - Constants

// Array of full names of each signal generator
static const char* signalNames[kSIGNALNAMECOUNT]  = {
    "Accelerometer",
    "Sine",
    "Step",
    "Impulse"
};

// Array of shortened names for each signal generator
static const char* summarySignalNames[kSIGNALNAMECOUNT]  = {
    "Accel.",
    "Sine",
    "Step",
    "Impulse"
};

// Array of descriptions for each signal generator
static const char* signalDescriptions[kSIGNALNAMECOUNT]  = {
    "Accelerometer output for this channel",
    "Sine Wave, with fixed lead in",
    "Step Signal with fixed lead in",
    "Impulse Signal with fixed lead in"
};

#pragma mark - Private Interface
@interface JdAxis()
-(void)commonInit;
-(void)AssignFilter:(FilterTypeEnum) value;
-(void)calculate;
@end

#pragma mark - Constants
static const uint signalLeadIn = 20;        // Number of "zero" samples leading into data from a calculated signal source
static const double signalAmplitude = 2.0;  // Default amplitude of calculated signal sources

#pragma mark - Implementation
@implementation JdAxis
{
    JdFilterList* filters;              // List of each possible filter type for this axis
    JdFilterBase* filter;               // Current filter in use by this axis
    JdSineSignal* sineSignal;           // Sine Wave signal generator for this axis
    JdStepSignal* stepSignal;           // Step response signal generator for this axis
    JdImpulseSignal* impulseSignal;     // Impulse signal generator for this axis
    double sampleFrequency;             // Overall sample frequency for this axis
    JdRMS* rms;                         // RMS calculation for this axis
}

#pragma mark - Synthesize
@synthesize tag;
@synthesize signalSource;
@synthesize filterType;
@synthesize sineAmplitude;
@synthesize sineFrequency;
@synthesize calculationWindow;
@synthesize detectionWindow;
@synthesize detectionLevel;
@synthesize input;
@synthesize raw = _raw;
@synthesize filtered = _filtered;
@synthesize rms = _rms;
@synthesize detection = _detection;
@synthesize allConfig;
@synthesize allConfigConfirm;
@synthesize axisName = _axisName;
@synthesize signalName;
@synthesize filterName;
@synthesize filterDescription;
@synthesize signalSummary;
@synthesize filterSummary;
@synthesize detectionSummary;
@synthesize setupSummary;

#pragma mark - Instance Methods

// Initialise the class
-(id)initAxis:(NSString*)axisName WithFilters:(JdFilterList*)filterList SampleFrequency:(double)sampleFreq
{
    if(!(self = [super init])) return self;
    
    filters = filterList;
    filter = nil;
    sampleFrequency = sampleFreq;
    _axisName = axisName;
    
    [self commonInit];
    
    return self;
}


// Initialise the common elements of the class
-(void)commonInit
{
    signalSource = kSignalInput;
    filterType = kFilterType1;
    sineAmplitude = [JdAxis maxAmplitude];
    sineFrequency = 1.0;
    calculationWindow = 20;
    detectionWindow = 20;
    detectionLevel = [JdAxis maxAmplitude];
    input = 0.0;
    _raw = 0.0;
    _filtered = 0.0;
    _rms = 0.0;
    _detection = 0.0;
    
    allConfig = NO;
    allConfigConfirm = NO;
    
    [self AssignFilter:filterType];
    sineSignal = [[JdSineSignal alloc] initWithAmplitude:sineAmplitude Frequency:sineFrequency SampleRate:sampleFrequency LeadIn:signalLeadIn];
    
    stepSignal = [[JdStepSignal alloc] initWithAmplitude:signalAmplitude LeadIn:signalLeadIn];
    
    impulseSignal = [[JdImpulseSignal alloc] initWithAmplitude:signalAmplitude LeadIn:signalLeadIn];
    
    rms = [[JdRMS alloc] initRetaining:calculationWindow];
    rms.triggerLevel = detectionLevel;
}

// Set the tag for this axis and also the objects within this class
-(void)setTag:(AxisListEnum)value
{
    tag = value;
    sineSignal.tag = tag;
    stepSignal.tag = tag;
    impulseSignal.tag = tag;
    rms.tag = tag;
}

// Return the simple name of the currently selected signal source
-(NSString*)signalName
{
    if (signalSource>=kSIGNALNAMECOUNT) return @"??";
    return [NSString stringWithUTF8String:signalNames[signalSource]];
}

// Return the summary name of the currently selected signal source
-(NSString*)summarySignalName
{
    if (signalSource>=kSIGNALNAMECOUNT) return @"??";
    return [NSString stringWithUTF8String:summarySignalNames[signalSource]];
}

// Return a summary of the currently selected signal source
-(NSString*)signalSummary
{
    switch(signalSource) {
        case kSignalSine:
            return [NSString stringWithFormat:@"%@ Wave, %0.1f, %0.1f Hz", self.signalName, sineAmplitude, sineFrequency];
            break;
            
        default:
            return [NSString stringWithFormat:@"%@", self.signalName];
            break;
    }
    
}


// Return the name of the currently selected filter
-(NSString*)filterName
{
    if (!filter) return @"??";
    return [filter name];
}

// Return the description of the currently selected filter
-(NSString*)filterDescription
{
    if (!filter) return @"??";
    return [filter description];
}

// Return a summary of the currently selected filter
-(NSString*)filterSummary
{
    return [NSString stringWithFormat:@"%@", self.filterDescription];
}

// Return a summary of the current RMS calculation values
-(NSString*)detectionSummary
{
    return [NSString stringWithFormat:@"Calc %d & Detect %d samples, Level %0.1f", calculationWindow, detectionWindow, detectionLevel];
}

// Return a summary of the overall axis setup
-(NSString*)setupSummary
{
    return [NSString stringWithFormat:@"%@, %@, Detect %d/%d/%0.1f", [self summarySignalName], self.filterName, calculationWindow, detectionWindow, detectionLevel ];
}



// Return the simple name for an arbitrary signal source
-(NSString*)signalNameForSource:(SignalSourceEnum)thisSignalSource
{
    if (signalSource>=kSIGNALNAMECOUNT) return @"??";
    return [NSString stringWithUTF8String:signalNames[thisSignalSource]];
}

// Return the description for an arbitrary signal source
-(NSString*)signalDescriptionForSource:(SignalSourceEnum)thisSignalSource
{
    if (signalSource>=kSIGNALNAMECOUNT) return @"??";
    return [NSString stringWithUTF8String:signalDescriptions[thisSignalSource]];
}

// Return the name for an arbitrary filter type
-(NSString*)filterNameForType:(FilterTypeEnum)forFilterType
{
    return [filters filterNameForType:forFilterType];
}

// Return the description for an arbitrary filter type
-(NSString*)filterDescriptionForType:(FilterTypeEnum)forFilterType
{
    return [filters filterDescriptionForType:forFilterType];
}

// Set the signal source and reset all calculated data
-(void)setSignalSource:(SignalSourceEnum)value
{
    signalSource = value;
    [self reset];
}

// Get a copy of the selected filter type
// and set its tag to be of this axis
-(void)AssignFilter:(FilterTypeEnum) value
{
    filter = [filters filterCopyOfType:value];
    filter.tag = tag;
}

// Set the filter type and reset all calculated data
-(void)setFilterType:(FilterTypeEnum)value
{
    filterType = value;
    [self AssignFilter:filterType];
    [self reset];
}

// Set the Sine Wave Amplitude and reset all calculated data
-(void)setSineAmplitude:(double)value
{
    sineAmplitude = value;
    sineSignal.amplitude = sineAmplitude;
    [self reset];
}

// Set the Sine Wave Frequency and reset all calculated data
-(void)setSineFrequency:(double)value
{
    sineFrequency = value;
    sineSignal.frequency = sineFrequency;
    [self reset];
}

// Set the RMS calculation Window and reset all calculated data
-(void)setCalculationWindow:(uint)value
{
    calculationWindow = value;
    rms.retainCount = calculationWindow;
    [self reset];
}

// Set the RMS detection Window and reset all calculated data
-(void)setDetectionWindow:(uint)value
{
    detectionWindow = value;
    rms.triggerCount = detectionWindow;
    [self reset];
}

// Set the RMS detection level and reset all calculated data
-(void)setDetectionLevel:(double)value
{
    detectionLevel = value;
    rms.triggerLevel = detectionLevel;
    [self reset];
}

// Calculate the results of a new data input
-(void)calculate
{
    _filtered = [filter newInput:_raw];
    _rms = [rms calculateNewSample:_filtered];
    _detection = (rms.triggered)?detectionLevel:0.0;
}


// Process a new data input into the axis
-(void)setInput:(double)value
{
    input = value;
    switch (signalSource) {
        case kSignalInput:
            _raw = input;
           break;
            
        case kSignalSine:
            _raw = [sineSignal sample];
            break;
            
        case kSignalStep:
            _raw = [stepSignal sample];
            break;
            
        case kSignalImpulse:
            _raw = [impulseSignal sample];
            break;
            
        default:
            _raw = 0.0;
            break;
    }
    
    [self calculate];
}

// Reset all calculated data in the axis
-(void)reset
{
    [sineSignal reset];
    [stepSignal reset];
    [impulseSignal reset];
    [rms reset];
}

#pragma mark - Class Methods

// Return the maximu allowed amplitude for a signal generator
+(double)maxAmplitude
{
    return signalAmplitude;
}



@end
