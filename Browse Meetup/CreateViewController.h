//
//  CreateViewController.h
//
#import <UIKit/UIKit.h>

@interface CreateViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *eventNameField;
- (IBAction)eventNameAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *eventDescriptionField;
- (IBAction)eventDescriptionAction:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *eventAddressField;
- (IBAction)eventAddressAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *eventCityField;
- (IBAction)eventCityAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *eventStatePickerView;
@property (nonatomic, retain) NSArray *eventStatePickerViewArray;
-(IBAction)eventStateSelectedRow;

@property (strong, nonatomic) IBOutlet UITextField *eventZipcodeField;
- (IBAction)eventZipcodeAction:(id)sender;

@property (nonatomic, assign) NSDate * eventStartDateAndTime;
@property (nonatomic, assign) NSDate * eventEndDateAndTime;

@property (strong, nonatomic) IBOutlet UILabel *startDateField;
@property (strong, nonatomic) IBOutlet UILabel *endDateField;
//@property (nonatomic, assign) NSString * eventTime;

@end