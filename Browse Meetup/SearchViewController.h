//
//  SearchViewController.h
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UISearchBar.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISwitch *useCurrentLocationSwitch;

- (IBAction)useCurrentLocationSwitched:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *KeywordSearchField;

@property (strong, nonatomic) IBOutlet UITextField *AddressSearchField;
- (IBAction)addressSearchFieldAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *CitySearchField;
- (IBAction)citySearchFieldAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *StateSearchField;
- (IBAction)stateSearchFieldAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *ZipcodeSearchField;
- (IBAction)zipcodeSearchFieldAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *AfterDateSearchField;

@property (strong, nonatomic) IBOutlet UILabel *BeforeDateSearchField;
- (IBAction)searchButtonPressed:(id)sender;

@property (nonatomic, assign) NSString * afterDate;
@property (nonatomic, assign) NSString * beforeDate;

@end
