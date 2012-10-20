//
//  PopularPictureCell.h
//  Instapopulargram
//
//  Created by Wilson Chau on 10/19/12.
//  Copyright (c) 2012 Wilson Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularPictureCell : UITableViewCell {
    IBOutlet UILabel *userName;
    IBOutlet UIImageView *profileImage;
    IBOutlet UIImageView *popularImage;
}

@property (nonatomic, retain) IBOutlet UILabel *userName;
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UIImageView *popularImage;

@end
