//
//  NSMutableArray+AvoidCrash.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/13.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import "NSMutableArray+AvoidCrash.h"
#import "SNAvoidCrashConfig.h"
#import "SNVoidCrashManager.h"
#import <objc/runtime.h>

@implementation NSMutableArray (AvoidCrash)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethod];
	});
}

+ (void)exchangeMethod {
	Class classM = NSClassFromString(@"__NSArrayM");
	SEL oriObjectAtIndex = @selector(objectAtIndex:);
	SEL swiObjectAtIndex = @selector(sn_objectAtIndex:);
	SNSWIZZLEWITHCLASS(classM, oriObjectAtIndex, swiObjectAtIndex);
	
	SEL oriInsertObject = @selector(insertObject:atIndex:);
	SEL swiInsertObject = @selector(sn_insertObject:atIndex:);
	SNSWIZZLEWITHCLASS(classM, oriInsertObject, swiInsertObject);
	
	SEL oriRemoveObject = @selector(removeObjectAtIndex:);
	SEL swiRemoveObject = @selector(sn_removeObjectAtIndex:);
	SNSWIZZLEWITHCLASS(classM, oriRemoveObject, swiRemoveObject);
	
	SEL oriGetObjects = @selector(getObjects:range:);
	SEL swiGetObjects = @selector(sn_getObjects:range:);
	SNSWIZZLEWITHCLASS(classM, oriGetObjects, swiGetObjects);
}

- (id)sn_objectAtIndex:(NSUInteger)index {
	
	id object = nil;
	
	@try {
		object = [self sn_objectAtIndex:index];
	}
	@catch (NSException *exception) {
		[SNVoidCrashManager errorWithException:exception errorSituation:@"index cross the border"];
	}
	@finally {
		return object;
	}
}

- (void)sn_insertObject:(id)anObject atIndex:(NSUInteger)index {
	@try {
		[self sn_insertObject:anObject atIndex:index];
	}
	@catch (NSException *exception) {
		[SNVoidCrashManager errorWithException:exception errorSituation:@"insert nil"];
	}
	@finally {
		
	}
}

- (void)sn_removeObjectAtIndex:(NSUInteger)index {
	@try {
		[self sn_removeObjectAtIndex:index];
	}
	@catch (NSException *exception) {
		[SNVoidCrashManager errorWithException:exception errorSituation:@"avoid crash"];
	}
	@finally {
		
	}
}

- (void)sn_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
	
	@try {
		[self sn_getObjects:objects range:range];
	} @catch (NSException *exception) {
	
		[SNVoidCrashManager errorWithException:exception errorSituation:@"index cross the border"];
		
	} @finally {
		
	}
}


@end
