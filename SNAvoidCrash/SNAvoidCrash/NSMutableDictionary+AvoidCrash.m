//
//  NSMutableDictionary+AvoidCrash.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/13.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import "NSMutableDictionary+AvoidCrash.h"
#import "SNAvoidCrashConfig.h"
#import "SNVoidCrashManager.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (AvoidCrash)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethod];
	});
}

+ (void)exchangeMethod {

	Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
	
	SEL oriSetObject = @selector(setObject:forKey:);
	SEL swiSetObject = @selector(sn_setObject:forKey:);
	SNSWIZZLEWITHCLASS(dictionaryM, oriSetObject, swiSetObject);
	
	SEL oriRemoveObject = @selector(removeObjectForKey:);
	SEL swiRemoveObject = @selector(sn_removeObjectForKey:);
	SNSWIZZLEWITHCLASS(dictionaryM, oriRemoveObject, swiRemoveObject);
}



- (void)sn_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
	
	@try {
		[self sn_setObject:anObject forKey:aKey];
	}
	@catch (NSException *exception) {
		[SNVoidCrashManager errorWithException:exception errorSituation:@"set nil value for dictionary"];
	}
	@finally {
	}
}

- (void)sn_removeObjectForKey:(id)aKey {
	
	@try {
		[self sn_removeObjectForKey:aKey];
	}
	@catch (NSException *exception) {
		[SNVoidCrashManager errorWithException:exception errorSituation:@"void crash for removeObjectForKey"];
	}
	@finally {
	}
}


@end
