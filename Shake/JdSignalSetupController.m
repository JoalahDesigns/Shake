//
//  JdSignalSetupController.m
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

#import "JdSignalSetupController.h"
#import "JdAxis.h"

#import "JdSineSignalCell.h"

#pragma mark - Implementation
@implementation JdSignalSetupController
{
    NSIndexPath* checkedIndexPath;  // Index path of currently checked cell
}

#pragma mark - Synthesize
@synthesize axis;
@synthesize headingName;
@synthesize table;
@synthesize dummySineSignalCell;

#pragma mark - Instance Methods

// Initialise the class
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Signal Source";
        checkedIndexPath = nil;
        dummySineSignalCell = nil;
    }
    return self;
}

// Update the configuration items when the NIB objects become available
- (void)viewDidLoad
{
    [super viewDidLoad];
    headingName.text = axis.axisName;
}

// When coming back from changing configuration items,
// force a redisplay of the new data
-(void)viewWillAppear:(BOOL)animated
{
    [table reloadData];
}

// This App only supports portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// The list of Signal Sources only has one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// The list of Signal Sources has a fixed number of entries
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kSIGNALNAMECOUNT;
}

// The height of the cells in the Signal Source table will depend on the cell type being displayed
// The Sine Wave Signal Generator cell has its own cell height
// All other cells have teh default cell height for this style of table
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ((SignalSourceEnum)indexPath.row) {
        case kSignalSine: return [JdSineSignalCell rowHeight]; break;
            
        default: return 44.0; break;
    }
    
}

// Get a new cell for each type of Signal Source, and set the basic values
// Sine Wave Cells have to be brought in trhough a dummy property value,
// But once in are treated the same as oher cells
// If this is the Signal Source currently in use then set the cell's checkmark
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    NSString* CellIdentifier = nil;
    
    JdSineSignalCell* sineCell = nil;
    UITableViewCell* cell = nil;

    switch ((SignalSourceEnum)indexPath.row) {
        case kSignalSine:
            CellIdentifier = [JdSineSignalCell cellIdentifier];
            if((sineCell = (JdSineSignalCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier])==nil)
            {
                [[NSBundle mainBundle] loadNibNamed:[JdSineSignalCell nibName] owner:self options:nil];
                sineCell = dummySineSignalCell;
                dummySineSignalCell = nil;
            }
            
            sineCell.axis = axis;
            sineCell.navigationItem = self.navigationItem;
            sineCell.navigationController = self.navigationController;
            cell = sineCell;
            break;
            
        default:
            CellIdentifier = @"Cell";
            if((cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier])==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = [axis signalNameForSource:(SignalSourceEnum)indexPath.row];
            cell.detailTextLabel.text = [axis signalDescriptionForSource:(SignalSourceEnum)indexPath.row];
            
            break;
    }
    
    if (((SignalSourceEnum)indexPath.row)==axis.signalSource) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        checkedIndexPath = indexPath;
    }
    
    return cell;
}

// When the user selects a different Signal Source cell
// Deselect the current cell
// Uncheck the previously checked cell 
// Then check the new cell
// And set the current Signal Source to the newly selected source
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
    
    
    axis.signalSource = (SignalSourceEnum)indexPath.row;
    
    checkedIndexPath = indexPath;
}


@end
