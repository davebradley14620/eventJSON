#import "TimeDatePickerViewController.h"

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value


#pragma mark -

@interface TimeDatePickerViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (assign) NSInteger datePickerCellRowHeight;



// this button appears only when the date picker is shown (iOS 6.1.x or earlier)
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

@end

#pragma mark -

@implementation TimeDatePickerViewController
//@synthesize timePickerHours, timePickerMinutes;

#pragma mark - Accessors
/*
 - (IBAction)donePressed: (id)sender {
 NSLog(@"Done button pressed.");
 [self dismissViewControllerAnimated:YES completion:nil];
 }
 */

/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
		
	self.dateFormatter = [[NSDateFormatter alloc] init];
	//	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
	//	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[self.dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
		
	// if the local changes while in the background, we need to be notified so we can update the date
	// format in the table view cells
	//
	[[NSNotificationCenter defaultCenter] addObserver:self
						 selector:@selector(localeChanged:)
						     name:NSCurrentLocaleDidChangeNotification
						   object:nil];	
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
							name:NSCurrentLocaleDidChangeNotification
						      object:nil];
}


#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
	// the user changed the locale (region format) in Settings, so we are notified here to
	// update the date format in the table view cells
	//
//	[self reloadData];
}




/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
	// update our data model
//	[itemData setValue:self.startPickerView.date forKey:kDateKey];
	
	// update the cell's date string
//	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedTimeDatePicker.date];
}


/*! User pressed the "Done" button,
 
 @param sender The sender for this action: The "Done" UIBarButtonItem
 */
- (IBAction)doneAction:(id)sender
{
//	NSLog(@"TimeDatePickerViewController.doneAction");
	if ( self.delegate != nil ) {
		[self.delegate setEventStartDateAndTime:self.startPickerView.date];
		[self.delegate setEventEndDateAndTime:self.endPickerView.date];
	}
		
	
	// remove the "Done" button in the navigation bar
	self.navigationItem.rightBarButtonItem = nil;

	// make this modal go away
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end