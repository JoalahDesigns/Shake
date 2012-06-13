//
//  JdMainController.m
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

#import "JdMainController.h"
#import "JdConfiguration.h"
#import "JdMasterControl.h"

#import "JdSetupNavigation.h"
#import "JdOverallSetupController.h"
#import "JdCreditsController.h"

#import "JdAxis.h"
#import "JdAxisList.h"

#import "JdRMS.h"

#pragma mark - Private Interface
@interface JdMainController ()
-(void)pauseState:(BOOL)value;
-(void)appWillResignActive;
-(void)appWillTerminate;
@end

#pragma mark - Implementation
@implementation JdMainController
{
    BOOL pause;                         // Is the data collection/display paused?
    JdConfiguration* configuration;     // Configuration data for all axes
    JdMasterControl* masterControl;     // Overall control of data collection, filtering and display
}

#pragma mark - Synthesize
@synthesize run_pause;
@synthesize xAxisSummary;
@synthesize yAxisSummary;
@synthesize zAxisSummary;
@synthesize xAxisGraph;
@synthesize yAxisGraph;
@synthesize zAxisGraph;

#pragma mark - Instance Methods

// Initialise the class and create the configuration data 
// As well as the master control (which creates the data for each axis)
// Register for notifcations so we can pause when App goes into background
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self pauseState:YES];
        configuration = [[JdConfiguration alloc] init];
        masterControl = [[JdMasterControl alloc] initWithConfiguration:configuration];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

// Update the configuration items when the NIB objects become available
// And start off in the Paused state
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pauseState:YES];
    masterControl.pause = pause;
    masterControl.xAxisGraph = xAxisGraph;
    masterControl.yAxisGraph = yAxisGraph;
    masterControl.zAxisGraph = zAxisGraph;
    
}

// When coming back from changing configuration items,
// Ensure that the new data is displayed
-(void)viewWillAppear:(BOOL)animated
{
    
    JdAxis* axis;
    
    axis = [configuration objectForAxis:kAxisX];
    xAxisSummary.text = axis.setupSummary;
    
    axis = [configuration objectForAxis:kAxisY];
    yAxisSummary.text = axis.setupSummary;
    
    axis = [configuration objectForAxis:kAxisZ];
    zAxisSummary.text = axis.setupSummary;
}


// This App only supports portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Set the pause stat eon both the UI and the underlying objects
-(void)pauseState:(BOOL)value
{
    pause = value;
    if (pause) {
        [run_pause setTitle:@"Run" forState:UIControlStateNormal];
    } else {
        [run_pause setTitle:@"Pause" forState:UIControlStateNormal];
    }
    masterControl.pause = pause;
}

// When the App goes into background, pause the data collection
-(void)appWillResignActive
{
    [self pauseState:YES];
}

// When the App terminates, remove the notification observation
-(void)appWillTerminate
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

// The User wants to toggle the Pause state
-(IBAction)run_pausePressed:(id)sender
{
    [self pauseState:!pause];
}

// The user wants to navigate to the configuration screens
// So pause the data collection
// And navigate to the configuration screen
-(IBAction)setupPressed:(id)sender
{
    
    JdOverallSetupController* overallSetup = [[JdOverallSetupController alloc] init];
    overallSetup.configuration = configuration;
    JdSetupNavigation* navControl = [[JdSetupNavigation alloc] initWithRootViewController:overallSetup];

    [self pauseState:YES];

    [self presentModalViewController:navControl animated:YES];
    
}

// The user wants to see the credits for this App
// So pause the data collection
// And navigate to the configuration screen
-(IBAction)creditsPressed:(id)sender
{
    JdCreditsController* creditsController = [[JdCreditsController alloc] init];
    [self pauseState:YES];
    [self presentModalViewController:creditsController animated:YES];
}



@end
