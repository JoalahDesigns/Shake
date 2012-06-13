//
//  JdMainController.h
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

#import <UIKit/UIKit.h>
#import "GraphView.h"

#pragma mark - Public Interface
@interface JdMainController : UIViewController

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UIButton* run_pause;     // Run/Pause button

@property(nonatomic,strong) IBOutlet UILabel* xAxisSummary;     // Summary text of x Axis
@property(nonatomic,strong) IBOutlet UILabel* yAxisSummary;     // Summary text of y Axis
@property(nonatomic,strong) IBOutlet UILabel* zAxisSummary;     // Summary text of z Axis

@property(nonatomic, strong) IBOutlet GraphView *xAxisGraph;    // Graph of x Axis
@property(nonatomic, strong) IBOutlet GraphView *yAxisGraph;    // Graph of y Axis
@property(nonatomic, strong) IBOutlet GraphView *zAxisGraph;    // Graph of z Axis

#pragma mark - Instance Methods
-(IBAction)run_pausePressed:(id)sender;
-(IBAction)setupPressed:(id)sender;
-(IBAction)creditsPressed:(id)sender;
@end
