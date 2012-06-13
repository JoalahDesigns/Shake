//
//  JdAxisSetupController.m
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

#import "JdAxisSetupController.h"
#import "JdAxis.h"
#import "JdSignalSetupController.h"
#import "JdFilterSetupController.h"
#import "JdDetectionSetupController.h"

#pragma mark - Constants
typedef enum
{
    kSignalSource,
    kFilterType,
    kDetection,
    kROWNAMEENUMCOUNT
} RowNameEnum;

static const char* rowNames[kROWNAMEENUMCOUNT] = {
    "Signal Source",
    "Filter Type",
    "Level Detection",
};

#pragma mark - Implementation
@implementation JdAxisSetupController
{
    UISwitch* confirmSwitch;    // Confirm whether all physical axes should be overwritten by "All Axis" configuration
}

#pragma mark - Synthesize
@synthesize axis;
@synthesize headingName;
@synthesize table;

#pragma mark - Instance Methods

// Initialise the class
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Axis Setup";
    }
    return self;
}

// The user has chnaged the state of the confirmation to 
// write the "All Axes" configuration over the X, Y and Z axes
- (void) confirmChange: (id) sender {
    UISwitch *thisSwitch = (UISwitch *) sender;
    if (axis.allConfig) {
        axis.allConfigConfirm = thisSwitch.on;
    }
}

// Update the configuration items when the NIB objects become available
// If this is the "All Axes" configuration, 
// then manually add the confirmation switch and message
// Also default the confirmation switch to NO
// So that the X, Y and Z data isn't automatically overwritten
- (void)viewDidLoad
{
    [super viewDidLoad];
    headingName.text = axis.axisName;
    
    confirmSwitch = nil;
    if (axis.allConfig) {
        
        UILabel* confirmText = [[UILabel alloc] initWithFrame:CGRectMake(20, 262, 200, 90)];
        confirmText.numberOfLines = 4;
        confirmText.text = @"Confirm overwriting complete X, Y and Z Axis configuration with these values.";
        confirmText.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:confirmText];
        
        confirmSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(231, 284, 79, 27)];
        confirmSwitch.on = NO;
        [confirmSwitch addTarget: self action: @selector(confirmChange:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:confirmSwitch];
        
    }
}

// When coming back from changing configuration items,
// force a redisplay of the new data
// Also default the confirmation switch to NO
// So that the X, Y and Z data isn't automatically overwritten
-(void)viewWillAppear:(BOOL)animated
{
    confirmSwitch.on = NO;
    [table reloadData];
}

// This App only supports portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// The list of axis configuration sections has only one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// There are 3 possible areas of configuration for an axis
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


// Get a new cell for each section of axis configuration, and set the basic values
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    // Set up the cell...
    cell.textLabel.text = [NSString stringWithUTF8String:rowNames[indexPath.row]];
    
    switch ((RowNameEnum)indexPath.row) {
        case kSignalSource:
            cell.detailTextLabel.text = axis.signalSummary;
            break;
            
        case kFilterType:
            cell.detailTextLabel.text = axis.filterSummary;
            break;
            
        case kDetection:
            cell.detailTextLabel.text = axis.detectionSummary;
            break;
            
        default:
            cell.detailTextLabel.text = @"details";
            break;
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


// When the user selects a different section of an axis to configure
// Deselect the row,
// Set up the requisite view controller
// And navigate to that View Controller
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Back" 
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    
    
    id nextController= nil;
    JdSignalSetupController* signalController;
    JdFilterSetupController* filterController;
    JdDetectionSetupController* detectController;
    switch ((RowNameEnum)indexPath.row) {
        case kSignalSource:
            signalController = [[JdSignalSetupController alloc] init];
            signalController.axis = axis;
            nextController = signalController;
            break;
            
        case kFilterType:
            filterController = [[JdFilterSetupController alloc] init];
            filterController.axis = axis;
            nextController = filterController;
            break;
            
        case kDetection:
            detectController = [[JdDetectionSetupController alloc] init];
            detectController.axis = axis;
            nextController = detectController;
            break;
            
        default:
            break;
    }
    
    if (nextController) {
        [self.navigationController pushViewController:nextController animated:YES];
    }
}



@end
