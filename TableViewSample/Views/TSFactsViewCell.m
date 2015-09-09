//
//  TSFactsViewCell.m
//  TableViewApplication
//
//  Created by subashini MSK 
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//

#import "TSFactsViewCell.h"
#import "UIFont+customFont.h"
#import "UIColor+CustomColor.h"
#import "TSFactsLabel.h"
#import "TSConstants.h"

@interface TSFactsViewCell()
{
    UIActivityIndicatorView *imagedownloadindicatorView;
}

@property (nonatomic,strong) NSMutableArray *rightGutterConstraints;


@end

@implementation TSFactsViewCell

@synthesize lblTitle,lblDescription,rightImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        lblTitle = [[UILabel alloc]init];
        self.lblTitle.numberOfLines = 0;
        self.lblTitle.font = [UIFont rowTitleFont];
        self.lblTitle.textColor = [UIColor rowTitleColor];
        self.lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        
        lblDescription = [[TSFactsLabel alloc]init];
        self.lblDescription.numberOfLines = 0;
        self.lblDescription.font = [UIFont rowSubtitleFont];
        self.lblDescription.textColor = [UIColor rowSubtitleColor];
        self.lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
        
        rightImageView = [[UIImageView alloc]init];
        self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    
        imagedownloadindicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [imagedownloadindicatorView setTag:kCellActivityIndicatorTag];
        [self.rightImageView addSubview:imagedownloadindicatorView];
        imagedownloadindicatorView.center = CGPointMake(self.rightImageView.frame.size.width/2,self.rightImageView.frame.size.height/2);

        
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblDescription];
        
        
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = NO;
        self.rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
        imagedownloadindicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.rightGutterConstraints = [NSMutableArray array];
        
        [self applyConstraints];

        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    //Set the Gradient for the table view cell
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:51/255.0] CGColor], nil];
    
    [self setBackgroundView:[[UIView alloc] init]];
    [self.backgroundView.layer insertSublayer:gradient atIndex:0];
   
    self.lblDescription.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    [super layoutSubviews];
    
}

- (void)applyConstraints {
    
    
    [self.contentView removeConstraints:self.contentView.constraints];
    
    const double cellPadding = 10.f;
    
    // add lblTitle constraints
    //add  lblTitle left margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lblTitle
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:cellPadding]];
    
    //add lblTitle top margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lblTitle
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:cellPadding]];
    //add lblTitle bottom margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lblTitle
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.lblDescription
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0]];
    
    // add lblDescription constraints
    // add lblDescription left margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lblDescription
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:cellPadding]];
    
    // add lblDescription right margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lblDescription
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.rightImageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:0]];
    
    // add rightImageView constraints
    // add rightImageView top margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightImageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.lblDescription
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0]];
    
    // add rightImageView constant width constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:70]];
    
    // add rightImageView constant height constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:60]];
    
    // add right gutter right attribute constraints
    [self.rightGutterConstraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.rightImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1
                                                                         constant:cellPadding]];
    
    //// add imagedownloadindicatorView constraints
    // add imagedownloadindicatorView top margin constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imagedownloadindicatorView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.lblDescription
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0]];

    [self.rightGutterConstraints addObject:[NSLayoutConstraint constraintWithItem:self.rightImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:imagedownloadindicatorView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1
                                                                         constant:cellPadding]];
  
    // add lblDescription bottom margin constraints and flexible height
    NSLayoutConstraint * bottomMarginConstraint = [NSLayoutConstraint constraintWithItem:self.lblDescription
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                  toItem:self.rightImageView
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1
                                                                                constant:0];
    
    [bottomMarginConstraint setPriority:750];
    [self.contentView addConstraint:bottomMarginConstraint];
    
    
    // add right gutter bottom and flexebile height constraints
    [self.rightGutterConstraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.lblDescription
                                                                        attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                         constant:cellPadding]];
    
    // add lblDescription bottom margin constraints and flexible height
    [self.contentView addConstraints:self.rightGutterConstraints];
    
    
}
@end
