//
//  Manager.m
//  BrowseBeacon
//

#import "Manager.h"
#import "EventBuilder.h"
#import "Communicator.h"
#import "Config.h"

@implementation Manager
@synthesize communicator;

- (void)searchEvents:(CLLocation *)location
{
	NSLog(@"Manager.searchEvents");
	NSMutableDictionary * cfg = [Config getConfig];
	CLLocation * loc = [cfg objectForKey:@"search_location"];
	//
	// If there is no search_location defined, then we default to the location passed in, which is the
	// device's current location.
	//
	if ( loc == nil ) {
		loc = location;
	}
	NSString * keyword = [cfg objectForKey:@"search_keyword"];
	NSString * startDateStr = [cfg objectForKey:@"search_startdate"];
	NSString * endDateStr = [cfg objectForKey:@"search_enddate"];
	NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"mm/dd/yyyy"];
	NSDate * startDate = nil;
	if ( (startDateStr != nil)  && ([startDateStr length] > 0) ) {
		startDate = [formatter dateFromString:startDateStr];
	}
	NSDate * endDate = nil;
	if ( (endDateStr != nil)  && ([endDateStr length] > 0) ) {
		endDate = [formatter dateFromString:endDateStr];
	}
	//
	// Now forget our search parameters, if any.
	//
	[cfg removeObjectForKey:@"search_location"];
	[cfg removeObjectForKey:@"search_keyword"];
	[cfg removeObjectForKey:@"search_startdate"];
	[cfg removeObjectForKey:@"search_enddate"];
	
/*
NSLog(@"searchEvents: startDate=%@", [formatter stringFromDate:startDate]);
NSLog(@"searchEvents: endDate=%@", [formatter stringFromDate:endDate]);
*/
	NSLog(@"Manager.searchEvents: keyword=%@, startDate=%@, endDate=%@", keyword, startDateStr, endDateStr);
	[self.communicator searchEvents:loc.coordinate
		radius: DEFAULT_SEARCH_RADIUS
		what: keyword
		searchExpired: true
		categoryID: @""
		after: startDate
		before: endDate
	];
}

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
			zip: (NSString *)zip
{
	[self.communicator createOrUpdateEvent:location.coordinate eventid:eventid userid:userid name:name categoryID:catid start:startDate end:endDate desc:desc address:address city:city state:state zip:zip];
}

#pragma mark - CommunicatorDelegate

- (void)receivedEventsJSON:(NSData *)objectNotation
{
	NSLog(@"Manager.receivedEventsJSON");
	NSError *error = nil;
	NSArray *events = [EventBuilder eventsFromJSON:objectNotation error:&error];
    
	if (error != nil) {
		[self.delegate fetchingEventsFailedWithError:error];
	} else {
		[self.delegate didReceiveEvents:events];
	}
}

- (void)fetchingEventsFailedWithError:(NSError *)error
{
    [self.delegate fetchingEventsFailedWithError:error];
}

@end
