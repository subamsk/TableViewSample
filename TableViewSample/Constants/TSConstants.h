//
//  TSConstants.m
//  TableViewApplication
//
//  Created by subashini MSK 
//  Copyright (c) 2015 subashini MSK. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int kCellActivityIndicatorTag     = 101;

//HTTP Error Constants
static const int kSessionTimeoutInterval       = 60;
static const int kHttpStatusOk                 = 200;
static const int kNetworkError                 = 0;
static const int kHttpSessionTimeOut           = 504;

static NSString* const kServiceURL             = @"https://dl.dropboxusercontent.com/u/746330/facts.json";

//Button tittle
static NSString*  const kRefreshBtnTitle       = @"Refresh";

//Alert view Error Messages
static NSString* const kErrorMsgTitle          = @"Error";
static NSString* const kErrMsgNoData           = @"No Data to load";
static NSString* const kErrMsgSessionTimeOut   = @"Session Timed out.Please try again.";
static NSString* const kErrMsgServerConnection = @"There is a problem connecting to server.Please check your network connection.";

//Images
static NSString* kNotAvailbleImageName         = @"NoImage.png";
static NSString* kDownloadFailedImageName      = @"Failed.png";