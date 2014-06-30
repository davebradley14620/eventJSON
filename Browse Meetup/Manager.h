//
//  Manager.h
//  BrowseBeacon
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "ManagerDelegate.h"
#import "CommunicatorDelegate.h"

@class Communicator;

@interface Manager : NSObject<CommunicatorDelegate>
@property (strong, nonatomic) Communicator *communicator;
@property (weak, nonatomic) id<ManagerDelegate> delegate;

- (void)searchEvents:(CLLocation *)location;

- (void)createOrUpdateEvent: (CLLocation *)location
		    eventid: (NSInteger) eventid
		     userid: (NSInteger) userid
		       name: (NSString * )name
		 categoryID: (NSString *)catid
		      start: (NSDate *) startDate
			end: (NSDate *)endDate
		       desc: (NSString *)desc
		    address: (NSString *)address
		       city: (NSString *)city
		      state: (NSString *)state
			zip: (NSString *)zip;

@end