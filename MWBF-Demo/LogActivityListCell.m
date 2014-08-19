//
//  ActivityListCell.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/31/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "LogActivityListCell.h"

@implementation LogActivityListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
