//
//  DZDataModel.h
//  DevZeng
//
//  Created by zengjing on 14-9-27.
//  Copyright (c) 2014年 曾静 www.devzeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^PrepareExecuteBlock)(void);

typedef void (^DZDataModelRequestSuccess)(NSURLSessionDataTask *task, id responseObject);

typedef void (^DZDataModelRequestFailure)(NSURLSessionDataTask *task, NSError *error);

typedef NS_ENUM(NSInteger, DZHttpRequestMethod) {
    DZHttpRequestGet,
    DZHttpRequestPost,
    DZHttpRequestDelete,
    DZHttpRequestPut
};

@interface DZDataModel : NSObject

- (void)requestWithURL:(NSString *)url
                 method:(DZHttpRequestMethod)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock)prepare
                success:(DZDataModelRequestSuccess)success
                failure:(DZDataModelRequestFailure)failure;

- (void)cancelRequest;

@end
