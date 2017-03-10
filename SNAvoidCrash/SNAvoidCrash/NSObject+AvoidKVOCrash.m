//
//  NSObject+AvoidKVOCrash.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/7.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import "NSObject+AvoidKVOCrash.h"
#import <objc/runtime.h>
#import "SNAvoidCrashConfig.h"

static const void *mapKey = &mapKey;

@interface NSObject()

@property (nonatomic,strong) NSMapTable<id, NSHashTable<NSString *> *> *map;

@end

@implementation NSObject (AvoidKVOCrash)

- (NSMapTable<id,NSHashTable<NSString *> *> *)map {
	NSMapTable *map = objc_getAssociatedObject(self, &mapKey);
	if (map) {
		return map;
	} else {
		map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
		objc_setAssociatedObject(self, &mapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		return map;
	}
}

- (void)setMap:(NSMapTable<id,NSHashTable<NSString *> *> *)map {
	if (map) {
		objc_setAssociatedObject(self, mapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self addObserver];
		[self removeObserver];
	});
}

/**
  * AddObserver
 */
+ (void)addObserver {
	
	SEL originalSelector = @selector(addObserver:forKeyPath:options:context:);
	SEL swizzleSelector = @selector(sn_addObserver:forKeyPath:options:context:);
	
	SNSWIZZLE(originalSelector, swizzleSelector);
}

- (void)sn_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
	
	if (!observer || !keyPath) {
		return;
	}

	NSHashTable *hashTable = [self.map objectForKey:observer];
	
	if (!hashTable) {
		hashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
		[hashTable addObject:keyPath];
		[self.map setObject:hashTable forKey:observer];
		[self sn_addObserver:observer forKeyPath:keyPath options:options context:context];
		return;
	}
	
	if ([hashTable containsObject:keyPath]) {
		NSLog(@"%s ******* don't add the same observer and keypath %@ ",__FUNCTION__, self);
		return;
	}
	
	[hashTable addObject:keyPath];
	[self sn_addObserver:observer forKeyPath:keyPath options:options context:context];
	
}


/**
  * RemoveObserver
 */
+ (void)removeObserver {
	SEL originalSelector = @selector(removeObserver:forKeyPath:);
	SEL swizzleSelector = @selector(sn_removeObserver:forKeyPath:);
	SNSWIZZLE(originalSelector, swizzleSelector);
}


- (void)sn_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {

	if(!observer || !keyPath){
		return;
	}

	NSHashTable *hashTable = [self.map objectForKey:observer];
	if (!hashTable) {
		return;
	}
	if (![hashTable containsObject:keyPath]) {
		NSLog(@"%s ******* don't remove the keypath not existed %@ ",__FUNCTION__, self);
		return;
	}
	[hashTable removeObject:keyPath];
	[self sn_removeObserver:observer forKeyPath:keyPath];

}

@end
