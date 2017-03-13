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
	
	[self test3];
}

- (void)test1 {
	// 找不到方法实现
	[[CrashTest new] crashTest];
}

- (void)test2 {
	// index 越界
	NSArray *arr = @[@"1",@"2"];
	[arr objectAtIndex:2];
}

- (void)test3 {
	// 插入为nil
	NSMutableArray *arr = @[@"1",@"2"].mutableCopy;
	[arr addObject:nil];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
