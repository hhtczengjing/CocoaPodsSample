//
//  BaseViewController.m
//  DevZeng
//
//  Created by zengjing on 14-9-27.
//  Copyright (c) 2014年 曾静 www.devzeng.com. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) DZDataModel *dataModel;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.dataModel)
    {
        [self.dataModel cancelRequest];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DZDataModel *)dataModel
{
    if (nil == _dataModel)
    {
        _dataModel = [[DZDataModel alloc] init];
    }
    return _dataModel;
}

@end
