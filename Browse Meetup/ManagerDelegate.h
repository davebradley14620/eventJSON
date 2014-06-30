//
//  ManagerDelegate.h
//  BrowseBeacon
//

#import <Foundation/Foundation.h>

@protocol ManagerDelegate
- (void)didReceiveEvents:(NSArray *)events;
- (void)fetchingEventsFailedWithError:(NSError *)error;
@end
