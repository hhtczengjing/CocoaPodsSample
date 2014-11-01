//
//  BaseViewController.h
//  DevZeng
//
//  Created by zengjing on 14-9-27.
//  Copyright (c) 2014年 曾静 www.devzeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZDataModel.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BaseViewController : UIViewController

@property (nonatomic, readonly, strong) DZDataModel *dataModel;

@end
