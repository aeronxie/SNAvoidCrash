//
//  AvoidRefreshViewNotMainThreadCrash.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/7.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import "AvoidRefreshViewNotMainThreadCrash.h"
#import <objc/runtime.h>

@implementation AvoidRefreshViewNotMainThreadCrash

- (void)sn_setNeedsLayout{
	
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
		
		[self sn_setNeedsLayout];
	} else {
		NSLog(@"%s ******* try to update UI not on main thread %@ ",__FUNCTION__, self);
		dispatch_async(dispatch_get_main_queue(),^{
			[self sn_setNeedsLayout];
		});
	}
}


- (void)sn_setNeedsDisplay{
	
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
		
		[self sn_setNeedsDisplay];
		
	} else {
		
		NSLog(@"%s ******* try to update UI not on main thread %@ ",__FUNCTION__, self);
		dispatch_async(dispatch_get_main_queue(),^{
			[self sn_setNeedsDisplay];
		});
	}
}


- (void)sn_setNeedsDisplayInRect:(CGRect)rect{
	
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {

		[self sn_setNeedsDisplayInRect:rect];
		
	} else {
		NSLog(@"%s ******* try to update UI not on main thread %@ ",__FUNCTION__, self);
		dispatch_async(dispatch_get_main_queue(),^{
			[self sn_setNeedsDisplayInRect:rect];
		});
	}
}

- (void)sn_setNeedsUpdateConstraints{
	
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
		
		[self sn_setNeedsUpdateConstraints];
		
	} else {
		NSLog(@"%s ******* try to update UI not on main thread %@ ",__FUNCTION__, self);
		dispatch_async(dispatch_get_main_queue(),^{
			[self sn_setNeedsUpdateConstraints];
		});
	}
}


@end
