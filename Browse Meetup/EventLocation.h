
//
//  Location.h
//
//  Created by Dave on 03/21/2012
//  Copyright (c) 2014 David Bradley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventLocation : NSObject
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *location;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@end
