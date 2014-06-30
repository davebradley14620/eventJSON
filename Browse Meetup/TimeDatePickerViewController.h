//
//  TimeDatePickerViewController.h
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CreateViewController.h"

@interface TimeDatePickerViewController : UIViewController
@property (nonatomic, assign) CreateViewController* delegate;

@property (nonatomic, strong) IBOutlet UIDatePicker *startPickerView;
@property (nonatomic, strong) IBOutlet UIDatePicker *endPickerView;

/*
@property (nonatomic, strong) IBOutlet UIPickerView *timePickerView;
@property (nonatomic, retain) NSArray *timePickerHours;
@property (nonatomic, retain) NSArray *timePickerMinutes;
-(IBAction)timeSelectedRow;
*/
@end
