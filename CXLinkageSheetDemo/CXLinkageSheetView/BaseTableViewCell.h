//
//  BaseTableViewCell.h
//  SportsSpeedTest
//
//  Created by Felix on 2018/7/4.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, weak) UITableView * _Nullable tableView;
@property (nonatomic, strong) NSIndexPath * _Nullable indexPath;

///创建自定义cell
+ (instancetype _Nullable)createCellWithTableView:(UITableView *_Nullable)tableView;

///添加控件
- (void)setupUI;

///修改cell属性
- (void)setupCellStyle;

@end
