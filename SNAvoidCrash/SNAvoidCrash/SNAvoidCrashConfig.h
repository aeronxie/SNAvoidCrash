//
//  SNAvoidCrashConfig.h
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/7.
//  Copyright © 2017年 SINA. All rights reserved.
//

#ifndef SNAvoidCrashConfig_h
#define SNAvoidCrashConfig_h

#define SNSWIZZLEWITHCLASS(cls, originalSelector, swizzleSelector) { \
		Class class;\
		if (cls) { \
			class = cls; \
		} else { \
			class = [self class]; \
		} \
		Method originalMethod = class_getInstanceMethod(class, originalSelector);\
		Method swizzleMethod = class_getInstanceMethod(class, swizzleSelector);\
		BOOL didAddMethod = class_addMethod(class, \
											originalSelector, \
											method_getImplementation(swizzleMethod),\
											method_getTypeEncoding(swizzleMethod));\
		\
		if (didAddMethod) { \
			class_replaceMethod(class, \
								swizzleSelector, \
								method_getImplementation(originalMethod),\
								method_getTypeEncoding(originalMethod));\
		} else {\
			method_exchangeImplementations(originalMethod, swizzleMethod);\
		}\
}


#endif /* SNAvoidCrashConfig_h */
