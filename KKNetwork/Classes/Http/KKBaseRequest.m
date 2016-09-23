//
//  PRBaseRequest.m
//  KyleMedical
//
//  Created by Kyle on 16/6/17.
//  Copyright © 2016年 Kyle. All rights reserved.
//

#import "KKBaseRequest.h"
#import <AFNetworking/AFNetworking.h>

@interface KKBaseRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, strong) NSURLSessionDataTask *httpTask;

@property (nonatomic, copy) KKRequestSuccess requestSuccess;
@property (nonatomic, copy) KKRequestFailure requestFailure;

@property (nonatomic, assign) NSUInteger currentRetryCount;

@end

@implementation KKBaseRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.retryCount = 0;
        self.retryTimeInterval = 0.;
        self.isUseCache = NO;
        self.httpSessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (NSDictionary *)commonParameters
{
    return @{};
}

- (NSMutableDictionary *)requestParameters
{
    if (!_requestParameters) {
        _requestParameters = [NSMutableDictionary dictionary];
    }
    return _requestParameters;
}

- (KKHttpMethodType)httpMethodType
{
    return KKHttpMethodType_GET;
}

- (NSString *)apiBaseURL
{
    return nil;
}

- (NSString *)urlPath
{
    return nil;
}

- (id)buildModelWithJsonDictionary:(NSDictionary *)dictionary
{
    return nil;
}

- (void)requestWithSuccess:(KKRequestSuccess)success failure:(KKRequestFailure)failure
{
    self.requestSuccess = success;
    self.requestFailure = failure;
    switch ([self httpMethodType]) {
        case KKHttpMethodType_GET: {
            [self makeGetRequest];
            
            break;
        } case KKHttpMethodType_POST: {
            [self makePostRequest];
            
            break;
        } default:
            break;
    }
}

- (NSDictionary *)buildParameters
{
    NSMutableDictionary *httpDictionary = [[self commonParameters] mutableCopy];
    
    for (id key in self.requestParameters) {
        [httpDictionary setObject:self.requestParameters[key] forKey:key];
    }
    return [httpDictionary copy];
}

- (NSString *)buildRequestURL
{
    NSAssert(([self apiBaseURL] != nil), @"apiBaseURL不能为空");
    NSAssert(([self urlPath] != nil), @"urlPath不能为空");
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [self apiBaseURL], [self urlPath]];
    
//    requestURL = [requestURL stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    return requestURL;
}

- (void)makeGetRequest
{
    self.httpTask = [self.httpSessionManager GET:[self buildRequestURL] parameters:[self buildParameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self handleSuccessWithURLSessionDataTask:task responseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self handleFailureWithURLSessionDataTask:task error:error];
        
    }];
}

- (void)makePostRequest
{
    self.httpTask = [self.httpSessionManager POST:[self buildRequestURL] parameters:[self buildParameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self handleSuccessWithURLSessionDataTask:task responseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self handleFailureWithURLSessionDataTask:task error:error];
        
    }];
}

- (void)handleSuccessWithURLSessionDataTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if (self.isUseCache) {
            [self cacheResponseObject:responseObject];
        }
        
        if (self.requestSuccess) {
            self.requestSuccess([self buildModelWithJsonDictionary:responseObject], nil);
            self.requestSuccess = nil;
        }
    } else {
        DDLogError(@"responseObject不为dictionary");
    }
}

- (void)handleFailureWithURLSessionDataTask:(NSURLSessionDataTask *)task error:(NSError *)error
{
    if ((self.retryCount > 0) && (++self.currentRetryCount < self.retryCount)) {
#warning dispatch_after 若interval为0，调用为同步还是异步?
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.retryTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestWithSuccess:self.requestSuccess failure:self.requestFailure];
        });
        return;
    }
    
    if (self.requestFailure) {
        self.requestFailure(nil, [[KKRequestError alloc] initWithError:error]);
        self.requestFailure = nil;
    }
}

- (void)cancel
{
    self.requestSuccess = nil;
    self.requestFailure = nil;
    [self.httpTask cancel];
}

#pragma mark - KKCache

- (NSString *)cacheFileDirectory
{
    return nil;
}

- (NSString *)cacheFilePath
{
    return nil;
}

- (id)getCacheObject
{
    NSString *directory = [self cacheFileDirectory];
    NSString *path = [self cacheFilePath];
    
    NSAssert(((directory != nil) && (path != nil)), @"缓存文件夹&文件路径不能为空, cacheFileDirectory = %@, cacheFilePath = %@", directory, path);
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@%@", directory, path]];
    
    if (dictionary) {
        return [self buildModelWithJsonDictionary:dictionary];
    } else {
        return nil;
    }
}

- (void)cacheResponseObject:(NSDictionary *)responseObject
{
#warning 进一步明确archive的使用及存储数据形式
    NSString *directory = [self cacheFileDirectory];
    NSString *path = [self cacheFilePath];
    
    NSAssert(((directory != nil) && (path != nil)), @"缓存文件夹&文件路径不能为空, cacheFileDirectory = %@, cacheFilePath = %@", directory, path);
    [NSKeyedArchiver archiveRootObject:responseObject toFile:[NSString stringWithFormat:@"%@%@", directory, path]];
}

@end
