//
//  CellModel+SpaceCell.h
//  SpringTour
//
//  Created by Tony on 15/12/23.
//  Copyright © 2015年 SpringTour. All rights reserved.
//

#import "TableViewDataModel.h"

@interface CellModel (SpecialAcion)
+(CellModel*)SpaceCelltoTableViewWithspearator:(UIEdgeInsets)insets height:(CGFloat)height;
+(CellModel*)SpaceCelltoTableViewWithspearator:(UIEdgeInsets)insets height:(CGFloat)height color:(UIColor *)color;

+(void)setTableViewCellspearator:(UIEdgeInsets)insets cell:(UITableViewCell*)cell;

@end
