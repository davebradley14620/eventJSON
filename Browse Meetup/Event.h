//
//  Event.h
//  BrowseBeacon
//

#import <Foundation/Foundation.h>
#import "EventLocation.h"

@interface Event : NSObject
@property (strong, nonatomic) NSString *evid;
@property (strong, nonatomic) NSString *creationTime;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *durationMinutes;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *who;
@property (strong, nonatomic) EventLocation *location;
@end
