//
//  JdSineSignalCell.m
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

#import "JdSineSignalCell.h"
#import "JdAxis.h"

#import "JdSineSetupController.h"

#pragma mark - Implementation
@implementation JdSineSignalCell

#pragma mark - Synthesize
@synthesize navigationItem;
@synthesize navigationController;
@synthesize frequency;
@synthesize amplitude;
@synthesize axis;

#pragma mark - Instance Methods

// Initialise the class
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

// Set the axis being configured
// And update the Sine Generator's current Frequency and Amplitude
-(void)setAxis:(JdAxis*)value
{
    axis = value;
    frequency.text = [NSString stringWithFormat:@"%0.1f", axis.sineFrequency];
    amplitude.text = [NSString stringWithFormat:@"%0.1f", 2.0];
}

// The user wants to change the setup of the Sine Generator
// So navigate to the Sine Wave setup controller
-(IBAction)setPressed:(id)sender
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];

    JdSineSetupController* frequencyController = [[JdSineSetupController alloc] init];
    frequencyController.axis = axis;
    [self.navigationController pushViewController:frequencyController animated:YES];
}

#pragma mark - Class Methods

// Return the cell ID used for a custom Sine Signal Generator cell
+(NSString*)cellIdentifier
{
    return @"JdSineSignalCell";
}

// Return the NIB name used for a custom Sine Signal Generator cell
+(NSString*)nibName
{
    return @"JdSineSignalCell";
}

// Return the cell height for a custom Sine Signal Generator cell
+(float)rowHeight
{
    return 85.0f;
}


@end
