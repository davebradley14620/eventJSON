#import <CoreLocation/CoreLocation.h>

@interface Geocoder : NSObject

+(CLLocationCoordinate2D) geocodeAddressAsync: (NSString *)address city:(NSString *)city state:(NSString *)state zipcode:(NSString *)zipcode;
+(CLLocation *) geocodeAddressSync: (NSString *)address city:(NSString *)city state:(NSString *)state zipcode:(NSString *)zipcode;

@end
