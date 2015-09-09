//
//  TSDisplayServiceClient.m
//  TableViewApplication
//
//  Created by subashini MSK 
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//

#import "TSDisplayServiceClient.h"
#import "TSFactsItemData.h"
#import "TSFactsDataDAO.h"
#import "TSFactsData.h"
#import "TSConstants.h"

@implementation TSDisplayServiceClient

/*********************************************************************************
 
 MethodName:getResponseForServiceURLString
 Purpose:uses NSURLSession to fetch the data from the URL
 ***********************************************************************************/

-(void)getResponseForServiceURLString:(NSString*)serviceURL completionHandler:(void(^)(id returnValue,NSError *error,NSString *errorMessage))completeionHandler{
    
    NSURLSession *urlSession = [NSURLSession sharedSession] ;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                                  diskCapacity:0
                                                                      diskPath:nil];
    [sessionConfiguration setTimeoutIntervalForResource:kSessionTimeoutInterval];
    [sessionConfiguration setTimeoutIntervalForRequest:kSessionTimeoutInterval];
   
    
     NSURLSessionDataTask* dataTask = [urlSession dataTaskWithURL:[NSURL URLWithString:serviceURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         
         NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
         
         NSString *errorMessage = @"";
         
         switch (statusCode) {
             case kHttpStatusOk:
                 if(error==nil)
                 {
                     NSString *str = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                     NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                     NSMutableDictionary *jsondict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                     
                     //converts json dictionary Response to Model Data Object
                      TSFactsDataDAO *factsDataDAO = [[TSFactsDataDAO alloc]init];
                     TSFactsData *factsData = nil;
                     if(jsondict != nil  && [jsondict count] > 0)
                     {
                        factsData = [factsDataDAO convertResponseToDataObject:jsondict];
                        if(factsData == nil)
                        {
                            errorMessage = kErrMsgNoData;
                        }
                     }
                     else
                     {
                          errorMessage = kErrMsgNoData;
                     }
                     completeionHandler(factsData,error,errorMessage);
                 }
                 break;
              case kHttpSessionTimeOut:
                 errorMessage = kErrMsgSessionTimeOut;
                 completeionHandler(nil,error,errorMessage);
                 break;
             case kNetworkError:
                 errorMessage = kErrMsgServerConnection;
                 completeionHandler(nil,error,errorMessage);
                 break;
             default:
                 errorMessage = kErrMsgServerConnection;
                 completeionHandler(nil,error,errorMessage);
                 break;
         }
       
     }];
    
    [dataTask resume];
   
}
/*********************************************************************************
 
 MethodName:getImageForServiceURLString
 Purpose:uses NSURLSessionDownloadTask to fetch the image from the URL
 ***********************************************************************************/

-(void) getImageForServiceURLString:(NSString*)serviceURL completionHandler:(void(^)(NSData *imageData,NSError *error))completeionHandler
{
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                                  diskCapacity:0
                                                                      diskPath:nil];
    [sessionConfiguration setTimeoutIntervalForResource:kSessionTimeoutInterval];
    [sessionConfiguration setTimeoutIntervalForRequest:kSessionTimeoutInterval];
    [sessionConfiguration setHTTPMaximumConnectionsPerHost:1];
   
    
    NSURLSessionDownloadTask* downloadTask = [urlSession downloadTaskWithURL:[NSURL URLWithString:serviceURL] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
       {
            NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if(error==nil &&  location != nil && statusCode == kHttpStatusOk)
            {
                
                NSData *imageData = [NSData dataWithContentsOfURL:location];
                completeionHandler(imageData,error);
            }
            else
            {
                completeionHandler(nil,error);
            }
        
       }];
    
    [downloadTask resume];
}

/*********************************************************************************
 
 MethodName:cancelAllPendingTasks
 Purpose:Cancels all outstanding tasks and then invalidates the session object.
 ***********************************************************************************/

-(void)cancelAllPendingTasks
{
    [[NSURLSession sharedSession] invalidateAndCancel];
}

@end
