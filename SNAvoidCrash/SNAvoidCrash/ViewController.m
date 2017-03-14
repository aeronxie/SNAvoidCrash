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

@implementation ViewController {
	CrashTest *_test;
	UILabel *_testLabel;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_testLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
	[self.view addSubview:_testLabel];
	
	[self test6];
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

- (void)test4 {
	_test = [[CrashTest alloc] init];
	_test.name = @"crashTest";
	[_test addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
	[_test addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
	[_test addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
	[_test addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)test5 {

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		_testLabel.text = @"that is right";
	});

}

- (void)test6 {
	
	NSMutableDictionary *dic = @{@"a":@"a1",@"b":@"b1"}.mutableCopy;
	[dic setObject:nil forKey:@"c"];
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[_test removeObserver:self forKeyPath:@"name"];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
