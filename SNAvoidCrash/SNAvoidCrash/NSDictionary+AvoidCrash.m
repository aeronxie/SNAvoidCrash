//
//  NSDictionary+AvoidCrash.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/13.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import "NSDictionary+AvoidCrash.h"
#import "SNAvoidCrashConfig.h"
#import "SNVoidCrashManager.h"
#import <objc/runtime.h>


@implementation NSDictionary (AvoidCrash)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethod];
	});
}

+ (void)exchangeMethod {
	
	SEL originalSelector = @selector(dictionaryWithObjects:forKeys:count:);
	SEL swizzleSelector = @selector(sn_dictionaryWithObjects:forKeys:count:);
	
	SNSWIZZLEWITHCLASS(nil, originalSelector, swizzleSelector);
	
}

+ (instancetype)sn_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cout {
	id instance = nil;
	
	@try {
		instance = [self sn_dictionaryWithObjects:objects forKeys:keys count:cout];
	}
	@catch (NSException *exception) {

		[SNVoidCrashManager errorWithException:exception errorSituation:@"avoid dic key-value is nil"];
		
		NSUInteger index = 0;
		id  _Nonnull __unsafe_unretained newObjects[cout];
		id  _Nonnull __unsafe_unretained newkeys[cout];
		
		for (int i = 0; i < cout; i++) {
			if (objects[i] && keys[i]) {
				newObjects[index] = objects[i];
				newkeys[index] = keys[i];
				index++;
			}
		}
		instance = [self sn_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
	}
	@finally {
		return instance;
	}
}

@end
