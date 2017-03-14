//
//  AvoidRefreshViewNotMainThreadCrash.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/7.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import "AvoidRefreshViewNotMainThreadCrash.h"
#import <objc/runtime.h>
#import "SNVoidCrashManager.h"

@implementation AvoidRefreshViewNotMainThreadCrash

- (void)sn_setNeedsLayout{
	
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
		
		[self sn_setNeedsLayout];
	} else {
		NSException *exception = [[NSException alloc]initWithName:@"SetNeedsLayout" reason:[NSString stringWithFormat:@"%s try to update UI not on main thread %@ ",__FUNCTION__, self] userInfo:nil];
		[SNVoidCrashManager errorWithException:exception errorSituation:@"setNeedsLayout not main thread"];
		dispatch_async(dispatch_get_main_queue(),^{
			[self sn_setNeedsLayout];
		});
	}
}


- (void)sn_setNeedsDisplay{
	
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
		
		[self sn_setNeedsDisplay];
		
	} else {
		
		NSException *exception = [[NSException alloc]initWithName:@"SetNeedsDisplay" reason:[NSString stringWithFormat:@"%s try to update UI not on main thread %@ ",__FUNCTION__, self] userInfo:nil];
		[SNVoidCrashManager errorWithException:exception errorSituation:@"SetNeedsDisplay not main thread"];
	
		dispatch_async(dispatch_get_main_queue(),^{
			[self sn_setNeedsDisplay];
		});
	}
}


- (void)sn_setNeedsDisplayInRect:(CGRect)rect{
	
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {

		[self sn_setNeedsDisplayInRect:rect];
		
	} else {
		
		NSException *exception = [[NSException alloc]initWithName:@"SetNeedsDisplayInRect" reason:[NSString stringWithFormat:@"%s try to update UI not on main thread %@ ",__FUNCTION__, self] userInfo:nil];
		[SNVoidCrashManager errorWithException:exception errorSituation:@"SetNeedsDisplayInRect not main thread"];
		dispatch_async(dispatch_get_main_queue(),^{
			[self sn_setNeedsDisplayInRect:rect];
		});
	}
}

- (void)sn_setNeedsUpdateConstraints{
	
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
		
		[self sn_setNeedsUpdateConstraints];
		
	} else {
		
		NSException *exception = [[NSException alloc]initWithName:@"SetNeedsUpdateConstraints" reason:[NSString stringWithFormat:@"%s try to update UI not on main thread %@ ",__FUNCTION__, self] userInfo:nil];
		[SNVoidCrashManager errorWithException:exception errorSituation:@"SetNeedsUpdateConstraints not main thread"];
		dispatch_async(dispatch_get_main_queue(),^{
			[self sn_setNeedsUpdateConstraints];
		});
	}
}


@end
