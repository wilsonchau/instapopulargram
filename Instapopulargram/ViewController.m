//
//  ViewController.m
//  Instapopulargram
//
//  Created by Wilson Chau on 10/18/12.
//  Copyright (c) 2012 Wilson Chau. All rights reserved.
//

// Used these tutorials
// http://agilewarrior.wordpress.com/2012/02/01/how-to-make-http-request-from-iphone-and-parse-json-result/

#import "ViewController.h"
#import "PopularPictureCell.h"

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
    
    // Move all this to init function??? so we dont have to call reload data
    // Grab JSON popular image data
    self.pictureData = [self grabPopularImageMetaData];
    [self.myTableView reloadData];
    self.allPictures = [NSMutableDictionary dictionary];
    
}

- (NSArray*) grabPopularImageMetaData {
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=50c0e12b64a84dd0b9bbf334ba7f6bf6"]] options:NSJSONReadingMutableLeaves error:&myError];
    
    // extract data
    NSArray *data = [res objectForKey:@"data"];
    
    // set listdata to data
    // maybe take this out and just use responsedata directly?
    return data;
}

// Need to create function to resize images to improve scrolling performance

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
    
    NSData *imageData;
    
    // Grab profile image
    NSURL *imageUrl = [NSURL URLWithString:[[[self.pictureData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"profile_picture"]];
    UIImage *profileImage = [self.allPictures objectForKey:imageUrl];
    if (profileImage == nil) {
        // Image not in cache yet so dl it!
        imageData = [NSData dataWithContentsOfURL:imageUrl];
        profileImage = [UIImage imageWithData:imageData];
        [self.allPictures setObject:profileImage forKey:imageUrl];
    }
    cell.profileImage.image = profileImage;
    
    // Grab popular image
    imageUrl = [NSURL URLWithString:[[[[self.pictureData objectAtIndex:row] objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
    UIImage *popularImage = [self.allPictures objectForKey:imageUrl];
    if (popularImage == nil) {
        // Image not in cache yet so dl it!
        imageData = [NSData dataWithContentsOfURL:imageUrl];
        popularImage = [UIImage imageWithData:imageData];
        [self.allPictures setObject:popularImage forKey:imageUrl];
    }
    cell.popularImage.image = popularImage;
    
    return cell;
}

#pragma mark -
#pragma mark NSURLConnection Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"data finished loading");
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
//        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self loadImagesForOnscreenRows];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
