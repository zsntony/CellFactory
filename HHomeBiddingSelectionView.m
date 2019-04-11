//
//  HHomeBiddingSelectionView.m
//  HaiRY
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 LeZhuan. All rights reserved.
//

#import "HHomeBiddingSelectionView.h"
#import "TableViewDataModel.h"
#import "CellModel+SpecialAcion.h"
#import "HSmartInvestmentScene.h"
#import "HBankDepositoryRequestRouter.h"
#import "HBDOpenResultScene.h"

@interface HHomeBiddingSelectionView ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) TableViewDataModel *tableViewDataModel;

@property (strong, nonatomic) IBOutlet UITableViewCell *settingCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pauseCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *closeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *cancelCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *resumeCell;


@end

@implementation HHomeBiddingSelectionView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HHomeBiddingSelectionView" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[HHomeBiddingSelectionView class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        self.frame=frame;
        
        [self initDatas];
        [self initViews];
        [self addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [self setCells];
    }
    return self;
}

-(void)initDatas{
    
    self.tableViewDataModel=[[TableViewDataModel alloc]init];
    [self.tableViewDataModel targetTableView:self.tableView];
}

-(void)initViews{
    //设置tableview每行cell线的一个最大范围
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

//默认的第一个Section
-(TableViewSectionModel*)getSectionModel{
    TableViewSectionModel *sectionModel=[self.tableViewDataModel.tableViewDataArr firstObject];
    if (sectionModel==nil) {
        sectionModel=[[TableViewSectionModel alloc] init];
        [self.tableViewDataModel.tableViewDataArr addObject:sectionModel];
    }
    return sectionModel;
}

-(void)setCells{

    
    TableViewSectionModel *sectionModel=[self getSectionModel];
    
    [sectionModel.cellModelsArr removeAllObjects];

    [self setSettingCell];
    if ([self.detailModel.status isEqualToString:@"1"]) {//暂停
        [self setResumeCell];
    }
    else if ([self.detailModel.status isEqualToString:@"0"]){//已开通
        [self setPauseCell];
    }else{
        [self setResumeCell];
    }
    [self setCloseCell];
    [sectionModel.cellModelsArr addObject:[CellModel SpaceCelltoTableViewWithspearator:UIEdgeInsetsMake(0, APP_W, 0, 0) height:10 color:[UIColor colorWithHex:@"#F8F8F8"]]];
    [self setCell:self.cancelCell height:50];

    [self.tableView reloadData];
}

-(void)setSettingCell{
    
    __weak typeof(self) weakself=self;
    
    TableViewSectionModel *sectionModel=[self getSectionModel];
    
    CellModel *cellModel=[[CellModel alloc]init];
    
    cellModel.CellHeight=^CGFloat(UITableView *tableView,NSIndexPath* indexPath){
        return 76;
    };
    
    cellModel.Cell=^UITableViewCell*(UITableView *tableView,NSIndexPath* indexPath){
        return self.settingCell;
    };
    cellModel.SelectRow = ^(UITableView *tableView, NSIndexPath *indexPath) {
        
        HSmartInvestmentScene *SIScene = (HSmartInvestmentScene *)[UIStoryboard storyboardWithStoryboardName:kMyStoryboard className:NSStringFromClass([HSmartInvestmentScene class])];
        SIScene.type = HSmartInvestmentTypeUpdate;

        [[HBaseScene getCurrentScene].navigationController pushViewController:SIScene animated:YES];
        [weakself closeAction];
    };
    
    [sectionModel.cellModelsArr addObject:cellModel];
}

-(void)setPauseCell{
    TableViewSectionModel *sectionModel=[self getSectionModel];
    
    CellModel *cellModel=[[CellModel alloc]init];
    
    cellModel.CellHeight=^CGFloat(UITableView *tableView,NSIndexPath* indexPath){
        return 76;
    };
    __weak typeof(self) weakself=self;

    cellModel.Cell=^UITableViewCell*(UITableView *tableView,NSIndexPath* indexPath){
        return self.pauseCell;
    };
    cellModel.SelectRow = ^(UITableView *tableView, NSIndexPath *indexPath) {
        [weakself closeAction];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"是否暂停智能投标服务" message:@"暂停后将停止匹配，资金将会闲置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定暂停" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HSenderController PostWithUrlParam:URL_auto_bidding_update_status(@{@"action":@"suspend"}) fromPage:nil showLoad:YES showErrorMessage:NO success:^(NSString *message, id body) {
                weakself.updateAutoBiddingSuccessBlock ? weakself.updateAutoBiddingSuccessBlock(HHomeBiddingSelectionTypeSuspend) : nil;
                [weakself closeAction];
                [HStaticToast toastWithIcon:@"icon_white_success" tip:@"修改成功" cb:nil];
            } failure:^(NSError *error, NSInteger status, NSString *message, id body) {
                [HStaticToast toastWithIcon:@"icon_white_failure" tip:@"修改失败" cb:nil];
            }];
        }];
        [actionSheet addAction:cancelAction];
        [actionSheet addAction:actionOK];

        [[HBaseScene getCurrentScene] presentViewController:actionSheet animated:YES completion:nil];

    };
    
    [sectionModel.cellModelsArr addObject:cellModel];
}

