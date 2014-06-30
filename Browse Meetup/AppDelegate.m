//
//  AppDelegate.m
//  Read JSON
//
//  Created by TAMIM Ziad on 8/16/13.
//  Copyright (c) 2013 TAMIM Ziad. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<CLLocationManagerDelegate>
@end

@implementation AppDelegate
@synthesize masterViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.locationManager = [[CLLocationManager alloc] init];
    if (! [CLLocationManager locationServicesEnabled]) {
	    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"== Oops! ==" message:@"'Location Services' need to be on." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	    [alert show];
	    
    } else {
        [self.locationManager setDelegate:self];
        [self.locationManager startUpdatingLocation];
    }
    return YES;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorized) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCLAuthorizationStatusAuthorized" object:self];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//	NSLog(@"locationManager.didUpdateToLocation");
	self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"locationManager.didFailwithError: error=%@", error);

	// The location "unknown" error simply means the manager is currently unable to get the location.
	// We can ignore this error for the scenario of getting a single location fix, because we already have a
	// timeout that will stop the location manager to save power.
//	if ([error code] != kCLErrorLocationUnknown) {
//		[self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
//	}
}
@end
