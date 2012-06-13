//
//  JdFilterSetupController.m
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

#import "JdFilterSetupController.h"
#import "JdAxis.h"

#pragma mark - Implementation
@implementation JdFilterSetupController
{
    NSIndexPath* checkedIndexPath;  // Index path of currently checked cell
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
        self.title = @"Filter Type";
        checkedIndexPath = nil;
    }
    return self;
}

// Update the configuration items when the NIB objects become available
- (void)viewDidLoad
{
    [super viewDidLoad];
    headingName.text = axis.axisName;
}

// This App only supports portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// The list of filters only has one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// The list of filters has a fixed number of entries
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kFILTERTYPECOUNT;
}

// Get a new cell for each type of filter, and set the basic values
// If this is the filter currently in use then set the cell's checkmark
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    // Set up the cell...
    cell.textLabel.text = [axis filterNameForType:(FilterTypeEnum)indexPath.row];
    cell.detailTextLabel.text = [axis filterDescriptionForType:(FilterTypeEnum)indexPath.row];
    
    if (((FilterTypeEnum)indexPath.row)==axis.filterType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        checkedIndexPath = indexPath;
    }
    
    return cell;
}

// When the user selects a different filter cell
// Deselect the current cell
// Uncheck the previously checked cell 
// Then check the new cell
// And set the current filter to the new filter type
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }    
    
    UITableViewCell* cellToCheck = [tableView cellForRowAtIndexPath:indexPath];
    cellToCheck.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    axis.filterType = (FilterTypeEnum)indexPath.row;
    
    checkedIndexPath = indexPath;
}



@end
