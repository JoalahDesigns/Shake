//
//  JdOverallSetupViewController.m
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

#import "JdOverallSetupController.h"
#import "JdConfiguration.h"
#import "JdAxisList.h"
#import "JdAxis.h"
#import "JdAxisSetupController.h"
#import "GraphView.h"

#pragma mark - Implementation
@implementation JdOverallSetupController
{
    JdAxis* lastAxis;   // Last axis that was congigured
}

#pragma mark - Synthesize
@synthesize configuration;
@synthesize frequency;
@synthesize table;

@synthesize signalColor;
@synthesize filteredColor;
@synthesize rmsColor;
@synthesize eventColor;

#pragma mark - Instance Methods

// Initialise the class
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Setup";
        lastAxis = nil;
    }
    return self;
}

// The User has requested to leave the configuration screen
// So honour their wishes
- (void) goBack: (id) sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

// Update the configuration items when the NIB objects become available
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    
    if (configuration) {
        frequency.text = [NSString stringWithFormat:@"%0.1f", [JdConfiguration sampleFrequencyDefault]];
        
    } else {
        frequency.text = @"??";
    }
    
    signalColor.textColor = [GraphView rawColor];
    filteredColor.textColor = [GraphView filteredColor];
    rmsColor.textColor = [GraphView rmsColor];
    eventColor.textColor = [GraphView triggeredColor];
}

// When coming back from changing configuration items,
// Check to see if the X, Y and Z data should be overwritten by the "All Axes" data
// If so then copy over each axis' configuration
// Then force a redisplay of the new data
-(void) viewWillAppear:(BOOL)animated
{
    if(lastAxis && lastAxis.allConfigConfirm) {
        // Overwrite all of the axis config data with the All Axis version!
        JdAxis* master = lastAxis;
        for(int i=0; i<kAXISCOUNT; i++) {
            JdAxis* axis = [configuration objectForAxis:i];
            
            axis.signalSource = master.signalSource;
            axis.sineFrequency = master.sineFrequency;
            
            axis.filterType = master.filterType;
            
            axis.calculationWindow = master.calculationWindow;
            axis.detectionWindow = master.detectionWindow;
            axis.detectionLevel = master.detectionLevel;
        }
     
        lastAxis = nil;
    }
    
    [table reloadData];
}

// This App only supports portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// The list of axes only has one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// The list of axis contains a fixed number of rows in the section
// One row for X, Y and Z, plus another for "All Axes"
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kAXISCOUNT+1;
}

// Get a new cell for each axis configuration, and set the basic values
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    JdAxis* axis = [configuration objectForAxis:indexPath.row];
    
    // Set up the cell...
    cell.textLabel.text = axis.axisName;
    cell.detailTextLabel.text = axis.setupSummary;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// When the user selects a different axis to configure
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
    
    JdAxisSetupController* axisController = [[JdAxisSetupController alloc] init];
    lastAxis = [configuration objectForAxis:indexPath.row];
    if (lastAxis.allConfig) {
        lastAxis.allConfigConfirm = NO;    
    }
    axisController.axis = lastAxis;
    [self.navigationController pushViewController:axisController animated:YES];
}





@end
