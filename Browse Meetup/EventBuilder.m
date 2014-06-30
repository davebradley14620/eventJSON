//
//  EventBuilder.m
//  BrowseBeacon
//

#import "EventBuilder.h"
#import "Event.h"

@implementation EventBuilder
+ (NSArray *)eventsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
 //   NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
//    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:NSJSONReadingMutableContainers error:&localError];
    NSArray *results = [NSJSONSerialization JSONObjectWithData:objectNotation options:NSJSONReadingMutableContainers error:&localError];
	
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *events = [[NSMutableArray alloc] init];
    
//    NSArray *results = [parsedObject valueForKey:@"results"];
//    NSLog(@"Count %d", results.count);
    
    for (NSDictionary *eventDic in results) {
        Event *event = [[Event alloc] init];
        
        for (NSString *key in eventDic) {
		if ( [key isEqualToString:@"location"]) {
			EventLocation * loc = makeLocation( [eventDic valueForKey:key] );
			[event setValue:loc forKey:key];
		}
            	else if ([event respondsToSelector:NSSelectorFromString(key)]) {
                	[event setValue:[eventDic valueForKey:key] forKey:key];
            	}
        }
        
        [events addObject:event];
    }
    
    return events;
}

static EventLocation * makeLocation( NSDictionary * dic)
{
	EventLocation * loc = [[EventLocation alloc] init];
        for (NSString *key in dic) {
		if ([loc respondsToSelector:NSSelectorFromString(key)]) {
                	[loc setValue:[dic valueForKey:key] forKey:key];
            	}
        }
	return( loc );
}
@end
