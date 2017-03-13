//
//  ViewController.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/7.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "CrashTest.h"
#import "SNVoidCrashManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[[CrashTest new] crashTest];
	
	NSArray *arr = @[@"1",@"2"];
	[arr objectAtIndex:2];
	
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
