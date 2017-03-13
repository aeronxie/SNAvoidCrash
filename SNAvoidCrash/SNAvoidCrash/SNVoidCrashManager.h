//
//  SNVoidCrashManager.h
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/13.
//  Copyright © 2017年 SINA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNVoidCrashManager : NSObject

/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *
 *  @param callStackSymbols 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */
+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols;


/**
 *  提示崩溃的信息(控制台输出、通知)
 *
 *  @param exception   捕获到的异常
 *  @param errorSituation 错误的情况
 */

+ (void)errorWithException:(NSException *)exception errorSituation:(NSString *)errorSituation;

@end
