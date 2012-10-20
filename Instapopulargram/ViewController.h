//
//  ViewController.h
//  Instapopulargram
//
//  Created by Wilson Chau on 10/18/12.
//  Copyright (c) 2012 Wilson Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDelegate> {
    NSMutableData *responseData;
    NSArray *listData;
    IBOutlet UITableView *myTableView;
    NSCache *popularPictures;
    NSCache *profilePictures;
}

@property(nonatomic, retain) NSArray *listData;
@property(nonatomic, retain) NSMutableData *responseData;
@property(nonatomic, retain) IBOutlet UITableView *myTableView;
@property(nonatomic, retain) NSCache *popularPictures;
@property(nonatomic, retain) NSCache *profilePictures;
@end
