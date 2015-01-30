//
//  TinderViewController.m
//  FoodTinder
//
//  Created by Pinak Shikhare on 1/17/15.
//  Copyright (c) 2015 Pinak Shikhare. All rights reserved.
//

#import "TinderViewController.h"
#import "Food.h"
#import "Restaurant.h"
#import <Parse/Parse.h>

@interface TinderViewController (){
    NSMutableArray* Id;
    NSDictionary *IdToPhoto;
    NSDictionary *IdToDescription;
    NSDictionary* imageFilesArray;

}

@property (weak, nonatomic) IBOutlet UIImageView *imageToSet;

@property (weak, nonatomic) IBOutlet UITextView *textField;

@property (nonatomic) NSUInteger index;

@property (nonatomic, strong) PFObject *userObj;



@end

@implementation TinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Id = [[NSMutableArray alloc]init];
    IdToPhoto = [[NSMutableDictionary alloc] init];
    IdToDescription = [[NSMutableDictionary alloc] init];
    imageFilesArray = [[NSMutableDictionary alloc] init];
    
    
    PFUser *user = [PFUser currentUser];
    
    self.userObj = [PFQuery getUserObjectWithId:user.objectId];
    
    NSLog(@"user: %@", user.objectId);
    
    PFQuery* query = [PFQuery queryWithClassName:@"FoodPhoto"];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            NSLog(@"Here!!!!!!!!");
            NSString *describe = object[@"Description"];
            NSString *identify = object.objectId;
            NSLog(@"identify: %@", describe);
            PFFile *imageFile = [object objectForKey:@"Image"];
            [imageFilesArray setValue:imageFile forKey:identify];
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:result];
                    [IdToPhoto setValue:image forKey:identify];
                    [IdToDescription setValue:describe forKey:identify];
                    [Id addObject:identify];

                }
            }];
            
        }
        [self shuffle];
        
        self.index = 0;
        
        NSString *identify = [Id firstObject];
        
        PFFile* file = [imageFilesArray valueForKey:identify];
        [file getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:result];
                self.imageToSet.image = image;


            }
        }];
        
    
        
        self.textField.text = [IdToDescription valueForKey:identify];
    }];
    
    
}

- (void)shuffle{
    srandom(time(NULL));
    for (NSInteger x = 0; x < [Id count]; x++) {
        NSInteger randInt = (random() % ([Id count] - x)) + x;
        [Id exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)like:(id)sender {
    
    // Update liked database
    
    
    // Set
    self.index++;
    
    NSString* identify = [Id objectAtIndex:self.index];
    
    PFFile* file = [imageFilesArray valueForKey:identify];
    [file getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:result];
            [UIView transitionWithView:self.imageToSet
                              duration:0.35f
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                self.imageToSet.image = image;
                            } completion:nil];

        }
    }];
    
    // Update saved photos in local databas
    [self.userObj addObject:identify forKey:@"SavedPhotos"];
    [self.userObj saveEventually];
    
    //Set this
    self.textField.text = [IdToDescription valueForKey:identify];
    
}


- (IBAction)dislike:(id)sender {
    
    // Set
    self.index++;
    
    NSString* identify = [Id objectAtIndex:self.index];
    
    PFFile* file = [imageFilesArray valueForKey:identify];
    [file getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:result];
            [UIView transitionWithView:self.imageToSet
                              duration:0.35f
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                self.imageToSet.image = image;
                            } completion:nil];
            
        }
    }];
    
    //Set this
    self.textField.text = [IdToDescription valueForKey:identify];
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
