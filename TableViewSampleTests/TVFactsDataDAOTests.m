//
//  TVFactsDataDAOTests.m
//  TableViewSample
//
//  Created by subashini MSK on 09/09/15.
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "TSFactsDataDAO.h"
#import "TSFactsData.h"
#import "TSFactsItemData.h"


@interface TVFactsDataDAOTests : XCTestCase

@end

@implementation TVFactsDataDAOTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/*********************************************************************************
 
 MethodName:testEmptyJsonDict
 Purpose:Negative Test case for Empty and nil Dictionary
 ***********************************************************************************/

- (void)testEmptyJsonDict {
    
    TSFactsDataDAO *factsDataDAO = [[TSFactsDataDAO alloc] init];
    
    //Check for nil
    TSFactsData *factsData = [factsDataDAO convertResponseToDataObject:nil];
    XCTAssertNil(factsData);
    
    //Check for Empty Dictionary
    NSMutableDictionary *jsonDictionary = [[NSMutableDictionary alloc]init];
    factsData = [factsDataDAO convertResponseToDataObject:jsonDictionary];
    XCTAssertNil(factsData);
   
}
/*********************************************************************************
 
 MethodName:testValidJsonDict
 Purpose:Positive Test case with Proper Valid JSON Dictionary
 ***********************************************************************************/

- (void)testValidJsonDict {
    
    TSFactsDataDAO *factsDataDAO = [[TSFactsDataDAO alloc] init];
    
    NSString *title = @"About Canada";
    NSString *factTitle = @"Beavers";
    NSString *factDescription = @"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony";
    NSString *imageURL = @"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg";
    
    NSMutableDictionary *jsonDictionary = [[NSMutableDictionary alloc]init];
    [jsonDictionary setObject:title forKey:@"title"];
    
    NSMutableArray *dataItems = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataItemsDictionary = [[NSMutableDictionary alloc]init];
    [dataItemsDictionary setObject:factTitle forKey:@"title"];
    [dataItemsDictionary setObject:factDescription forKey:@"description"];
    [dataItemsDictionary setObject:imageURL forKey:@"imageHref"];
    [dataItems addObject:dataItemsDictionary];
    
    [jsonDictionary setObject:dataItems forKey:@"rows"];
    
    TSFactsData *factsData = [factsDataDAO convertResponseToDataObject:jsonDictionary];
    
    XCTAssertNotNil(factsData);
    XCTAssertEqualObjects(factsData.title, title);
    XCTAssertTrue([factsData.dataItems count] > 0);
    TSFactsItemData *factsItemData =  (TSFactsItemData*)[factsData.dataItems objectAtIndex:0];
    XCTAssertEqualObjects(factsItemData.factTitle, factTitle);
    XCTAssertEqualObjects(factsItemData.factDescription, factDescription);
    XCTAssertEqualObjects(factsItemData.imageURL, imageURL);
}

/*********************************************************************************
 
 MethodName:testEmptyDataItems
 Purpose:Negative Test case with empty dataItems
 ***********************************************************************************/

- (void)testEmptyDataItems {
   
    TSFactsDataDAO *factsDataDAO = [[TSFactsDataDAO alloc] init];
    
    NSString *title = @"About Canada";
    
    NSMutableDictionary *jsonDictionary = [[NSMutableDictionary alloc]init];
    [jsonDictionary setObject:title forKey:@"title"];
    NSMutableArray *dataItems = [[NSMutableArray alloc] init];
    [jsonDictionary setObject:dataItems forKey:@"rows"];
    
    TSFactsData *factsData = [factsDataDAO convertResponseToDataObject:jsonDictionary];
    
    XCTAssertNotNil(factsData);
    XCTAssertEqualObjects(factsData.title, title);
    XCTAssertNil(factsData.dataItems);
    XCTAssertTrue([factsData.dataItems count] == 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
