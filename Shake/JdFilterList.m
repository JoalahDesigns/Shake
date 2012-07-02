//
//  JdFilterList.m
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

#import "JdFilterList.h"
#import "JdFilterTypes.h"
#import "JdFilterBase.h"
#import "JdSimpleLP.h"
#import "JdSimpleHP.h"
#import "JdGenericFilter.h"
#import "JdDigitalFilterDesigns.h"

#pragma mark - Constants
const static double cutoffFrequency = 5.0;  // Default cutoff frequency for the "simple" filters


#pragma mark - Private Interface
@interface JdFilterList()
-(void)commonInit;
@end

#pragma mark - Implementation
@implementation JdFilterList
{
    double sampleFrequency;     // Overall sampling frequency for this system
    NSMutableArray* filters;    // List of each defined filter
}

#pragma mark - Instance Methods

// Initialise the class
- (id)initWithSampleFrequency:(double)frequency
{
    if(!(self = [super init])) return self;
    sampleFrequency = frequency;
    [self commonInit];
    
    return self;
}

// Initialise an instance of each type of filter
-(void)commonInit
{
    filters = [[NSMutableArray alloc] initWithCapacity:kFILTERTYPECOUNT];
    for(int i=0; i< kFILTERTYPECOUNT; i++) {
        switch (i) {
            case kFilterType1:
                [filters addObject:[[JdFilterBase alloc] init]];
                break;
                
            case kFilterType2:
                [filters addObject:[[JdSimpleLP alloc] initWithSampleRate:sampleFrequency cutoffFrequency:cutoffFrequency]];
                break;
                
            case kFilterType3:
                [filters addObject:[[JdSimpleHP alloc] initWithSampleRate:sampleFrequency cutoffFrequency:cutoffFrequency]];
                break;
                
            case kFilterType4:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth2O_LP_50Hz]];
                break;
                
            case kFilterType5:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth2O_HP_50Hz]];
                break;
                
            case kFilterType6:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth2O_BP_05HzTo30Hz]];
                break;
                
            case kFilterType7:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth2O_BP_25HzTo50Hz]];
                break;
                
            case kFilterType8:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth3O_BP_05HzTo30Hz]];
                break;
                
            case kFilterType9:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth3O_BP_25HzTo50Hz]];
                break;
                
            case kFilterType10:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth2O_BP_05HzTo40Hz]];
                break;
                
            case kFilterType11:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth2O_BP_40HzTo80Hz]];
                break;
                
            case kFilterType12:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth3O_BP_05HzTo40Hz]];
                break;
                
            case kFilterType13:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth3O_BP_20HzTo60Hz]];
                break;
                
            case kFilterType14:
                [filters addObject:[[JdGenericFilter alloc] initFilter:butterworth3O_BP_40HzTo80Hz]];
                break;
                
            default:
                [filters addObject:[[JdFilterBase alloc] init]];
                break;
        }
    }
}

// Return the defined filter instance for an arbitrary filter type
-(JdFilterBase*)filterImplementationForType:(FilterTypeEnum)forFilterType
{
    if (forFilterType >= kFILTERTYPECOUNT) return nil;
    return [filters objectAtIndex:forFilterType];
}

// Return an independent copy of a defined filter instance for an arbitrary filter type
-(JdFilterBase*)filterCopyOfType:(FilterTypeEnum)forFilterType
  {
      if (forFilterType >= kFILTERTYPECOUNT) return nil;
      JdFilterBase* filter = [filters objectAtIndex:forFilterType];
      return [filter copy];
  }

// Return the name of a filter for an arbitrary filter type
-(NSString*)filterNameForType:(FilterTypeEnum)forFilterType
{
    if (forFilterType >= kFILTERTYPECOUNT) return @"??";
    JdFilterBase* filter = [filters objectAtIndex:forFilterType];
    return filter.name;
}

// Return the description of a filter for an arbitrary filter type
-(NSString*)filterDescriptionForType:(FilterTypeEnum)forFilterType
{
    if (forFilterType >= kFILTERTYPECOUNT) return @"??";
    JdFilterBase* filter = [filters objectAtIndex:forFilterType];
    return filter.description;
}


@end
