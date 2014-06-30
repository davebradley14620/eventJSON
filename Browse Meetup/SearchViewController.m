//
//  SearchViewController.m
//  Read JSON
//
#import "SearchViewController.h"
#import "DatePickerViewController.h"
#import "AppDelegate.h"
#import "Config.h"
#import "Geocoder.h"


@interface SearchViewController () {
}
@end

@implementation SearchViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	//
	// Set editability of text fields
	// based on 'search by current location'
	// switch.
	//
	[self textFieldsToggle];
	self.KeywordSearchField.delegate = self;

}
- (void)viewDidUnload
{
	[self setKeywordSearchField:nil];
	[self setAddressSearchField:nil];
	[self setCitySearchField:nil];
	[self setStateSearchField:nil];
	[self setZipcodeSearchField:nil];
}
- (void)textFieldsToggle
{
	self.AddressSearchField.enabled = (! self.useCurrentLocationSwitch.on);
	if ( self.AddressSearchField.enabled == NO ) {
		self.AddressSearchField.textColor = [UIColor lightGrayColor];
	} else {
		self.AddressSearchField.textColor = [UIColor blackColor];
	}
	self.CitySearchField.enabled = (! self.useCurrentLocationSwitch.on);
	if ( self.CitySearchField.enabled == NO ) {
		self.CitySearchField.textColor = [UIColor lightGrayColor];
	} else {
		self.CitySearchField.textColor = [UIColor blackColor];
	}
	self.StateSearchField.enabled = (! self.useCurrentLocationSwitch.on);
	if ( self.StateSearchField.enabled == NO ) {
		self.StateSearchField.textColor = [UIColor lightGrayColor];
	} else {
		self.StateSearchField.textColor = [UIColor blackColor];
	}
	self.ZipcodeSearchField.enabled = (! self.useCurrentLocationSwitch.on);
	if ( self.ZipcodeSearchField.enabled == NO ) {
		self.ZipcodeSearchField.textColor = [UIColor lightGrayColor];
	} else {
		self.ZipcodeSearchField.textColor = [UIColor blackColor];
	}
}
#pragma mark - Accessors


- (IBAction)useCurrentLocationSwitched:(id)sender {
	//
	// Make the text fields editable, if the
	// switch is off, or uneditable, if on.
	//
	[self textFieldsToggle];
}

- (IBAction)addressSearchFieldAction:(id)sender {
	[self.AddressSearchField becomeFirstResponder];
	[self.AddressSearchField resignFirstResponder];
}
- (IBAction)citySearchFieldAction:(id)sender {
	[self.CitySearchField becomeFirstResponder];
	[self.CitySearchField resignFirstResponder];
}
- (IBAction)stateSearchFieldAction:(id)sender {
	[self.StateSearchField becomeFirstResponder];
	[self.StateSearchField resignFirstResponder];
}
- (IBAction)zipcodeSearchFieldAction:(id)sender {
	[self.ZipcodeSearchField becomeFirstResponder];
	[self.ZipcodeSearchField resignFirstResponder];
}


- (void) executeSearch {
	//
	// Dismiss the keyboard.
	//
	[self.KeywordSearchField becomeFirstResponder];
	[self.KeywordSearchField resignFirstResponder];
	
	CLLocation * location;
	if ( self.useCurrentLocationSwitch.on ) {
		AppDelegate *appdel = [UIApplication sharedApplication].delegate;
		location = appdel.currentLocation;
		//location = [NSString stringWithFormat:@"%f,%f", coord.latitude,coord.longitude];
	} else {
		//
		// Get our location from the form.
		//
		//location = [self geocodeForm];
		location = [Geocoder geocodeAddressSync:self.AddressSearchField.text city:self.CitySearchField.text state:self.StateSearchField.text zipcode:self.ZipcodeSearchField.text];
	}
	//
	// Store the search info in the Config object.   The search screen will peel this off then
	// run the search based on it.
	//
	NSMutableDictionary * cfg = [Config getConfig];
	[cfg setObject:location forKey:@"search_location"];
	[cfg setObject:self.KeywordSearchField.text forKey:@"search_keyword"];
	[cfg setObject:self.AfterDateSearchField.text forKey:@"search_startdate"];
	[cfg setObject:self.BeforeDateSearchField.text forKey:@"search_enddate"];
	[Config setConfig];

	//
	// Get a reference to the parent view controller, which is the tab
	// view controller.   Then switch to the tab containing the
	// MasterViewController.   i.e. the Search Results screen.
	//
	UITabBarController * tabbar = (UITabBarController *)self.parentViewController;
	[tabbar setSelectedIndex:0];	// Switch back to search results tab.
}

- (void)setAfterDate:(NSString *)afterDate
{
	self.AfterDateSearchField.text = afterDate;
}

- (void)setBeforeDate:(NSString *)beforeDate
{
	self.BeforeDateSearchField.text = beforeDate;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([segue.identifier isEqualToString:@"enterDatesSeque"]){
		DatePickerViewController *vc = (DatePickerViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
		
		[vc setDelegate:self];
	}
}

- (IBAction)searchButtonPressed:(id)sender {
	NSLog(@"searchButtonPressed");
	[self executeSearch];
}

//
// UISearchBar.h implementation.
//

//
// called when keyboard search button pressed.
//
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	NSLog(@"searchBarSearchButtonClicked");
	[self executeSearch];
}

@end
