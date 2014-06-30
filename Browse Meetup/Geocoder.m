#import "Geocoder.h"
#import "JSONKit.h"

@implementation Geocoder

/**
 * Determine the latitude and longitude of the address, city, state, zip in
 * the form.
 * return: either "", if not geocodable, or "<lat>,<lon>", where <lat> is the
 * latitude and <lon> is the longitude, specified as floating point doubles with 4
 * digits of precision past the decimal point.
 */

+(CLLocationCoordinate2D) geocodeAddressAsync: (NSString *)address city:(NSString *)city state:(NSString *)state zipcode:(NSString *)zipcode {
	NSLog(@"Geocoder.geocodeAddressAsync: enter");
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	NSString * location = @"";
	if ( (address != nil) && (address.length > 0) ) {
		location = [location stringByAppendingString:address];
	}
	if ( (city != nil) && (city.length > 0) ) {
		location = [NSString stringWithFormat:@"%@,%@", location, city];
	}
	if ( (state != nil) && (state.length > 0) ) {
		location = [NSString stringWithFormat:@"%@,%@", location, state];
	}
	if ( (zipcode != nil) && (zipcode.length > 0) ) {
		location = [NSString stringWithFormat:@"%@,%@", location, zipcode];
	}
	NSLog(@"Geocder.geocodeAddressAsync: geocoding: %@", location);
	__block CLLocationCoordinate2D ret;
	[geocoder geocodeAddressString:location completionHandler:^(NSArray * placemarks, NSError *error) {
		NSLog(@"Geocoder.geocodeAddressAsync: found %d placemarks", [placemarks count]);
		if ([placemarks count] == 0) {
			NSLog(@"Geocoder.geocodeAddressAsync: unable to geocode: %@: error=%@",location, [error localizedDescription]);
		}
		for (CLPlacemark * aPlacemark in placemarks) {
			//
			// Process the placemark.
			//
			//NSString * latDest = [NSString stringWithFormat:@"%.4f", aPlacemark.location.coordinate.latitude];
			//NSString * lngDest = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
			//ret = [NSString stringWithFormat:@"%@,%@",latDest,lngDest];
			ret.latitude = aPlacemark.location.coordinate.latitude;
			ret.longitude = aPlacemark.location.coordinate.longitude;
		}
	}];
	NSLog(@"Geocoder.geocodeAddressAsync: returning latitude=%f, longitude=%f", ret.latitude, ret.longitude);
	return( ret );
}

+(CLLocation *)geocodeAddressSync: (NSString *)address city:(NSString *)city state:(NSString *)state zipcode:(NSString *)zipcode {
	NSString * loc = @"";
	if ( (address != nil) && (address.length > 0) ) {
		loc = [loc stringByAppendingString:address];
	}
	if ( (city != nil) && (city.length > 0) ) {
		loc = [NSString stringWithFormat:@"%@ %@", loc, city];
	}
	if ( (state != nil) && (state.length > 0) ) {
		loc = [NSString stringWithFormat:@"%@ %@", loc, state];
	}
	if ( (zipcode != nil) && (zipcode.length > 0) ) {
		loc = [NSString stringWithFormat:@"%@ %@", loc, zipcode];
	}
	NSLog(@"Geocder.geocodeAddressSync: geocoding: %@", loc);

	
	__block CLLocation *location = nil;
	__block CLLocation *ret = nil;
	NSString *gUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", loc];
	
	gUrl = [gUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString *infoData = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:gUrl] encoding:NSUTF8StringEncoding error:nil];
	
	if ((infoData == nil) || ([infoData isEqualToString:@"[]"])) {
		
		return nil;
		
	} else {
		
		NSDictionary *jsonObject = [infoData objectFromJSONString];
		
		if (jsonObject == nil) {
			return nil;
		}
		
		NSArray *result = [jsonObject objectForKey:@"results"];
		
		[result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			
			NSDictionary *value = [[obj objectForKey:@"geometry"] valueForKey:@"location"];
			
			location = [[CLLocation alloc] initWithLatitude:[[value valueForKey:@"lat"] doubleValue]
							      longitude:[[value valueForKey:@"lng"] doubleValue]];
			ret = location;
			*stop = YES;
		}];
	}
	
	return ret;
}

@end