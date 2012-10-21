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
    NSArray *pictureData;
    IBOutlet UITableView *myTableView;
    NSMutableDictionary *allPictures;
}

@property(nonatomic, retain) NSArray *pictureData;
@property(nonatomic, retain) NSMutableData *responseData;
@property(nonatomic, retain) IBOutlet UITableView *myTableView;
@property(nonatomic, retain) NSMutableDictionary *allPictures;

@end
