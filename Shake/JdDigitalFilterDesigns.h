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


const static DigitalFilterTemplate butterworth2O_LP_50Hz = {
    /*                 Tag */   4,                                      
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

const static DigitalFilterTemplate butterworth2O_HP_50Hz = {
    /*                 Tag */   5,                                      
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

const static DigitalFilterTemplate butterworth2O_BP_05HzTo30Hz = {
    /*                 Tag */   6,                                      
    /*               Title */   "Butterworth BP 1",
    /*         Description */   "2nd Order Band Pass 0.5 Hz to 3 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    0.5,
    /*    Corner Freq 2 Hz */    3.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    2,
    /*                Gain */    6.890076929e+01,
    /*    Number of Zeroes */    4,
    /*  Number of X Coeffs */    5,
    /*            X Coeffs */    { 1, 0, -2, 0, 1 },
    /*     Number of Poles */    4,
    /*  Number of Y Coeffs */    4, 
    /*            Y Coeffs */    { -0.6905989232, 2.9892919079, -4.9019021489, 3.6029823692 }
};

const static DigitalFilterTemplate butterworth2O_BP_25HzTo50Hz = {
    /*                 Tag */   7,                                      
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

const static DigitalFilterTemplate butterworth3O_BP_05HzTo30Hz = {
    /*                 Tag */   8,                                      
    /*               Title */   "Butterworth BP 3",
    /*         Description */   "3rd Order Band Pass 0.5 Hz to 3 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    0.5,
    /*    Corner Freq 2 Hz */    3.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    3,
    /*                Gain */    5.692666745e+02,
    /*    Number of Zeroes */    6,
    /*  Number of X Coeffs */    7,
    /*            X Coeffs */    { -1, 0, 3, 0, -3, 0, 1 },
    /*     Number of Poles */    6,
    /*  Number of Y Coeffs */    6, 
    /*            Y Coeffs */    { -0.5914839175, 3.8259313174, -10.3638005554, 15.0484236941, -12.3516477932, 5.4325737865 }
};

const static DigitalFilterTemplate butterworth3O_BP_25HzTo50Hz = {
    /*                 Tag */   9,                                      
    /*               Title */   "Butterworth BP 4",
    /*         Description */   "3rd Order Band Pass 2.5 Hz to 5 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    2.5,
    /*    Corner Freq 2 Hz */    5.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    3,
    /*                Gain */    5.698186806e+02,
    /*    Number of Zeroes */    6,
    /*  Number of X Coeffs */    7,
    /*            X Coeffs */    { -1, 0, 3, 0, -3, 0, 1 },
    /*     Number of Poles */    6,
    /*  Number of Y Coeffs */    6, 
    /*            Y Coeffs */    { -0.5914839175, 3.5948965113, -9.3939394697, 13.4792208887, -11.1951606727, 5.1045193790 }
};

const static DigitalFilterTemplate butterworth2O_BP_05HzTo40Hz = {
    /*                 Tag */   10,                                      
    /*               Title */   "Butterworth BP 5",
    /*         Description */   "2nd Order Band Pass 0.5 Hz to 4 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    0.5,
    /*    Corner Freq 2 Hz */    4.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    2,
    /*                Gain */    3.734347495e+01,
    /*    Number of Zeroes */    4,
    /*  Number of X Coeffs */    5,
    /*            X Coeffs */    { 1, 0, -2, 0, -1},
    /*     Number of Poles */    4,
    /*  Number of Y Coeffs */    4, 
    /*            Y Coeffs */    { -0.5956541946, 2.6513004962, -4.5070640158, 3.4510395986 }
};

const static DigitalFilterTemplate butterworth2O_BP_40HzTo80Hz = {
    /*                 Tag */   11,                                      
    /*               Title */   "Butterworth BP 6",
    /*         Description */   "2nd Order Band Pass 4 Hz to 8 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    4.0,
    /*    Corner Freq 2 Hz */    8.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    2,
    /*                Gain */    2.978037555e+01,
    /*    Number of Zeroes */    4,
    /*  Number of X Coeffs */    5,
    /*            X Coeffs */    { 1, 0, -2, 0, 1 },
    /*     Number of Poles */    4,
    /*  Number of Y Coeffs */    4, 
    /*            Y Coeffs */    { -0.5532698897, 2.0888366596, -3.4522393348, 2.8278094912 }
};

const static DigitalFilterTemplate butterworth3O_BP_05HzTo40Hz = {
    /*                 Tag */   12,                                      
    /*               Title */   "Butterworth BP 7",
    /*         Description */   "3rd Order Band Pass 0.5 Hz to 4 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    0.5,
    /*    Corner Freq 2 Hz */    4.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    3,
    /*                Gain */    2.267303368e+02,
    /*    Number of Zeroes */    6,
    /*  Number of X Coeffs */    7,
    /*            X Coeffs */    { -1, 0, 3, 0, -3, 0, 1 },
    /*     Number of Poles */    6,
    /*  Number of Y Coeffs */    6, 
    /*            Y Coeffs */    { -0.4784081507, 3.1839352836, -8.8988238970, 13.3720853678, -11.3911630674, 5.2123669563 }
};

const static DigitalFilterTemplate butterworth3O_BP_20HzTo60Hz = {
    /*                 Tag */   13,                                      
    /*               Title */   "Butterworth BP 8",
    /*         Description */   "3rd Order Band Pass 2 Hz to 6 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    2.0,
    /*    Corner Freq 2 Hz */    6.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    3,
    /*                Gain */    1.587927483e+02,
    /*    Number of Zeroes */    6,
    /*  Number of X Coeffs */    7,
    /*            X Coeffs */    { -1, 0, 3, 0, -3, 0, 1 },
    /*     Number of Poles */    6,
    /*  Number of Y Coeffs */    6, 
    /*            Y Coeffs */    { -0.4299088248, 2.7437089159, -7.5388551330, 11.4008521480, -10.0037256647, 4.8264173453 }
};

const static DigitalFilterTemplate butterworth3O_BP_40HzTo80Hz = {
    /*                 Tag */   14,                                      
    /*               Title */   "Butterworth BP 9",
    /*         Description */   "3rd Order Band Pass 4 Hz to 8 Hz",
    /*        Filter Class */   kFilterClassBandPass,
    /* Sample Frequency Hz */   60.0,
    /*    Corner Freq 1 Hz */    4.0,
    /*    Corner Freq 2 Hz */    8.0,
    /*           Freq 3 Hz */    0,
    /*               Order */    3,
    /*                Gain */    1.588057611e+02,
    /*    Number of Zeroes */    6,
    /*  Number of X Coeffs */    7,
    /*            X Coeffs */    { 1, 0, -2, 0, 1 },
    /*     Number of Poles */    6,
    /*  Number of Y Coeffs */    6, 
    /*            Y Coeffs */    { -0.4299088249, 2.4297719638, -6.2679091105, 9.2798667593, -8.3131139565, 4.2741755451 }
};

#endif
