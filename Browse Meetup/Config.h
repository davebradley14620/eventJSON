#import <Foundation/Foundation.h>

@interface Config : NSObject
+ (void)initialize;
+ (NSMutableDictionary *)getConfig;
+ (void) setConfig;
@end