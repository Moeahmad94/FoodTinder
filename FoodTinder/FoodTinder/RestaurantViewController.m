//
//  RestaurantViewController.m
//  FoodTinder
//
//  Created by Pinak Shikhare on 1/17/15.
//  Copyright (c) 2015 Pinak Shikhare. All rights reserved.
//

#import "RestaurantViewController.h"


@interface RestaurantViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextView *textDescription;
@property (weak, nonatomic) IBOutlet UITextField *textLink;
@property (weak, nonatomic) IBOutlet MKMapView *presentMap;

@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textName.text = self.name;
    self.textDescription.text = self.summary;
    self.textLink.text = self.website;
    
    MKPointAnnotation *mapPoint =[[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = [self.point latitude];
    pinCoordinate.longitude = [self.point longitude];
    mapPoint.coordinate = pinCoordinate;
    
    mapPoint.title = self.name;
    mapPoint.subtitle = self.describe;
    
    [self.presentMap addAnnotation:mapPoint];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
