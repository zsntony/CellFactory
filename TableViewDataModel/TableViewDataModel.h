//
//  TableViewDataModel.h
//  TailTravel
//
//  Created by Tony on 16/7/19.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property (nonatomic,copy) CGFloat (^CellHeight)(UITableView *tableView,NSIndexPath* indexPath);
@property (nonatomic,copy) UITableViewCell* (^Cell)(UITableView *tableView,NSIndexPath* indexPath);
@property (nonatomic,copy) void (^SelectRow)(UITableView *tableView,NSIndexPath* indexPath);

@property (nonatomic,assign) BOOL autoHeight;//自适应高度开启

@end

@interface TableViewSectionModel : NSObject

@property (nonatomic,copy) UIView* (^viewForHeaderInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) CGFloat (^heightForHeaderInSection)(UITableView *tableView,NSInteger section);


@property (nonatomic,strong) NSMutableArray <CellModel*> *cellModelsArr;

@end

@interface TableViewDataModel : NSObject

@property (nonatomic,strong) NSMutableArray <TableViewSectionModel*> *tableViewDataArr;
@property (nonatomic,weak,readonly) UITableView *tableView;
@property (nonatomic,copy) NSArray* (^sectionIndexTitlesForTableView)(UITableView *tableView);
@property (nonatomic,copy) NSInteger (^sectionForSectionIndexTitle)(UITableView *tableView,NSString *title,NSInteger index);

-(void)targetTableView:(UITableView*)tableview;
@end
