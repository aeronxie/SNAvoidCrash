//
//  NSObject+AvoidSelectorNotFoundCrash.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/7.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import "NSObject+AvoidSelectorNotFoundCrash.h"
#import <objc/runtime.h>
#import "SNAvoidCrashConfig.h"

@interface DoNothingSelectorClass : NSObject

+ (instancetype)sharedInstance;

@end

@implementation DoNothingSelectorClass

+ (instancetype)sharedInstance {
	
	static DoNothingSelectorClass *class = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		class = [[self alloc] init];
	});
	return class;
}

void doNothingSelector() {}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
	class_addMethod([self class], sel,(IMP)doNothingSelector,"v@:");
	return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
	class_addMethod([self class], sel, (IMP)doNothingSelector, "v@:");
	return YES;
}

@end

@implementation NSObject (AvoidSelectorNotFoundCrash)


+(void)load{
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethodSignature];
		[self exchangeForwardInvocation];
	});
	
}

+ (void)exchangeMethodSignature {
	SEL originalSelector = @selector(methodSignatureForSelector:);
	SEL swizzleSelector = @selector(sn_methodSignatureForSelector:);
	
	SNSWIZZLE(originalSelector,swizzleSelector);
}

+ (void)exchangeForwardInvocation {
	SEL originalSelector = @selector(forwardInvocation:);
	SEL swizzleSelector = @selector(sn_forwardInvocation:);
	
	SNSWIZZLE(originalSelector,swizzleSelector);
}

- (NSMethodSignature *)sn_methodSignatureForSelector:(SEL)sel{
	
	NSMethodSignature *signature;
	signature = [self sn_methodSignatureForSelector:sel];
	if (signature) {
		return signature;
	}
	
	signature = [[DoNothingSelectorClass sharedInstance] sn_methodSignatureForSelector:sel];
	if (signature){
		return signature;
	}
	
	return nil;
}

- (void)sn_forwardInvocation:(NSInvocation *)anInvocation{
	[anInvocation invokeWithTarget:[DoNothingSelectorClass sharedInstance]];
	NSLog(@"******* unrecognized selctor invoked %@ ", self);
}


@end
