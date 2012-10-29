//
//  JdFilterBase.m
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

#import "JdFilterBase.h"

#pragma mark - Implementation
@implementation JdFilterBase

#pragma mark - Synthesize
@synthesize tag;
@synthesize input = _input;
@synthesize output = _output;
@synthesize name = _name;
@synthesize description = _description;

#pragma mark - Instance Methods

// Initialise this base class
-(id)init
{
    if(!(self = [super init])) return self;
    
    tag = 0;
    _name = @"Pass Through";
    _description = @"Passes data through without filtering";
    [self reset];
    
    return self;
}

// Calculate the reseponse of the filter
// The expectation is that the sub-classed filters will override this method
-(double)calculate
{
    return _input;
}

// Calculate the response to a new input, and return that result.
// If the sub-classed filters have over-ridden the calculate method
// then the specific filters calculate method will be called from here
-(double)newInput:(double)data
{
    _input = data;
    _output = [self calculate];
    return _output;
}


// Calculate the response to a new input.
// If the sub-classed filters have over-ridden the calculate method
// then the specific filters calculate method will be called from here
-(void)setInput:(double)inputData
{
    _input = inputData;
    _output = [self calculate];
}

// Reset all calculate data in this class
-(void)reset
{
    _input = 0.0;
    _output = 0.0;
}

// Create an independent copy of this filter
-(id)copyWithZone:(NSZone *)zone
{
    return [[JdFilterBase alloc] init];
}

@end
