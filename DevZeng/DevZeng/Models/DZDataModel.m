//
//  DZDataModel.m
//  DevZeng
//
//  Created by zengjing on 14-9-27.
//  Copyright (c) 2014年 曾静 www.devzeng.com. All rights reserved.
//

#import "DZDataModel.h"

@interface DZDataModel()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation DZDataModel

- (id)init
{
    if (self = [super init])
    {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (void)requestWithURL:(NSString *)url
                method:(DZHttpRequestMethod)method
            parameters:(id)parameters
        prepareExecute:(PrepareExecuteBlock)prepare
               success:(DZDataModelRequestSuccess)success
               failure:(DZDataModelRequestFailure)failure
{
    //请求网络前的预加载操作，如添加指示器等
    if (prepare)
    {
        prepare();
    }
    switch (method)
    {
        case DZHttpRequestGet:
            self.dataTask = [self.manager GET:url parameters:parameters success:success failure:failure];
            break;
        case DZHttpRequestPost:
            self.dataTask = [self.manager POST:url parameters:parameters success:success failure:failure];
            break;
        case DZHttpRequestDelete:
            self.dataTask = [self.manager DELETE:url parameters:parameters success:success failure:failure];
            break;
        case DZHttpRequestPut:
            self.dataTask = [self.manager PUT:url parameters:parameters success:success failure:false];
            break;
        default:
            break;
    }
}

- (void)cancelRequest
{
    if(self.dataTask)
    {
        [self.dataTask cancel];
    }
}

@end
