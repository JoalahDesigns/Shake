//
//  JdGenericFilter.m
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

#import "JdGenericFilter.h"

#pragma mark - Private Interface
@interface JdGenericFilter()
-(void)localReset;
-(double)calculateXPart;
-(double)calculateYPart;
-(double)calulateIIR:(double)value;
-(double)calulateFIR:(double)value;
@end

#pragma mark - Implementation
@implementation JdGenericFilter
{
    DigitalFilterTemplate design;       // Actual template used to define this filter
    double xv[filterMaxCoeffCount+1];   // X coeffs of the difference equation defined for this filter
    double yv[filterMaxCoeffCount+1];   // Y coeffs of the difference equation defined for this filter
    BOOL isFIR;                         // Is this a Finite Input Response filter? 
                                        // (If NO then it is an IIR filter - Infinite Impulse Response filter)
}

#pragma mark - Instance Methods

// Initialise this class
-(id)init
{
    if (!(self = [super init])) return self;
    
    memset(&design, 0, sizeof(DigitalFilterTemplate));
    [self localReset];
    isFIR = YES;
    
    _name = @"Generic";
    _description = @"Generic";
    
    return self;
}

// Initialise this class with a filter definition
-(id)initFilter:(DigitalFilterTemplate)filter
{
    
    if (filter.order==0) {
        self = nil;
        return self;
    }
    
    if(!(self = [super init])) return self;
    
    design = filter;
    self.tag = design.tag;
    _name = [NSString stringWithUTF8String:design.name];
    _description = [NSString stringWithUTF8String:design.description];
    
    for(int i=design.nXCoeffs; i<filterMaxCoeffCount; i++) {
        design.xCoeffs[i] = 0.0;
    }
    
    for(int i=design.nYCoeffs; i<filterMaxCoeffCount; i++) {
        design.yCoeffs[i] = 0.0;
    }
    
    int n = 0;
    while (n < design.nPoles && design.yCoeffs[n] == 0.0) n++;
    isFIR = (n>= design.nPoles);
    
    [self reset];
    
    return self;
}

-(void)localReset
{
    for(int i=0; i<filterMaxCoeffCount+1; i++)
    {
        xv[i] = yv[i] = 0.0;
    }
}

// Reset all calculated data in this and the super class
-(void)reset 
{
    [super reset];
    [self localReset];
}

// Calculate the specific filter response to a new data input
// Split the calculation into two different types of filters
// FIR - Finite Impulse Response Filters 
// IIR - Infinite Impulse response Filters
-(double)calculate
{
    return isFIR?[self calulateFIR:_input]:[self calulateIIR:_input];
}

// Calculate the X coeff portion of an IIR filter
-(double)calculateXPart
{
    double xPart = 0.0;
    
    for (int i=0; i < design.nXCoeffs; i++)
    { 
        xPart += design.xCoeffs[i] * xv[i];
    }
    
    return xPart;
}

// Calculate the Y coeff portion of an IIR filter
-(double)calculateYPart
{
    double yPart = 0.0f;
    for (int i=0; i < design.nYCoeffs; i++)
    { 
        yPart += design.yCoeffs[i] * yv[i];
    }
    return yPart;
}

// Shift the X values of an IIR or FIR filter
-(void)shiftXV
{
    // Shift the xv
    for(int i=0; i<design.nZeroes; i++) {
        xv[i] = xv[i+1];
    }
}

// Shift the Y values of an IIR filter
-(void)shiftYV
{
    // Shift the yv values
    for(int i=0; i<design.nPoles; i++) {
        yv[i] = yv[i+1];
    }
}

// Calculate the result of an input to an IIR filter
-(double)calulateIIR:(double)value
{
    // Shift the xv and yv values
    [self shiftXV];
    [self shiftYV];
    
    // Insert the new value into the filter
    xv[design.nZeroes] = value/design.gain;
    
    // Calculate the new output
    yv[design.nPoles] = [self calculateXPart] + [self calculateYPart];
    
    return  yv[design.nPoles];
}

// Calculate the result of an input to an FIR filter
-(double)calulateFIR:(double)value
{
    // Shift the xv values
    [self shiftXV];
    
    // Insert the new value into the filter
    xv[design.nZeroes] = value/design.gain;
    
    // Calculate the new output
    return [self calculateXPart];
}

// Create an independent copy of this filter
-(id)copyWithZone:(NSZone *)zone
{
    return [[JdGenericFilter allocWithZone:zone] initFilter:design];
}
@end
