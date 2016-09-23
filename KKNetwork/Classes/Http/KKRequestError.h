//
//  KKRequestError.h
//  KyleMedical
//
//  Created by Kyle on 16/6/20.
//  Copyright © 2016年 Kyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKRequestError : NSError

- (instancetype)initWithError:(NSError *)error;
- (instancetype)initWithErrorCode:(NSInteger)code errorMessage:(NSString *)message;
- (instancetype)initWithErrorMessage:(NSString *)errorMessage;

- (NSInteger)errorCode;
- (NSString *)errorMessage;

@end
