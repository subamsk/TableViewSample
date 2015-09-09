//
//  TSDisplayDataDAO.m
//  TableViewApplication
//
//  Created by subashini MSK 
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//

#import "TSFactsDataDAO.h"
#import "TSFactsItemData.h"


NSString * const kTitleKey                                          =  @"title";
NSString * const kFactsRowKey                                       =  @"rows";
NSString * const kDescriptionRowKey                                 =  @"description";
NSString * const kImageURLKey                                       =  @"imageHref";

@implementation TSFactsDataDAO

- (id) convert: (id) value {
    
    if ([value isKindOfClass: [NSNull class]]){
        return nil;
    }
    
    return value;
}

/*********************************************************************************
 
 MethodName:convertResponseToDataObject
 Purpose:Converts Dictionary from JSON to Model object
 ***********************************************************************************/

- (TSFactsData *) convertResponseToDataObject:(NSDictionary*)responsedict
{
    TSFactsData *factsData = nil;
    if(responsedict != nil && [responsedict count] > 0 )
    {
        factsData = [[TSFactsData alloc]init];
        NSMutableArray *displayItems = [[NSMutableArray alloc] init];
        
        factsData.title = [responsedict valueForKey:kTitleKey];
        NSMutableDictionary *rows = [responsedict valueForKey:kFactsRowKey];
        if([rows count] > 0 )
        {
            for(NSDictionary *rowData in rows)
            {
                TSFactsItemData *factsItemData  = [[TSFactsItemData alloc] init];
                if((rows != nil) && [rows count ] >0)
                {
                    factsItemData.factTitle =[self convert:[rowData valueForKey:kTitleKey]];
                    factsItemData.factDescription = [self convert:[rowData valueForKey:kDescriptionRowKey]];
                    factsItemData.imageURL = [self convert:[rowData valueForKey:kImageURLKey]];
                
                }
                //If the dataItem does not have any of the items,do not add in the display Items array
                if(factsItemData.factTitle != nil || factsItemData.factDescription != nil || factsItemData.imageURL != nil)
                {
                    [displayItems addObject:factsItemData];
                }
            }
            factsData.dataItems = displayItems;
        }
    }
    return factsData;
}


@end
