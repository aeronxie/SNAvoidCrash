//
//  NSArray+AvoidCrash.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/7.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import "NSArray+AvoidCrash.h"
#import "SNAvoidCrashConfig.h"
#import "SNVoidCrashManager.h"
#import <objc/runtime.h>

@implementation NSArray (AvoidCrash)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethod];
	});
}

+ (void)exchangeMethod {
	
	Class __NSArray = NSClassFromString(@"NSArray");
	Class __NSArrayI = NSClassFromString(@"__NSArrayI");
	Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
	Class __NSArray0 = NSClassFromString(@"__NSArray0");
	
	SEL oriObjectAtIndex = @selector(objectAtIndex:);
	SEL swiObjectAtIndexI = @selector(sn_objectAtIndexI:);
	SEL swiObjectAtIndexSingleObjectArrayI = @selector(sn_objectAtIndexSingle:);
	SEL swiObjectAtIndex0 = @selector(sn_objectAtIndex0:);
	
	SNSWIZZLEWITHCLASS(__NSArrayI, oriObjectAtIndex, swiObjectAtIndexI);
	SNSWIZZLEWITHCLASS(__NSSingleObjectArrayI, oriObjectAtIndex, swiObjectAtIndexSingleObjectArrayI);
	SNSWIZZLEWITHCLASS(__NSArray0, oriObjectAtIndex, swiObjectAtIndex0);
	
	SEL oriObjectsAtIndexes = @selector(objectsAtIndexes:);
	SEL swiObjectsAtIndexes = @selector(sn_objectsAtIndexes:);
	SNSWIZZLEWITHCLASS(__NSArray, oriObjectsAtIndexes, swiObjectsAtIndexes);
	
	SEL oriGetObjects = @selector(getObjects:range:);
	SEL swiGetObjects0 = @selector(sn_getObjects0:range:);
	SEL swiGetObjectsI = @selector(sn_getObjectsI:range:);
	SEL swiGetObjectsSingle = @selector(sn_getObjectsSingle:range:);
	
	SNSWIZZLEWITHCLASS(__NSArray, oriGetObjects, swiGetObjects0);
	SNSWIZZLEWITHCLASS(__NSSingleObjectArrayI, oriGetObjects, swiGetObjectsI);
	SNSWIZZLEWITHCLASS(__NSArrayI, oriGetObjects, swiGetObjectsSingle);

	SEL oriArrayWithObjects = @selector(arrayWithObjects:count:);
	SEL swiArrayWithObjects = @selector(sn_arrayWithObjects:count:);
	SNSWIZZLEWITHCLASS(nil, oriArrayWithObjects, swiArrayWithObjects);
}


- (NSArray *)sn_objectsAtIndexes:(NSIndexSet *)indexes {
	NSArray *returnArray = nil;
	@try {
		returnArray = [self sn_objectsAtIndexes:indexes];
	} @catch (NSException *exception) {
		[SNVoidCrashManager errorWithException:exception errorSituation:[NSString stringWithFormat:@"%s",__FUNCTION__]];
	} @finally {
		return returnArray;
	}

}

- (id)sn_objectAtIndex0:(NSUInteger)index {

	id object = nil;
	@try {
		object = [self sn_objectAtIndex0:index];
	} @catch (NSException *exception) {
		NSString *info = [NSString stringWithFormat:@"%s",__FUNCTION__];
		[SNVoidCrashManager errorWithException:exception errorSituation:info];
	} @finally {
		return object;
	}
}

- (id)sn_objectAtIndexI:(NSUInteger)index {
	
	id object = nil;
	@try {
		object = [self sn_objectAtIndexI:index];
	} @catch (NSException *exception) {
		NSString *info = [NSString stringWithFormat:@"%s",__FUNCTION__];
		[SNVoidCrashManager errorWithException:exception errorSituation:info];
	} @finally {
		return object;
	}
}

- (id)sn_objectAtIndexSingle:(NSUInteger)index {
	
	id object = nil;
	@try {
		object = [self sn_objectAtIndexSingle:index];
	} @catch (NSException *exception) {
		NSString *info = [NSString stringWithFormat:@"%s",__FUNCTION__];
		[SNVoidCrashManager errorWithException:exception errorSituation:info];
	} @finally {
		return object;
	}
}


+ (instancetype)sn_arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)count {
	id instance = nil;
	
	@try {
		instance = [self sn_arrayWithObjects:objects count:count];
	}
	@catch (NSException *exception) {
		
		[SNVoidCrashManager errorWithException:exception errorSituation:@"初始化数组不能为空"];
		
		//以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
		NSInteger newObjsIndex = 0;
		id  _Nonnull __unsafe_unretained newObjects[count];
		
		for (int i = 0; i < count; i++) {
			if (objects[i] != nil) {
				newObjects[newObjsIndex] = objects[i];
				newObjsIndex++;
			}
		}
		instance = [self sn_arrayWithObjects:newObjects count:newObjsIndex];
	}
	@finally {
		return instance;
	}
	
}

- (void)sn_getObjects0:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
	@try {
		[self sn_getObjects0:objects range:range];
	} @catch (NSException *exception) {

		[SNVoidCrashManager errorWithException:exception errorSituation:@"avoid crash --- sn_getObjects"];
	} @finally {
	}
}

- (void)sn_getObjectsI:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
	@try {
		[self sn_getObjectsI:objects range:range];
	} @catch (NSException *exception) {
		
		[SNVoidCrashManager errorWithException:exception errorSituation:@"avoid crash --- sn_getObjects"];
	} @finally {
	}
}

- (void)sn_getObjectsSingle:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
	@try {
		[self sn_getObjectsSingle:objects range:range];
	} @catch (NSException *exception) {
		
		[SNVoidCrashManager errorWithException:exception errorSituation:@"avoid crash --- sn_getObjects"];
	} @finally {
	}
}


@end
