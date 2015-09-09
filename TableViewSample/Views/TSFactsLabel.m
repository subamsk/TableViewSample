//
//  TSFactsLabel.m
//  TableViewApplication
//
//  Created by subashini MSK on 07/09/15.
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//

#import "TSFactsLabel.h"

@implementation TSFactsLabel

- (id)init {
    self = [super init];
    
    // required to prevent Auto Layout from compressing the label (by 1 point usually) for certain constraint solutions
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired
                                          forAxis:UILayoutConstraintAxisVertical];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    
    [super layoutSubviews];
}

@end
