//
//  TSDisplayServiceClient.h
//  TableViewApplication
//
//  Created by subashini MSK
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSDisplayServiceClient : NSObject

-(void)getResponseForServiceURLString:(NSString*)serviceURL completionHandler:(void(^)(id returnValue,NSError *error,NSString *erroMessage))completeionHandler;
-(void)getImageForServiceURLString:(NSString*)serviceURL completionHandler:(void(^)(NSData *imageData,NSError *error))completeionHandler;

-(void)cancelAllPendingTasks;

@end
