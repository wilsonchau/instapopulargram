//
//  PopularPictureCell.m
//  Instapopulargram
//
//  Created by Wilson Chau on 10/19/12.
//  Copyright (c) 2012 Wilson Chau. All rights reserved.
//

#import "PopularPictureCell.h"

@implementation PopularPictureCell
@synthesize userName, profileImage, popularImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
