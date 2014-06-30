//
//  CommunicatorDelegate.h
//  BrowseBeacon
//

#import <Foundation/Foundation.h>

@protocol CommunicatorDelegate
- (void)receivedEventsJSON:(NSData *)objectNotation;
- (void)fetchingEventsFailedWithError:(NSError *)error;
@end
