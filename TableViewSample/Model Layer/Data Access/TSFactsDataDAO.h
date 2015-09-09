//
//  TSDisplayDataDAO.h
//  TableViewApplication
//
//  Created by subashini MSK 
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TSFactsData.h"

@interface TSFactsDataDAO : NSObject

- (TSFactsData*) convertResponseToDataObject:(NSDictionary*)responsedict;

@end
