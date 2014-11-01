//
//  ArchivesViewController.m
//  DevZeng
//
//  Created by zengjing on 14-9-27.
//  Copyright (c) 2014年 曾静 www.devzeng.com. All rights reserved.
//

#import "ArchivesViewController.h"
#import "DZBlogArticle.h"
#import "ArticlePreviewViewController.h"

@interface ArchivesViewController ()<UITableViewDataSource, UITableViewDelegate,NSXMLParserDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) DZBlogArticle *currentData;
@property (nonatomic, strong) NSMutableString *currentText;
@property (nonatomic, strong) NSString *currentNode;

@end

@implementation ArchivesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Archives";
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ssXX"];
    
    [self.dataModel requestWithURL:@"http://blog.devzeng.com/atom.xml"
                            method:DZHttpRequestGet
                        parameters:nil
                    prepareExecute:^{
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    }
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseObject];
                               parser.delegate = self;
                               [parser parse];
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                               NSLog(@"%@", error);
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }
    ];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark xmlparser

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.listArray = [[NSMutableArray alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"entry"])
    {
        self.currentData = [DZBlogArticle new];
        self.currentNode = elementName;
    }
    else if (self.currentData && [elementName isEqualToString:@"title"])
    {
        self.currentNode = elementName;
        self.currentText = [[NSMutableString alloc] init];
    }
    else if (self.currentData && [elementName isEqualToString:@"link"])
    {
        self.currentNode = elementName;
        self.currentText = [[NSMutableString alloc] initWithFormat:@"%@", [attributeDict objectForKey:@"href"]];
    }
    else if (self.currentData && [elementName isEqualToString:@"updated"])
    {
        self.currentNode = elementName;
        self.currentText = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.currentText appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"entry"])
    {
        [self.listArray addObject:self.currentData];
        self.currentData = nil;
        self.currentNode = nil;
    }
    else if ([self.currentNode isEqualToString:@"title"])
    {
        self.currentData.title = self.currentText;
        self.currentText = nil;
        self.currentNode = nil;
    }
    else if ([self.currentNode isEqualToString:@"link"])
    {
        self.currentData.link = self.currentText;
        self.currentText = nil;
        self.currentNode = nil;
    }
    else if ([self.currentNode isEqualToString:@"updated"])
    {
        NSString *str = [self.currentText substringToIndex:16];
        NSString *s1 = [str substringToIndex:10];
        NSString *s2 = [str substringWithRange:NSMakeRange(11, 5)];
        self.currentData.updated = [NSString stringWithFormat:@"%@ %@", s1, s2];
        self.currentText = nil;
        self.currentNode = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.listTableView reloadData];
}

//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    if([self.currentNode isEqualToString:@"title"])
    {
        [self.currentText appendFormat:@"%@", [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    DZBlogArticle *model = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    NSString *detailText = [NSString stringWithFormat:@"作者：曾静        发布时间：%@", model.updated];
    cell.detailTextLabel.text = detailText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticlePreviewViewController *detail = [[ArticlePreviewViewController alloc] init];
    DZBlogArticle *model = [self.listArray objectAtIndex:indexPath.row];
    detail.link = model.link;
    //detail.title = model.title;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
