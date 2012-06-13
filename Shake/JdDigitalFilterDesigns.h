//
//  JdDigitalFilterDesigns.h
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

#ifndef JdDigitalFilterDesigns_h
#define JdDigitalFilterDesigns_h

#import "JdDigitalFilterTemplate.h"

// Concrete designs for several different generic filters.
// Note that these designs are specific to their indicated sample frequency
// and that if the Shake! system sample frequency is changed, then the filter will
// have to be re-designed.  The sample frequency indicated below is only for
// reference by the programmer.

// These filter designs were developed with help from
// http://www-users.cs.york.ac.uk/~fisher/cgi-bin/mkfscript


const static DigitalFilterTemplate butterworth2OLP5Hz = {
    /*                 Tag */   1,                                      
    /*               Title */   "Butterworth LP 1",
    /*         Description */   "2nd Order Low Pass 5 Hz",
    /*        Filter Class */   kFilterClassLowPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    5.0,
    /*    Corner Freq 2 Hz */    0,
    /*           Freq 3 Hz */    0,
    /*               Order */    2,
    /*                Gain */    2.020612010e+01,
    /*    Number of Zeroes */    2,
    /*  Number of X Coeffs */    3,
    /*            X Coeffs */    { 1, 2, 1 },
    /*     Number of Poles */    2,
    /*  Number of Y Coeffs */    2, 
    /*            Y Coeffs */    { -0.4775922501, 1.2796324250 }
};

const static DigitalFilterTemplate butterworth2OHP5Hz = {
    /*                 Tag */   2,                                      
    /*               Title */   "Butterworth HP 1",
    /*         Description */   "2nd Order High Pass 5 Hz",
    /*        Filter Class */   kFilterClassHighPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    5.0,
    /*    Corner Freq 2 Hz */    0,
    /*           Freq 3 Hz */    0,
    /*               Order */    2,
    /*                Gain */    1.450734152e+00,
    /*    Number of Zeroes */    2,
    /*  Number of X Coeffs */    3,
    /*            X Coeffs */    { 1, -2, 1 },
    /*     Number of Poles */    2,
    /*  Number of Y Coeffs */    2, 
    /*            Y Coeffs */    { -0.4775922501, 1.2796324250 }
};

const static DigitalFilterTemplate butterworth2OBP1HzTo3Hz = {
    /*                 Tag */   3,                                      
    /*               Title */   "Butterworth BP 1",
    /*         Description */   "2nd Order Band Pass 1 Hz to 3 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    1.0,
    /*    Corner Freq 2 Hz */    3.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    2,
    /*                Gain */    1.047850310e+02,
    /*    Number of Zeroes */    4,
    /*  Number of X Coeffs */    5,
    /*            X Coeffs */    { 1, 0, -2, 0, 1 },
    /*     Number of Poles */    4,
    /*  Number of Y Coeffs */    4, 
    /*            Y Coeffs */    { -0.7436551951, 3.1402936861, -5.0421156237, 3.6445421236 }
};

const static DigitalFilterTemplate butterworth2OBP25HzTo5Hz = {
    /*                 Tag */   4,                                      
    /*               Title */   "Butterworth BP 2",
    /*         Description */   "2nd Order Band Pass 2.5 Hz to 5 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    2.5,
    /*    Corner Freq 2 Hz */    5.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    2,
    /*                Gain */    6.941574297e+01,
    /*    Number of Zeroes */    4,
    /*  Number of X Coeffs */    5,
    /*            X Coeffs */    { 1, 0, -2, 0, 1 },
    /*     Number of Poles */    4,
    /*  Number of Y Coeffs */    4, 
    /*            Y Coeffs */    { -0.6905989232, 2.8087788723, -4.5190260480, 3.3854106817 }
};

#endif
