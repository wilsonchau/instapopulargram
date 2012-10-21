//
//  ViewController.m
//  Instapopulargram
//
//  Created by Wilson Chau on 10/18/12.
//  Copyright (c) 2012 Wilson Chau. All rights reserved.
//

// Used these tutorials
// http://agilewarrior.wordpress.com/2012/02/01/how-to-make-http-request-from-iphone-and-parse-json-result/
// Used https://github.com/rs/SDWebImage for asynchronous calls to get images, also caches them for us

#import "ViewController.h"
#import "PopularPictureCell.h"

#import "UIImageView+WebCache.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize pictureData;
@synthesize responseData;
@synthesize myTableView;
@synthesize allPictures;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewdidload");
    
    // Grab JSON popular image data
    self.pictureData = [self grabPopularImageMetaData];
    self.allPictures = [NSMutableDictionary dictionary];
    
}

- (NSArray*) grabPopularImageMetaData {
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=50c0e12b64a84dd0b9bbf334ba7f6bf6"]] options:NSJSONReadingMutableLeaves error:&myError];
    
    // extract data
    NSArray *data = [res objectForKey:@"data"];
    
    // return json as array
    return data;
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.pictureData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *tableIdentifier = @"PopularPictureCellIdentifier";
    // Reuse cells
    PopularPictureCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:tableIdentifier];
    
    // No cell to reuse, allocate new cell
    if (cell == nil) {
        cell = [[PopularPictureCell alloc]initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:tableIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    // Set user name
    cell.userName.text = [[[pictureData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"username"];
    
    // No need to cache images because sdwebimage takes care of that
    // sdwebimages also makes asynchronous request for images
    
    // Grab profile image
    NSURL *imageUrl = [NSURL URLWithString:[[[self.pictureData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"profile_picture"]];
    UIImage *profileImage = [self.allPictures objectForKey:imageUrl];
    if (profileImage == nil) {
        [cell.profileImage setImageWithURL:imageUrl];
    }
    
    // Grab popular image
    imageUrl = [NSURL URLWithString:[[[[self.pictureData objectAtIndex:row] objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
    UIImage *popularImage = [self.allPictures objectForKey:imageUrl];
    if (popularImage == nil) {
        [cell.popularImage setImageWithURL:imageUrl];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
