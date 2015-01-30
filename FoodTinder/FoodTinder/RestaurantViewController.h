//
//  RestaurantViewController.h
//  FoodTinder
//
//  Created by Pinak Shikhare on 1/17/15.
//  Copyright (c) 2015 Pinak Shikhare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface RestaurantViewController : UIViewController

@property(nonatomic, strong) PFGeoPoint *point;
@property(nonatomic, strong) NSString *describe;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *website;
@property(nonatomic, strong) NSString *summary;


@end
