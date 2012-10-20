//
//  ViewController.m
//  Instapopulargram
//
//  Created by Wilson Chau on 10/18/12.
//  Copyright (c) 2012 Wilson Chau. All rights reserved.
//

// Used these tutorials
// http://agilewarrior.wordpress.com/2012/02/01/how-to-make-http-request-from-iphone-and-parse-json-result/
// http://www.mobisoftinfotech.com/blog/iphone/introduction-to-table-view/

#import "ViewController.h"
#import "PopularPictureCell.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize listData;
@synthesize responseData;
@synthesize myTableView;
@synthesize popularPictures;
@synthesize profilePictures;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Make api call to instagram and store results
    
    NSLog(@"viewdidload");
    self.popularPictures = [[NSCache alloc] init];
    self.profilePictures = [[NSCache alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=50c0e12b64a84dd0b9bbf334ba7f6bf6"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        // store response here
        self.responseData = [NSMutableData data];
    } else {
        // failed
    }
}

// Need to create function to resize images to improve scrolling performance

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
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
    
    // For now just use username
    // Need to set image here
    // Need to decide how to store images? or just load all? or cache some
    
    // Set user name
    cell.userName.text = [[[listData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"username"];
    
    NSData *imageData;
    
    // Grab profile image
    NSURL *imageUrl = [NSURL URLWithString:[[[self.listData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"profile_picture"]];
    UIImage *profileImage = [self.popularPictures objectForKey:imageUrl];
    if (profileImage == nil) {
        // Image not in cache yet so dl it!
        imageData = [NSData dataWithContentsOfURL:imageUrl];
        profileImage = [UIImage imageWithData:imageData scale:8.0];
        [self.profilePictures setObject:profileImage forKey:imageUrl];
    }
    cell.profileImage.image = profileImage;
    
    // Grab popular image
    imageUrl = [NSURL URLWithString:[[[[self.listData objectAtIndex:row] objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
    UIImage *popularImage = [self.popularPictures objectForKey:imageUrl];
    if (popularImage == nil) {
        // Image not in cache yet so dl it!
        imageData = [NSData dataWithContentsOfURL:imageUrl];
        popularImage = [UIImage imageWithData:imageData scale:8.0];
        [self.profilePictures setObject:popularImage forKey:imageUrl];
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
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // extract data
    NSArray *data = [res objectForKey:@"data"];
    
    // set listdata to data
    // maybe take this out and just use responsedata directly?
    self.listData = data;
    [self.myTableView reloadData];
    NSLog(@"data finished loading");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
