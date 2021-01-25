//
//  ArrayTableViewDataSource.h
//  HYWCommonLib
//
//  Created by reyzhang on 15/12/7.
//  Copyright © 2015年 hhkx002. All rights reserved.
//  对 UITableView数据源代理的封装 reyzhang

/*
 @code 
 void (^configureCell)(PhotoCell*, Photo*) = ^(PhotoCell* cell, Photo* photo) {
 cell.label.text = photo.name;
 };
 
 photosArrayDataSource = [[ArrayTableViewDataSource alloc] initWithItems:photos
 cellIdentifier:PhotoCellIdentifier
 configureCellBlock:configureCell];
 
 self.tableView.dataSource = photosArrayDataSource; /////指明数据源的代码为 ArrayTableViewDataSource
 [self.tableView registerNib:[PhotoCell nib] forCellIdentifier:PhotoCellIdentifier];
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^TableViewCellConfigureBlock)(UITableViewCell  *cell, id item);

@interface ArrayTableViewDataSource : NSObject <UITableViewDataSource>

///传递数据源，cell复用identifier, 配置cell的回调
- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

///根据index 取数据中的某一个元素
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
