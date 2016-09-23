//
//  KKRequestError.m
//  KyleMedical
//
//  Created by Kyle on 16/6/20.
//  Copyright © 2016年 Kyle. All rights reserved.
//

#import "KKRequestError.h"

static NSString *const kDefaultErrorMessage = @"请求发生错误";
static NSInteger const kDefaultErrorCode = -1000;

@interface KKRequestError () {
    NSInteger _errorCode;
    NSString *_errorMessage;
}

@end

@implementation KKRequestError

- (instancetype)initWithError:(NSError *)error
{
    self = [super init];
    if (self) {
        _errorCode = error.code;
    }
    return self;
}

- (instancetype)initWithErrorCode:(NSInteger)code errorMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        _errorCode = code;
        _errorMessage = message;
    }
    return self;
}

- (instancetype)initWithErrorMessage:(NSString *)errorMessage
{
    return [self initWithErrorCode:kDefaultErrorCode errorMessage:errorMessage];
}

- (NSInteger)errorCode
{
    return _errorCode;
}

- (NSString *)errorMessage
{
    if (!_errorMessage) {
        if (_errorCode / 200 != 1) {
            _errorMessage = kDefaultErrorMessage;
        }
    }
    return _errorMessage;
}

@end
