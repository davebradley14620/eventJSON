//
//  AppDelegate.h
//  Read JSON
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MasterViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation  *currentLocation;

@property (strong, nonatomic) MasterViewController *masterViewController;

@end
