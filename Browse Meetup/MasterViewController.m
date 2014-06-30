//
//  MasterViewController.m
//  Read JSON
//
#import "MasterViewController.h"

#import "DetailCell.h"

#import "Event.h"
#import "Manager.h"
#import "Communicator.h"
#import "AppDelegate.h"

@interface MasterViewController () <ManagerDelegate> {
    NSArray *_events;
    Manager *_manager;
}
@property (weak, nonatomic) CLLocationManager *locationManager;
@end

@implementation MasterViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//
	// Register ourself with the AppDelegate.
	//
	id appDelegate = [[UIApplication sharedApplication] delegate];
	if ([appDelegate respondsToSelector:@selector(masterViewController)]) {
//		NSLog(@"MasterViewController.init: setting AppDelegate.masterViewController");
		((AppDelegate *)appDelegate).masterViewController = self;
	} else {
		NSLog(@"MasterViewController.init: AppDelegate does not respond to selector masterViewController");
	}

    
	_manager = [[Manager alloc] init];
	_manager.communicator = [[Communicator alloc] init];
	_manager.communicator.delegate = _manager;
	_manager.delegate = self;
    
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(startFetchingEvents:)
		name:@"kCLAuthorizationStatusAuthorized"
		object:nil];
}

- (void) viewWillAppear:(BOOL)animated	{
//	NSLog(@"MasterViewController.viewWillAppear: animated=%@", (animated ? @"true" : @"false"));
	[_manager searchEvents:self.locationManager.location];
}
- (void) viewDidAppear:(BOOL)animated	{
//	NSLog(@"MasterViewController.viewDidAppear: animated=%@", (animated ? @"true" : @"false"));
}

#pragma mark - Accessors

- (CLLocationManager *)locationManager
{
    if (_locationManager) {
        return _locationManager;
    }
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(locationManager)]) {
        _locationManager = [appDelegate performSelector:@selector(locationManager)];
    }
    return _locationManager;
}

#pragma mark - Notification Observer
- (void)startFetchingEvents:(NSNotification *)notification
{
	[_manager searchEvents:self.locationManager.location];
}

#pragma mark - ManagerDelegate
- (void)didReceiveEvents:(NSArray *)events
{
    _events = events;
    dispatch_async(dispatch_get_main_queue(), ^{
    	[self.tableView reloadData];
    });
}

- (void)fetchingEventsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;	// Only one section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	NSLog(@"tableView: _events.count=%d", _events.count);
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Event *event = _events[indexPath.row];
    [cell.nameLabel setText:event.name];
    [cell.whoLabel setText:event.who];
    [cell.locationLabel setText:[NSString stringWithFormat:@"%@ %@, %@ %@", event.location.address, event.location.city, event.location.state, event.location.zip]];
    [cell.descriptionLabel setText:event.description];
//NSLog(@"tableView: name=%@, who=%@, location=%@, description=%@", cell.nameLabel, cell.whoLabel, cell.locationLabel, cell.descriptionLabel);
   
    return cell;
}

- (Manager *)getManager {
	return( _manager);
}
@end
