//
//  CustomLinkageSheetController.m
//  CXLinkageSheetDemo
//
//  Created by Felix on 2018/9/6.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import "CustomLinkageSheetController.h"
#import "CXLinkageSheetView.h"
#import "CarModel.h"
#import "ConfigSectionHeaderView.h"
#import <YYModel.h>

#define CXScreenW [UIScreen mainScreen].bounds.size.width
#define CXScreenH [UIScreen mainScreen].bounds.size.height

#define iphoneX (CXScreenH == 812.0f)
#define kBottomHeight (iphoneX ? -34 : 0)
#define kStatusBarHeight (iphoneX ? 44 : 20)
#define kNavBarHeight 44.0
#define kTabBarHeight (iphoneX ? 83 : 49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define RGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define LightGrayColor  RGBA(242, 241, 239, 1)
#define DarkGrayColor   RGBA(119, 119, 119, 1)

@interface CustomLinkageSheetController ()<CXLinkageSheetViewDataSource>

@property (nonatomic, strong) CXLinkageSheetView *linkageSheetView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) CarModel *firstCarModel;
@property (nonatomic, strong) GroupParamsModel *firstGroupParamsModel;

@end

@implementation CustomLinkageSheetController

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].copy;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    
    self.linkageSheetView = [[CXLinkageSheetView alloc]initWithFrame:CGRectMake(0, kTopHeight, CXScreenW, CXScreenH - kTopHeight)];
    _linkageSheetView.dataSource = self;
    _linkageSheetView.sheetHeaderHeight = 60;
    _linkageSheetView.sheetRowHeight = 50;
    _linkageSheetView.sheetLeftTableWidth = CXScreenW / 4;
    _linkageSheetView.sheetRightTableWidth = CXScreenW / 4;
    _linkageSheetView.showAllSheetBorder = YES;
    _linkageSheetView.pagingEnabled = YES;
    _linkageSheetView.dataSource = self;
    _linkageSheetView.outLineColor = LightGrayColor;
    _linkageSheetView.outLineWidth = 0.5f;
    _linkageSheetView.innerLineColor = LightGrayColor;
    _linkageSheetView.innerLineWidth = 1.0f;
    [self.view addSubview:_linkageSheetView];
    
}

- (void)loadData {
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"custom_data" ofType:@"json"]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    self.dataArray = [NSArray yy_modelArrayWithClass:[CarModel class] json:dict[@"data"]].mutableCopy;
    self.firstCarModel = self.dataArray.firstObject;
    self.firstGroupParamsModel = _firstCarModel.groupParamsViewModelList.firstObject;
    
    self.linkageSheetView.rightTableCount = self.dataArray.count;
    [self.linkageSheetView reloadData];    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CXScreenW, 30)];
//    sectionHeader.backgroundColor = LightGrayColor;
//    return sectionHeader;
    
    ConfigSectionHeaderView *sectionHeader = [ConfigSectionHeaderView creatView];
    GroupParamsModel *groupParamsModel = _firstCarModel.groupParamsViewModelList[section];
    sectionHeader.titleLabel.text = groupParamsModel.groupName;
    
    return sectionHeader;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)leftTableView {
    
    return self.firstCarModel.groupParamsViewModelList.count;
    
}

- (NSInteger)tableView:(UITableView *)leftTableView numberOfRowsInSection:(NSInteger)section {
    GroupParamsModel *groupParamsModel = self.firstCarModel.groupParamsViewModelList[section];
    
    return groupParamsModel.paramList.count;
}

- (UIView *)createLeftItemWithContentView:(UIView *)contentView indexPath:(NSIndexPath *)indexPath {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, contentView.bounds.size.width - 20, contentView.bounds.size.height)];
  
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.textColor = DarkGrayColor;
    
    GroupParamsModel *groupParamsModel = self.firstCarModel.groupParamsViewModelList[indexPath.section];
    ParamlistModel *paramlistModel = groupParamsModel.paramList[indexPath.row];
    label.text = paramlistModel.paramName;
    
    return label;
}

- (UIView *)createRightItemWithContentView:(UIView *)contentView indexPath:(NSIndexPath *)indexPath itemIndex:(NSInteger)itemIndex {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, contentView.bounds.size.width - 20, contentView.bounds.size.height)];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = DarkGrayColor;
    
    CarModel *carModel = self.dataArray[itemIndex];
    GroupParamsModel *groupParamsModel = carModel.groupParamsViewModelList[indexPath.section];
    ParamlistModel *paramlistModel = groupParamsModel.paramList[indexPath.row];
    
    label.text = paramlistModel.paramValue;
    
    return label;
}

- (UIView *)leftTitleView:(UIView *)titleContentView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleContentView.bounds.size.width, titleContentView.bounds.size.height)];
    label.text = @"配置项";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = DarkGrayColor;
    return label;
}

- (UIView *)rightTitleView:(UIView *)titleContentView index:(NSInteger)index {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, titleContentView.bounds.size.width - 20, titleContentView.bounds.size.height)];
    CarModel *carModel = self.dataArray[index];
    label.text = carModel.specName;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    return label;
    
}


@end