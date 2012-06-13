//
//  JdDigitalFilterDesign.h
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

#ifndef JdDigitalFilterTemplate_h
#define JdDigitalFilterTemplate_h

// Constants used for the generic filter designs
// they have to be defines and not const static's as this template 
// ends up being included in several compilation units.  So if they were 
// concrete constants then this would cause compilation errors from having
// multiply defined symbols.
#define filterMinOrder 1
#define filterMaxOrder 10
#define filterMaxCoeffCount (filterMaxOrder*2)

// List of Filter classes 
typedef enum {
    kFilterClassLowPass,
    kFilterClassBandPass,
    kFilterClassHighPass,
    kFilterClassBandStop
} DigitalFilterClass;

// Definition of a generic digital filter
// Fields marked with @ are for reference only and not used
// in the actual filter calculations
typedef struct {
    /*          Arbitrary Filter Reference Tag @ */ int tag;                                
    /*                            Filter Title @ */ char* name;
    /*                      Filter Description @ */ char* description;
    /*                            Filter Class @ */ DigitalFilterClass class;
    /*              Design Sample Frequency Hz @ */ double sampleFrequency;
    /*                 Filter Corner Freq 1 Hz @ */ double freq1;
    /*                 Filter Corner Freq 2 Hz @ */ double freq2;
    /*                        Filter Freq 3 Hz @ */ double freq3;
    /*                            Filter Order @ */ uint order;
    /*                                    Gain   */ double gain;
    /*            Number of Z-Transform Zeroes   */ uint nZeroes;
    /*  Number of difference equation X Coeffs   */ uint nXCoeffs;
    /*                     difference X Coeffs   */ double xCoeffs[filterMaxCoeffCount];
    /*             Number of Z-Transform Poles   */ uint nPoles;
    /*   Number ofdifference equation Y Coeffs   */ uint nYCoeffs;
    /*                     difference Y Coeffs   */ double yCoeffs[filterMaxCoeffCount];
} DigitalFilterTemplate;



#endif
