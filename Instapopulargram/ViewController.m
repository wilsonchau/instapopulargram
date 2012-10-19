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

@interface ViewController ()

@end

@implementation ViewController
@synthesize listData;
@synthesize responseData;
@synthesize myTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Make api call to instagram and store results
    
    NSLog(@"viewdidload");
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
    
    static NSString *tableIdentifier = @"TableIdentifier";
    // Reuse cells
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:tableIdentifier];
    
    // No cell to reuse, allocate new cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:tableIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    // For now just use username
    // Need to set image here
    // Need to decide how to store images? or just load all? or cache some
    cell.textLabel.text = [[[listData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"username"];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
