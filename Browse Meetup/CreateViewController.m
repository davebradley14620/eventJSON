//
//  SearchViewController.m
//  Read JSON
//
#import "CreateViewController.h"
#import "TimeDatePickerViewController.h"
#import "MasterViewController.h"
#import "Geocoder.h"
#import "Communicator.h"
#import "AppDelegate.h"

@interface CreateViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation CreateViewController
@synthesize eventStatePickerViewArray;
NSDate * startDateAndTime;
NSDate * endDateAndTime;
UIActivityIndicatorView *myActivityView;

- (void)viewDidLoad
{
	self.dateFormatter = [[NSDateFormatter alloc] init];
	//	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
	//	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[self.dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];

	[super viewDidLoad];
	self.eventNameField.delegate = self;
	self.eventDescriptionField.delegate = self;
	self.eventAddressField.delegate = self;
	self.eventCityField.delegate = self;
	self.eventZipcodeField.delegate = self;
	
	//
	// Load the state picker.
	//
	NSArray *arrayToLoadPicker = [[NSArray alloc] initWithObjects:@"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"DC", @"FL", @"GA", @"HI", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO", @"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY", nil];
	self.eventStatePickerViewArray = arrayToLoadPicker;
	self.eventStatePickerView.transform = CGAffineTransformMakeScale(.75, .75);
 	self.eventStatePickerView.delegate = self;
	
	//
	// Create an activity indicator.
	//
	myActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
	CGRect activityFrame = CGRectMake(130, 100, 50, 50);
	[myActivityView setFrame:activityFrame];
	[self.view addSubview:myActivityView];
}

- (void)viewDidUnload
{
}

- (IBAction)eventNameAction:(id)sender {
/*
	[self.eventNameField becomeFirstResponder];
*/
	[self.eventNameField resignFirstResponder];
}

- (IBAction)eventDescriptionAction:(id)sender {
/*
	[self.eventDescriptionField becomeFirstResponder];
*/
 	[self.eventDescriptionField resignFirstResponder];
}

- (IBAction)eventAddressAction:(id)sender {
/*
	[self.eventAddressField becomeFirstResponder];
*/
	[self.eventAddressField resignFirstResponder];
}

- (IBAction)eventCityAction:(id)sender {
/*
	[self.eventCityField becomeFirstResponder];
*/
	[self.eventCityField resignFirstResponder];
}

- (IBAction)eventZipcodeAction:(id)sender {
/*
	[self.eventZipcodeField becomeFirstResponder];
*/
	[self.eventZipcodeField resignFirstResponder];
}

- (IBAction)eventStateAction:(id)sender {
}

- (IBAction)createButtonPressed:(id)sender {
//	NSLog(@"createButtonPressed");

	[self checkAndSubmitForm];
	
	//
	// Get a reference to the parent view controller, which is the tab
	// view controller.   Then switch to the tab containing the
	// MasterViewController.   i.e. the Search Results screen.
	//
	UITabBarController * tabbar = (UITabBarController *)self.parentViewController;
	[tabbar setSelectedIndex:0];	// Switch back to search results tab.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSLog(@"textFieldShouldReturn: %@", textField);
	//
	// Dismiss the keyboard.
	//
	[textField resignFirstResponder];
	return YES;
}

