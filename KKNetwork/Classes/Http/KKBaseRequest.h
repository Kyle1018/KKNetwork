//
//  KKBaseRequest.h
//  KyleMedical
//
//  Created by Kyle on 16/6/17.
//  Copyright © 2016年 Kyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKBaseModel.h"
#import "KKRequestError.h"

@class AFHTTPSessionManager;

typedef NS_ENUM(NSInteger, KKHttpMethodType) {
    KKHttpMethodType_GET,
    KKHttpMethodType_POST,
};

typedef void (^KKRequestSuccess)(KKBaseModel *model, KKRequestError *error);
typedef void (^KKRequestFailure)(KKBaseModel *model, KKRequestError *error);

@interface KKBaseRequest : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, strong) NSMutableDictionary *requestParameters;

- (KKHttpMethodType)httpMethodType;
- (NSString *)apiBaseURL;
- (NSString *)urlPath;
- (NSDictionary *)commonParameters;
- (id)buildModelWithJsonDictionary:(NSDictionary *)dictionary;

- (void)requestWithSuccess:(KKRequestSuccess)success failure:(KKRequestFailure)failure;
- (void)cancel;

/// Default is 0.
@property (nonatomic, assign) NSUInteger retryCount;
/// Default is 0.0.
@property (nonatomic, assign) NSTimeInterval retryTimeInterval;

@property (nonatomic, assign) BOOL isUseCache;

- (NSString *)cacheFilePath;

- (id)getCacheObject;

@end

//@interface KKBaseRequest (KKRetry)
//
///// Default is 0.
//@property (nonatomic, assign) NSUInteger retryCount;
///// Default is 0.0.
//@property (nonatomic, assign) NSTimeInterval retryTimeInterval;
//
//@end

//@interface KKBaseRequest (KKCache)
//
//@property (nonatomic, assign) BOOL isUseCache;
//
//- (NSString *)cacheFilePath;
//
//- (id)getCacheObject;
//
//@end
