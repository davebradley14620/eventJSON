#import "Config.h"

static NSMutableDictionary *myConfig = nil;
static NSString * pfilePath = nil;

@implementation Config
+ (void)initialize{
	if ( myConfig == nil ) {
		pfilePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
		myConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:pfilePath];
	}
}

+ (NSMutableDictionary *)getConfig {
	return myConfig;
}

+ (void)setConfig {
	if ( ( pfilePath != nil ) && ( myConfig != nil ) ) {
		[myConfig writeToFile:pfilePath atomically:YES];
	}
}
@end