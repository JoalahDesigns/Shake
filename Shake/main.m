//
//  main.m
//  Shake
//
//  Created by Peter Milway on 6/11/12.
//  Copyright (c) 2012 Joalah Designs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JdAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        int retVal = 0;
        @try {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([JdAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"Exception - %@",[exception description]);
            exit(EXIT_FAILURE);
        }
    }
}
