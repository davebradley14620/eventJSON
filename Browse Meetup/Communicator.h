//
//  Communicator.h
//  BrowseBeacon
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
//
// Default search radius to use if user specifies no radius.
//
#define DEFAULT_SEARCH_RADIUS	30

@protocol CommunicatorDelegate;

@interface Communicator : NSObject
@property (weak, nonatomic) id<CommunicatorDelegate> delegate;

- (void)searchEvents: (CLLocationCoordinate2D)coordinate
	radius: (int) radius
	what: (NSString *) keyword
	searchExpired: (BOOL) expired
	categoryID: (NSString *)catid
	after: (NSDate *) startDate
	before: (NSDate *) endDate;

- (void)createOrUpdateEvent: (CLLocationCoordinate2D)coordinate
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