//
//  EventBuilder.h
//  BrowseBeacon
//

#import <Foundation/Foundation.h>

@interface EventBuilder : NSObject

+ (NSArray *)eventsFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end