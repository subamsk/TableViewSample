//
//  TSViewController.m
//  TableViewApplication
//
//  Created by subashini MSK
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//

#import "TSViewController.h"
#import "TSFactsViewCell.h"
#import "TSDisplayServiceClient.h"
#import "TSFactsItemData.h"
#import "TSFactsData.h"
#import "UIFont+customFont.h"
#import "TSConstants.h"

@interface TSViewController ()
{
    
    UIActivityIndicatorView *activityIndicator;
    TSFactsData *factsData;
    TSDisplayServiceClient *serviceClient;
    
    NSMutableArray *factsRowData;
    
}

@property(nonatomic,strong) UITableView *displayTableView;

@end


@implementation TSViewController

#pragma mark - ViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set Navigation Bar Button Item
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:kRefreshBtnTitle style:UIBarButtonItemStyleDone target:self action:@selector(refreshBtnAction)];
    self.navigationItem.rightBarButtonItem = button;
    
    //Create TableView
    _displayTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.displayTableView.delegate = self;
    self.displayTableView.dataSource = self;
    [self.view addSubview:self.displayTableView];
    
    //Set activity Indicator
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin   |
    UIViewAutoresizingFlexibleBottomMargin;
    
    [self.displayTableView addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.displayTableView.frame.size.width/2,self.displayTableView.frame.size.height/2);
    
    self.displayTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    serviceClient = [[TSDisplayServiceClient alloc]init];
    //Fetch the data asynchronously from the URL
    [self fetchData];
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [[[self.view.layer sublayers] objectAtIndex:0] setFrame:self.view.frame];
         [self.displayTableView reloadData];
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - UITableViewDataSource  methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [factsRowData count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentiier = @"displaycell";
    
    TSFactsViewCell *cell = (TSFactsViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentiier];
    if(cell == nil)
    {
        cell = [[TSFactsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentiier];
        cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight  ;
    }
    
    //Set the Label Title
    TSFactsItemData *factItemData = (TSFactsItemData*)[factsData.dataItems objectAtIndex:indexPath.row];
    cell.lblTitle.text = factItemData.factTitle;
    cell.lblDescription.text = factItemData.factDescription;
    
    //Fetch the image for the row asynchronously if Image is not already downloaded for the cell
    cell.rightImageView.image = nil;
    if(factItemData.imageURL != nil && factItemData.factsImage == nil) //If Image URL is not nil && Image is not fetched already
    {
        
        UIActivityIndicatorView *imageDownlaodactivityIndicator = (UIActivityIndicatorView*)[cell.rightImageView viewWithTag:kCellActivityIndicatorTag];
        [imageDownlaodactivityIndicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
                       {
                           [serviceClient getImageForServiceURLString:factItemData.imageURL completionHandler:^(NSData* imageData,NSError *error)
                            {
                                dispatch_async(dispatch_get_main_queue(),^
                                               {
                                                   TSFactsViewCell *cell = (TSFactsViewCell*)[self.displayTableView cellForRowAtIndexPath:indexPath];
                                                   UIActivityIndicatorView *imageDownlaodactivityIndicator = (UIActivityIndicatorView*)[cell.rightImageView viewWithTag:kCellActivityIndicatorTag];
                                                   [imageDownlaodactivityIndicator stopAnimating];
                                                   if(error == nil && imageData != nil)
                                                   {
                                                       //Set the image on the cell
                                                       
                                                       factItemData.factsImage = [UIImage imageWithData:imageData];
                                                       cell.rightImageView.image = factItemData.factsImage;
                                                       
                                                   }
                                                   else{ //If data download failed set the failed images
                                                       cell.rightImageView.image = [UIImage imageNamed:kDownloadFailedImageName];
                                                       
                                                   }
                                                   
                                               });
                            }];
                           
                           
                       });
        
    }
    else if(factItemData.imageURL == nil) //If Image URL is nil set default image
    {
        cell.rightImageView.image = [UIImage imageNamed:kNotAvailbleImageName];
    }
    else //If Image URL is not nil and image is already fetched
    {
        cell.rightImageView.image = factItemData.factsImage;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSFactsItemData *factsItemData = (TSFactsItemData*)[factsData.dataItems objectAtIndex:indexPath.row];
    TSFactsViewCell *cell = [[TSFactsViewCell alloc] init];
    cell.lblTitle.text  = factsItemData.factTitle;
    cell.lblDescription.text = factsItemData.factDescription;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    //get the cell bounds
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.displayTableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    //Calculate the new/required cell height
    CGFloat calculatedCellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    calculatedCellHeight += 1.0f;
    
    return calculatedCellHeight;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Local Methods

/*********************************************************************************
 
 MethodName:fetchData
 Purpose:Fetches the JSON Data from the specified URL
 ***********************************************************************************/

-(void) fetchData
{
    [self startAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
                   {
                       [serviceClient getResponseForServiceURLString:kServiceURL completionHandler:^(id returnValue,NSError *error,NSString *errorMessage)
                        {
                            dispatch_async(dispatch_get_main_queue(),^
                                           {
                                               [self stopAnimation];
                                               
                                               if(returnValue != nil && error == nil && [errorMessage isEqualToString:@""])
                                               {
                                                   //Clear the existing data in the table after getting the data
                                                   [self clearTableData];
                                                   
                                                   //set the data to the data model objects
                                                   factsData = returnValue;
                                                   factsRowData = [NSMutableArray arrayWithArray:factsData.dataItems];
                                                   
                                                   //set the Navigation bar title
                                                   self.navigationItem.title = factsData.title;
                                                   [self.displayTableView reloadData]; //Reload the data in the table
                                               }
                                               else
                                               {
                                                   
                                                   UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:kErrorMsgTitle message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                   [alertview show];
                                               }
                                           });
                        }];
                       
                   });
    
}

/*********************************************************************************
 
 MethodName:startAnimation
 Purpose:Start the activityIndicator and disable the refresh button
 ***********************************************************************************/

-(void)startAnimation
{
    [activityIndicator startAnimating];
    [self.navigationItem.rightBarButtonItem setEnabled:FALSE];
}

/*********************************************************************************
 
 MethodName:stopAnimation
 Purpose:Stop the activityIndicator and enable the refresh button
 ***********************************************************************************/

-(void)stopAnimation
{
    [activityIndicator stopAnimating];
    [self.navigationItem.rightBarButtonItem setEnabled:TRUE];
}

/*********************************************************************************
 
 MethodName:clearTableData
 Purpose:To Clear the tableview before Refresh
 ***********************************************************************************/
-(void) clearTableData
{
    [factsRowData removeAllObjects];
    [self.displayTableView reloadData];
}

#pragma mark - Button Actions
/*********************************************************************************
 
 MethodName:refreshBtnAction
 Purpose:Refresh the data in the tableview
 ***********************************************************************************/

-(void)refreshBtnAction
{
    //Cancel Pending Image downloads
    [serviceClient cancelAllPendingTasks];
    [self fetchData];
}

@end