-(void)setResumeCell{
    TableViewSectionModel *sectionModel=[self getSectionModel];
    
    CellModel *cellModel=[[CellModel alloc]init];
    
    cellModel.CellHeight=^CGFloat(UITableView *tableView,NSIndexPath* indexPath){
        return 76;
    };
    __weak typeof(self) weakself=self;
    
    cellModel.Cell=^UITableViewCell*(UITableView *tableView,NSIndexPath* indexPath){
        return self.resumeCell;
    };
    cellModel.SelectRow = ^(UITableView *tableView, NSIndexPath *indexPath) {
        [weakself closeAction];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"是否恢复智能投标服务" message:@"默认沿用您之前设置的匹配规则" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定恢复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HSenderController PostWithUrlParam:URL_auto_bidding_update_status(@{@"action":@"resume"}) fromPage:nil showLoad:YES showErrorMessage:NO success:^(NSString *message, id body) {
                weakself.updateAutoBiddingSuccessBlock ? weakself.updateAutoBiddingSuccessBlock(HHomeBiddingSelectionTypeSuspend) : nil;
                [weakself closeAction];
                [HStaticToast toastWithIcon:@"icon_white_success" tip:@"修改成功" cb:nil];
            } failure:^(NSError *error, NSInteger status, NSString *message, id body) {
                [HStaticToast toastWithIcon:@"icon_white_failure" tip:@"修改失败" cb:nil];
            }];
        }];
        [actionSheet addAction:cancelAction];
        [actionSheet addAction:actionOK];
        
        [[HBaseScene getCurrentScene] presentViewController:actionSheet animated:YES completion:nil];
        
    };
    
    [sectionModel.cellModelsArr addObject:cellModel];
}

-(void)setCloseCell{
    __weak typeof(self) weakself=self;

    TableViewSectionModel *sectionModel=[self getSectionModel];
    
    CellModel *cellModel=[[CellModel alloc]init];
    
    cellModel.CellHeight=^CGFloat(UITableView *tableView,NSIndexPath* indexPath){
        return 76;
    };
    
    cellModel.Cell=^UITableViewCell*(UITableView *tableView,NSIndexPath* indexPath){
        return self.closeCell;
    };
    cellModel.SelectRow = ^(UITableView *tableView, NSIndexPath *indexPath) {
        [weakself closeAction];
        HAlertView *alert = [[HAlertView alloc] initWithTitle:@"是否关闭智能投标服务" message:@"关闭后需要您手动抢标，当前设置将不再保存" alertStyle:UIAlertStyleAlert];
        [alert addCancelButtonTitle:@"取消" action:^{ }];
        [alert addBtnTitle:@"确定关闭" action:^{
            [HBankDepositoryRequestRouter passwdVerifyRequestWithScene:[HBaseScene getCurrentScene] bankDepositorytype:HBankDepositoryTypeZNTBClose callback:^(HResponseBankDepositoryModel *responseModel) {
                [HSenderController PostWithUrlParam:URL_auto_bidding_update_status(@{@"action":@"close"}) fromPage:nil showLoad:YES showErrorMessage:YES success:^(NSString *message, id body) {
                    [HBDOpenResultScene showResultType:HBankDepositoryTypeZNTBClose params:responseModel];
                    weakself.updateAutoBiddingSuccessBlock ? weakself.updateAutoBiddingSuccessBlock(HHomeBiddingSelectionTypeClose) : nil;
                } failure:^(NSError *error, NSInteger status, NSString *message, id body) {
                }];
            }];
        }];
        [alert show];
        
    };
    
    [sectionModel.cellModelsArr addObject:cellModel];
}

-(void)setCell:(UITableViewCell*)cell height:(float)height{
    TableViewSectionModel *sectionModel=[self getSectionModel];

    __weak typeof(self) weakself=self;
    CellModel *cellModel=[[CellModel alloc]init];

    cellModel.CellHeight=^CGFloat(UITableView *tableView,NSIndexPath* indexPath){
        return height;
    };

    cellModel.Cell=^UITableViewCell*(UITableView *tableView,NSIndexPath* indexPath){
        return cell;
    };
    cellModel.SelectRow = ^(UITableView *tableView, NSIndexPath *indexPath) {
        [weakself closeAction];
    };

    [sectionModel.cellModelsArr addObject:cellModel];
}

-(void)closeAction{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