-(void) doAlert: (NSString *)msg {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Incomplete Form" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

-(BOOL) checkAndSubmitForm {
	if ( (self.eventNameField.text == nil) || (self.eventNameField.text.length == 0) ) {
		[self doAlert:@"You missed \"Event Name\"."];
		return NO;
	} else	if ( (self.eventDescriptionField.text == nil) || (self.eventDescriptionField.text.length == 0) ) {
		[self doAlert:@"You missed \"Event Description\"."];
		return NO;
	} else if ( (self.eventAddressField.text == nil) || (self.eventAddressField.text.length == 0) ) {
		[self doAlert:@"You missed \"Address\"."];
		return NO;
	} else 	if ( (self.eventCityField.text == nil) || (self.eventCityField.text.length == 0) ) {
		[self doAlert:@"You missed \"City\"."];
		return NO;
	} else 	if ( (self.eventZipcodeField.text == nil) || (self.eventZipcodeField.text.length == 0) ) {
		[self doAlert:@"You missed \"Zip Code\"."];
		return NO;
	}

	//
	// Get the selected state from the UIPickerView
	//
	NSInteger row = [self.eventStatePickerView selectedRowInComponent:0];
	NSString *selectedState = [self.eventStatePickerViewArray objectAtIndex:row];
	
	//
	// We're about to do a geocode.  This may take a long time.  Put up a spinny wheel to tell the user
	// that we're doing something.
	//
	[myActivityView startAnimating];
	[myActivityView setHidden:NO];
	
	//
	// Get our location from the form.
	//
	CLLocation * location = [Geocoder geocodeAddressSync:self.eventAddressField.text city:self.eventCityField.text state:selectedState zipcode:self.eventZipcodeField.text];
	
	[myActivityView stopAnimating];

	if ( (location.coordinate.latitude == 0.) && (location.coordinate.longitude == 0.) ) {
		[self doAlert:@"Could not determine the coordinates of the specified event location.  Please double check your city, state, address, and zip code for errors."];
		return NO;
	}
	NSLog(@"CreateViewController.checkAndSubmitForm: lat=%f, lon=%f", location.coordinate.latitude, location.coordinate.longitude);

	//
	// Call into backend API to create this event.
	//
	
	//
	// Get a handle to the Manager, from the MasterViewController.   Call the createOrUpdateEvent
	// method in the Manager to do the actual event creation.
	//
	id appDelegate = [[UIApplication sharedApplication] delegate];
	MasterViewController *mvc = [appDelegate masterViewController ];
	Manager *mgr = [mvc getManager];
//	NSLog(@"CreateViewController.checkAndSubmitForm: calling createOrUpdateEvent: mvc=%@, mgr=%@", mvc, mgr);
	[mgr createOrUpdateEvent:location eventid:0 userid:0 name:self.eventNameField.text categoryID:@"" start:startDateAndTime end:endDateAndTime desc:self.eventDescriptionField.text address:self.eventAddressField.text city:self.eventCityField.text state:selectedState zip:self.eventZipcodeField.text];
	
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Event Creation" message:@"Event created" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];

	return YES;
}


//
// UIPickerView implementation
//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [eventStatePickerViewArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.eventStatePickerViewArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return (25.0);
}

-(IBAction)eventStateSelectedRow {
	int selectedIndex = [self.eventStatePickerView selectedRowInComponent:0];
	NSString *message = [NSString stringWithFormat:@"You selected: %@",[eventStatePickerViewArray objectAtIndex:selectedIndex]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil];
	
	
	[alert show];
}

//
// Callback to set event start time.
//
- (void)setEventStartDateAndTime:(NSDate *)startDate
{
	self.startDateField.text = [self.dateFormatter stringFromDate:startDate];
//	NSLog(@"CreateViewController.setEventStartDateAndTime: %@", self.startDateField.text);
	startDateAndTime = startDate;
}

- (void)setEventEndDateAndTime:(NSDate *)endDate
{
	self.endDateField.text = [self.dateFormatter stringFromDate:endDate];
//	NSLog(@"CreateViewController.setEventStartDateAndTime: %@", self.endDateField.text);
	endDateAndTime = endDate;
}

/**
 * Prepare to pass time and date values from the TimeAndDatePickerViewController back to us.
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([segue.identifier isEqualToString:@"setDatesSeque"]){
//		NSLog(@"CreateViewController.prepareForSegue");

		TimeDatePickerViewController *vc = (TimeDatePickerViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
		
		[vc setDelegate:self];
	}
}

@end
