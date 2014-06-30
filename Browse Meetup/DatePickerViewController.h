//
//  DatePickerViewController.h
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchViewController.h"

@interface DatePickerViewController : UITableViewController

@property (nonatomic, assign) SearchViewController* delegate;

@end
