//
//  JdDetectionSetupController.m
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

#import "JdDetectionSetupController.h"
#import "JdAxis.h"

#pragma mark - Private Interface
@interface JdDetectionSetupController ()
-(void)updateCalculationWindow:(uint)value andObject:(BOOL)andObject;
-(void)updateDetectionWindow:(uint)value andObject:(BOOL)andObject;
-(void)updateDetectionLevel:(double)value andObject:(BOOL)andObject;
@end

#pragma mark - Implementation
@implementation JdDetectionSetupController

#pragma mark - Synthesize
@synthesize axis;
@synthesize headingName;

@synthesize calculationWindow;
@synthesize detectionWindow;
@synthesize detectionLevel;

@synthesize calculationSlider;
@synthesize detectionWindowSlider;
@synthesize detectionLevelSlider;

#pragma mark - Instance Methods

// Initialise the class
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Level Detection";
    }
    return self;
}

// Update the configuration items when the NIB objects become available
- (void)viewDidLoad
{
    [super viewDidLoad];
    headingName.text = axis.axisName;
    
    calculationSlider.value = axis.calculationWindow;
    detectionWindowSlider.value = axis.detectionWindow;
    detectionLevelSlider.value = axis.detectionLevel;
    
    [self updateCalculationWindow:axis.calculationWindow andObject:NO];
    [self updateDetectionWindow:axis.detectionWindow andObject:NO];
    [self updateDetectionLevel:axis.detectionLevel andObject:NO];
    
}

// Update the UI and axis configuration for the RMS Calculation Window as required
-(void)updateCalculationWindow:(uint)value andObject:(BOOL)andObject
{
    calculationWindow.text = [NSString stringWithFormat:@"%d",value];
    if (andObject) {
        axis.calculationWindow = value;
    }
}

// Update the UI and axis configuration for the RMS Detection Window as required
-(void)updateDetectionWindow:(uint)value andObject:(BOOL)andObject
{
    detectionWindow.text = [NSString stringWithFormat:@"%d",value];
    if (andObject) {
        axis.detectionWindow = value;
    }
}

// Update the UI and axis configuration for the RMS Detection Level as required
-(void)updateDetectionLevel:(double)value andObject:(BOOL)andObject
{
    detectionLevel.text = [NSString stringWithFormat:@"%0.1f",value];
    if (andObject) {
        axis.detectionLevel = value;
    }
}

// This App only supports portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// The user has changed the RMS Calculation Window value
- (IBAction) calculationSliderChanged:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    [self updateCalculationWindow:(uint)([slider value]) andObject:YES];
}

// The user has changed the RMS Detection Window value
- (IBAction)detectionWindowSliderChanged:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    [self updateDetectionWindow:(uint)([slider value]) andObject:YES];
}

// The user has changed the RMS Detection Level value
- (IBAction) detectionLevelSliderChanged:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    [self updateDetectionLevel:[slider value] andObject:YES];
}


@end
