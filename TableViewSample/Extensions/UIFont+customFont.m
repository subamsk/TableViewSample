//
//  UIFont+customFont.m
//  TableViewApplication
//
//  Created by subashini MSK
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//

#import "UIFont+customFont.h"

@implementation UIFont (customFont)

+(UIFont*) rowTitleFont
{
    return  [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
}

+(UIFont*) rowSubtitleFont
{
    return  [UIFont fontWithName:@"HelveticaNeue" size:14];
}

+(UIFont*) navtitleFont
{
    return  [UIFont fontWithName:@"HelveticaNeue" size:16];
}

@end
