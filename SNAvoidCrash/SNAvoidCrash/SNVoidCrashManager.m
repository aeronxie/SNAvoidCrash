//
//  SNVoidCrashManager.m
//  SNAvoidCrash
//
//  Created by shixi_xiefei on 2017/3/13.
//  Copyright © 2017年 SINA. All rights reserved.
//


#define AvoidCrashSeparator         @"😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂"
#define AvoidCrashSeparatorWithFlag @"😂😂😂😂😂😂😂😂😂😂😂😂AvoidCrash Log😂😂😂😂😂😂😂😂😂😂😂😂"

#define key_errorName			@"errorName"
#define key_errorReason			@"errorReason"
#define key_errorPlace			@"errorPlace"
#define key_errorSituation      @"errorSituation"
#define key_callStackSymbols	@"callStackSymbols"
#define key_exception			@"exception"

#define AvoidCrashNotification @"AvoidCrashNotification"

#import "SNVoidCrashManager.h"

@implementation SNVoidCrashManager

+ (void)errorWithException:(NSException *)exception errorSituation:(NSString *)errorSituation {
	
	// 获取堆栈数据
	NSArray *callStackSymbols = [NSThread callStackSymbols];
	
	NSString *mainCallStackSymbolMsg = [SNVoidCrashManager getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbols];
	
	if (!mainCallStackSymbolMsg) {
		mainCallStackSymbolMsg = @"----崩溃方法定位失败----";
	}
	
	NSString *errorName = exception.name;
	NSString *errorReason = exception.reason;

	errorReason = [errorReason stringByReplacingOccurrencesOfString:@"SNAvoidCrash" withString:@""];
	
	NSString *errorPlace = [NSString stringWithFormat:@"Error Place:%@",mainCallStackSymbolMsg];
	
	NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n%@\n\n%@\n\n",AvoidCrashSeparatorWithFlag, errorName, errorReason, errorPlace, errorSituation, AvoidCrashSeparator];
	NSLog(@"%@",logErrorMessage);
	
	
	NSDictionary *errorInfoDic = @{
								   key_errorName        : errorName,
								   key_errorReason      : errorReason,
								   key_errorPlace       : errorPlace,
								   key_errorSituation   : errorSituation,
								   key_exception        : exception,
								   key_callStackSymbols : callStackSymbols
								   };
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:AvoidCrashNotification object:nil userInfo:errorInfoDic];
	});
}

+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
	
	__block NSString *mainCallStackSymbolMsg = nil;
	
	NSString *regularExpStr = @"[-\\+]\\[.+\\]";
	
	NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
	
	for (int index = 2; index < callStackSymbols.count; index++) {
		NSString *callStackSymbol = callStackSymbols[index];
		
		[regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
			if (result) {
				NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
				
				//get className
				NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
				className = [className componentsSeparatedByString:@"["].lastObject;
				
				NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
				
				//filter category and system class
				if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
					mainCallStackSymbolMsg = tempCallStackSymbolMsg;
					
				}
				*stop = YES;
			}
		}];
		
		if (mainCallStackSymbolMsg.length) {
			break;
		}
	}
	return mainCallStackSymbolMsg;
}

@end
