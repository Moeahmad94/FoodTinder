//
//  MyFoodTableViewController.m
//  FoodTinder
//
//  Created by Pinak Shikhare on 1/17/15.
//  Copyright (c) 2015 Pinak Shikhare. All rights reserved.
//

#import "MyFoodTableViewController.h"
#import "RestaurantViewController.h"
#import <Parse/Parse.h>

@interface MyFoodTableViewController ()

@property(nonatomic, strong) PFObject* userObject;
@property(nonatomic, strong) NSMutableDictionary* IdToDescription;
@property(nonatomic, strong) NSMutableDictionary* IdToTag;
@property(nonatomic, strong) NSMutableDictionary* IdToImageFile;
@property(nonatomic, strong) NSMutableArray* Id;


@end

@implementation MyFoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"VIEW DID LOAD");

    
    PFUser *user = [PFUser currentUser];
    self.userObject = [PFQuery getUserObjectWithId:user.objectId];
    
    if ([self.userObject[@"SavedPhotos"] count]) {
        self.Id = [[NSMutableArray alloc] initWithArray:self.userObject[@"SavedPhotos"]];
        NSLog(@"Count: %lu", (unsigned long)[self.Id count]);


    }
    self.IdToTag = [[NSMutableDictionary alloc]init];
    self.IdToDescription = [[NSMutableDictionary alloc]init];
    self.IdToImageFile = [[NSMutableDictionary alloc]init];
    
    for (NSString *foodId in self.Id){
        PFQuery *query = [PFQuery queryWithClassName:@"FoodPhoto"];
        [query whereKey:@"objectId" equalTo:foodId];
        
        NSArray* objects = [query findObjects];
        for (PFObject *object in objects) {
            NSString *describe = object[@"Description"];
            NSString *tag = [object objectForKey:@"Tag"];
            [self.IdToDescription setValue:describe forKey:foodId];
            [self.IdToTag setObject:tag forKey:foodId];
        }
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *object in objects) {
                PFFile *imageFile = [object objectForKey:@"Image"];
                [self.IdToImageFile setValue:imageFile forKey:foodId];
            }
            [self.tableView reloadData];
        }];
    }

    

    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"VIEW WILL Appear");
    if ([self checkToReload]){
        NSLog(@"Reload again check\n");

    }
    
    [super viewWillAppear:true];
}

-(bool)checkToReload{
    bool shouldReload = false;
    PFUser *user = [PFUser currentUser];
    self.userObject = [PFQuery getUserObjectWithId:user.objectId];
    NSMutableArray *fetched = [[NSMutableArray alloc] initWithArray:self.userObject[@"SavedPhotos"]];
    
    NSLog(@"Count: %lu", (unsigned long)[fetched count]);
    for (NSString *identification in fetched) {
        if ([self.Id containsObject:identification]) {
            NSLog(@"here1");
        }
        else{
            NSLog(@"Here");
            shouldReload = true;
            [self.Id addObject:identification];
            PFQuery *query = [PFQuery queryWithClassName:@"FoodPhoto"];
            [query whereKey:@"objectId" equalTo:identification];
            
            NSArray* objects = [query findObjects];
            
            for (PFObject *object in objects) {
                NSString *describe = object[@"Description"];
                PFFile *imageFile = [object objectForKey:@"Image"];
                NSString *tag = [object objectForKey:@"Tag"];
                [self.IdToImageFile setValue:imageFile forKey:identification];
                [self.IdToDescription setValue:describe forKey:identification];
                [self.IdToTag setObject:tag forKey:identification];
            }
        }
        [self.tableView reloadData];

    }
    return shouldReload;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"CountHello: %lu", (unsigned long)[self.Id count]);

    return [self.Id count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodCell" forIndexPath:indexPath];
    
    NSString *identify = self.Id[indexPath.row];
    
    PFFile* file = [self.IdToImageFile valueForKey:identify];
    [file getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:result];
            cell.imageView.image = image;
        }
    }];

    
    cell.textLabel.text =[self.IdToDescription valueForKey:identify];
    cell.detailTextLabel.text =[self.IdToTag valueForKey:identify];

    // Configure the cell...
    
    return cell;
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/



/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"restSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[RestaurantViewController class]]) {
            RestaurantViewController *rvc = (RestaurantViewController *)segue.destinationViewController;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            NSString* identification = self.Id[indexPath.row];
            
            PFQuery *queryForRestID = [PFQuery queryWithClassName:@"FoodPhoto"];
            PFObject *food = [queryForRestID getObjectWithId:identification];
            NSString *restaurantID = food[@"restaurantID"];
            
            PFQuery *queryRest = [PFQuery queryWithClassName:@"Restaurant"];
            PFObject *restaurant = [queryRest getObjectWithId:restaurantID];
            
            rvc.name = restaurant[@"Name"];
            rvc.describe = restaurant[@"Description"];
            rvc.point = restaurant[@"Location"];
            rvc.website = restaurant[@"Link"];
            rvc.summary = restaurant[@"summary"];
        }
    }
}


@end
