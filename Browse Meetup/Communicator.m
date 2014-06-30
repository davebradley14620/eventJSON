//
//  Communicator.m
//  BrowseBeacon
//

#import "Communicator.h"
#import "CommunicatorDelegate.h"
#import "Config.h"

@interface Communicator()
@end

@implementation Communicator
NSDateFormatter * dateFormatter1;
NSDateFormatter * dateFormatter2;
NSDictionary * config;
NSString * server;

- (Communicator *) init {
	if ( self = [super init] ) {
		dateFormatter1 = [[NSDateFormatter alloc]init];
		[dateFormatter1 setDateFormat:@"mm/dd/yyyy"];
		dateFormatter2 = [[NSDateFormatter alloc]init];
		[dateFormatter2 setDateFormat:@"yyyy.MM.dd.hh.mm"];

		config = [Config getConfig];
		server = [config objectForKey:@"eventserver"];
	}
	return( self );
}
-(NSString *)encodeURL:(NSString *)urlString
{
	CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8);
	return (NSString *)CFBridgingRelease(newString);
}

/**
 * Search for events based on location, keyword, category, and time and date range.
 */
- (void)searchEvents: (CLLocationCoordinate2D)coordinate
	radius: (int) radius
	what: (NSString *) keyword
	searchExpired: (BOOL) expired
	categoryID: (NSString *)catid
	after: (NSDate *) startDate
	before: (NSDate *) endDate
{
//NSLog(@"latitude=%f, longitude=%f", coordinate.latitude, coordinate.longitude);

//NSLog(@"startDate=%@", [dateFormatter1 stringFromDate:startDate]);
//NSLog(@"endDate=%@", [dateFormatter1 stringFromDate:endDate]);
	
	NSTimeInterval startSec = 0;
	if ( startDate != nil ) {
		startSec = [startDate timeIntervalSince1970];
	}
	NSTimeInterval endSec = 0;
	if ( endDate != nil ) {
		endSec = [endDate timeIntervalSince1970];
	}
//	NSLog(@"start=%f,end=%f",startSec,endSec);
	
	if ( (catid == nil) || (catid.length == 0) ) {
		catid = @"0";
	}
	if ( (keyword == nil) || (keyword.length == 0) ) {
		keyword = @"%22%22";
	} else {
		keyword = [self encodeURL: keyword];
	}
	//	@Path("/search/{lat}/{lon}/{rad}/{expired}/{catid}/{startdate}/{enddate}/{offset}/{count}/{keyword}")
	NSString *urlAsString = [NSString stringWithFormat:@"http://%@/EventEngine/rest/events/search/%f/%f/%d/%@/%@/%0.0f/%0.0f/0/-1/%@", server, coordinate.latitude, coordinate.longitude, radius, (expired ? @"true" : @"false"), catid, startSec, endSec, keyword];
	
	NSURL *url = [[NSURL alloc] initWithString:urlAsString];
//	NSLog(@"%@", urlAsString);
    
//	NSLog(@"Communicator.searchEvents: keyword=%@, startSec=%f, endSec=%f", keyword, startSec, endSec);

	[NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
		if (error) {
			[self.delegate fetchingEventsFailedWithError:error];
		} else {
			[self.delegate receivedEventsJSON:data];
        	}
    	}];
}

/**
 * Create a new event or update an existing one.
 */
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
	zip: (NSString *)zip
{
	NSLog(@"Communicator.createOrUpdateEvent");

	NSLog(@"latitude=%f, longitude=%f", coordinate.latitude, coordinate.longitude);
	
	NSLog(@"startDate=%@", [dateFormatter2 stringFromDate:startDate]);
	NSLog(@"endDate=%@", [dateFormatter2 stringFromDate:endDate]);
	
	unsigned long startSec = 0;
	if ( startDate != nil ) {
		startSec = [startDate timeIntervalSince1970];
	}
	unsigned long endSec = 0;
	if ( endDate != nil ) {
		endSec = [endDate timeIntervalSince1970];
	}
	if ( (catid == nil) || (catid.length == 0) ) {
		catid = @"0";
	}

//	NSLog(@"start=%lu,end=%lu",startSec,endSec);
	

	//Event result2 = service.path("rest").path("events").path("get").path(eventId1).accept(MediaType.APPLICATION_JSON).put(Event.class, event);
	
	NSString * evid = [NSString stringWithFormat:@"%d", eventid];
	NSString * uid = [NSString stringWithFormat:@"%d", userid];

	NSString * start = [NSString stringWithFormat:@"%lu", startSec];
	NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
	int durationMinutes = (int)(duration / 60.0);
	NSString * dur = [NSString stringWithFormat:@"%d",durationMinutes];
	
	NSString * lat = [NSString stringWithFormat:@"%.5f",coordinate.latitude];
	NSString * lon = [NSString stringWithFormat:@"%.5f",coordinate.longitude];

	
	
	//
	// POST the data.
	//
	
	/* JSON
	 NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
	 evid, @"id",
	 name, @"name",
	 desc, @"description",
	 uid, @"creator",
	 start, @"start",
	 dur, @"duration",
	 @"false", @"isrepeating",
	 @"", @"cycle",
	 address, @"address",
	 city, @"city",
	 state, @"state",
	 zip, @"zip",
	 lat, @"latitude",
	 lon, @"longitude",
	 nil];
	 
	 NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:nil];
	 NSString * dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	 */
	
	/* URL Encoded */
	NSString * dataString = [NSString stringWithFormat:@"id=%@&name=%@&description=%@&creator=%@&catid=%@&start=%@&duration=%@&isrepeating=false&cycle=&address=%@&city=%@&state=%@&zip=%@&lat=%@&lon=%@",evid, name, desc, uid, catid, start, dur, address, city, state, zip, lat, lon];

	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"%@",dataString] dataUsingEncoding:NSUTF8StringEncoding]];
	NSString *urlAsString = [NSString stringWithFormat:@"http://%@/EventEngine/rest/events/update/", server];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlAsString]];
	NSLog(@"Communicator.createOrUpdateEvent:urlAsString=%@",urlAsString);
	NSLog(@"Communicator.createOrUpdateEvent:dataString=%@",dataString);
	[request setHTTPBody:body];
	[request setHTTPMethod:@"POST"];
	/* JSON
	[request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	*/
	/* URL Encoded */
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


	[NSURLConnection sendAsynchronousRequest: request
					   queue: queue
			       completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
				       if (error || !data) {
					       // Handle the error
					       
					       NSLog(@"Server Error : %@", error);
					       [self.delegate fetchingEventsFailedWithError:error];

				       } else {
					       // Handle the success
					       NSString* dataStr = [NSString stringWithUTF8String:[data bytes]];
					       NSLog(@"Server Response :%@, data=%@",response, dataStr);
					      // [self.delegate receivedEventsJSON:data];
				       }
			       }
	 ];
}
@end
