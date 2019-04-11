//
//  CellModel+SpaceCell.m
//  SpringTour
//
//  Created by Tony on 15/12/23.
//  Copyright © 2015年 SpringTour. All rights reserved.
//

#import "CellModel+SpecialAcion.h"

@implementation CellModel (SpecialAcion)



+(CellModel*)SpaceCelltoTableViewWithspearator:(UIEdgeInsets)insets height:(CGFloat)height{
    CellModel *spaceCellModel=[[CellModel alloc]init];
    
    spaceCellModel.CellHeight=^CGFloat(UITableView *tableView,NSIndexPath* indexPath){
        
        return height;
        
    };
    spaceCellModel.Cell=^UITableViewCell*(UITableView *tableView,NSIndexPath* indexPath){ //top:上面是否有线条，bottom：下面是否有线条
        
        static NSString *identifier = @"SpaceCellWithspearator";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = insets;
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:insets];
        }


        
        return cell;
        
    };
    
    return spaceCellModel;
}

+(CellModel*)SpaceCelltoTableViewWithspearator:(UIEdgeInsets)insets height:(CGFloat)height color:(UIColor *)color{
    CellModel *spaceCellModel=[[CellModel alloc]init];
    
    spaceCellModel.CellHeight=^CGFloat(UITableView *tableView,NSIndexPath* indexPath){
        
        return height;
        
    };
    spaceCellModel.Cell=^UITableViewCell*(UITableView *tableView,NSIndexPath* indexPath){ //top:上面是否有线条，bottom：下面是否有线条
        
        static NSString *identifier = @"SpaceCellWithspearator";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor=color;
        cell.contentView.backgroundColor=color;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = insets;
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:insets];
        }
        
        
        
        return cell;
        
    };
    
    return spaceCellModel;
}

+(void)setTableViewCellspearator:(UIEdgeInsets)insets cell:(UITableViewCell*)cell{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:insets];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:insets];
        
    }
}


@end
