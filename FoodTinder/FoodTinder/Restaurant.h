//
//  Restaurant.h
//  FoodTinder
//
//  Created by Pinak Shikhare on 1/17/15.
//  Copyright (c) 2015 Pinak Shikhare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* description;
// Need something to store location

@property(strong, nonatomic) NSString* location;
@property(strong, nonatomic) NSString* profileImage;


@end
