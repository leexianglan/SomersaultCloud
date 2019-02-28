//
//  PetOrderController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/26.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PetOrderController.h"
#import "PetOrderItem.h"
#import "PetOrderCell.h"
#import "OrderSuccessController.h"
#import "OrderUnPayController.h"
#import "OrderCompleteController.h"

@interface PetOrderController ()

@end

@implementation PetOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的订单";
    [[LXViewControllerManager shareManager] showHUDOnly];
    [self loadData];
}


-(void)loadData{
    [super loadData];
    [self.requestDic removeAllObjects];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%d", self.page] forKey:@"page"];
    
    [LXNetWork getDataWithParm:self.requestDic url:@"user/myOrders" successBlock:^(NSDictionary *dic) {
        [self.pTableView.mj_header endRefreshing];
        [self.pTableView.mj_footer endRefreshing];
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] == 200) {
            NSArray *arr = dic[@"data"];
            if (self.page == 1) {
                [self.pDataBase removeAllObjects];
            }
            self.page++;
            for (NSDictionary *arrD in arr) {
                PetOrderItem *item = [PetOrderItem mj_objectWithKeyValues:arrD];
                if ([item.isPrint intValue] == 2) {
                    item.payStatus = [NSString stringWithFormat:@"%ld", completeState];
                }
                item.realAmount = [[LXViewControllerManager shareManager] divided100:item.realAmount];
                item.oilAmount = [[LXViewControllerManager shareManager] divided100:item.oilAmount];
                item.goldBean = [NSString stringWithFormat:@"%d", [item.goldBean intValue]/100];
                [self.pDataBase addObject:item];
            }
            if (self.pDataBase.count > 0) {
                [[LXViewControllerManager shareManager] removeEmptyView:self];
                if (arr.count>0) {
                    [self.pTableView reloadData];
                }
            }else{
                [[LXViewControllerManager shareManager] addEmptyView:self frame:CGRectZero title:nil font:0 img:nil bgColor:nil];
            }
        }
    } errorBlock:^(NSError *error) {
        [self.pTableView.mj_header endRefreshing];
        [self.pTableView.mj_footer endRefreshing];
        [[LXViewControllerManager shareManager] hideHUD];
    }];
    
}

-(void)reloadTableview{
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"PetOrderCell" bundle:nil] forCellReuseIdentifier:@"PetOrderCell"];
    [self headerRefresh];
    [self footerRefresh];
}

-(void)loadNewData{
    [super loadNewData];
    [self loadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    return self.pDataBase.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pDataBase.count;
    NSArray *arr = self.pDataBase[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
//    NSArray *arr = self.pDataBase[section];
//    NSString *str = arr[row];
    PetOrderItem *item = self.pDataBase[row];
    __weak PetOrderController *weakSelf = self;
    PetOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PetOrderCell"];
    cell.block = ^(NSInteger lxtag, NSInteger tag) {
        [weakSelf btnActionWithLxTag:lxtag tag:tag];
    };
    [cell setModel:item tag:row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PetOrderItem *item = self.pDataBase[indexPath.row];
    if ([item.payStatus intValue] == waitPayState || [item.payStatus intValue] == payFailedState) {
        [self pushToOrderUnPayController:indexPath.row];
    }else if ([item.payStatus intValue] == paySuccessState){
        [self pushToOrderSuccessController:indexPath.row];
    }else if([item.payStatus intValue] == completeState){
        [self pushToOrderCompleteController:indexPath.row];
    }
}


/**
 不同状态订单按钮事件实现

 @param lxTag 订单状态码
 @param tag 选中的订单
 */
-(void)btnActionWithLxTag:(NSInteger)lxTag tag:(NSInteger)tag{
    if (lxTag == waitPayState || lxTag == payFailedState) {
//        待支付
        [self pushToOrderUnPayController:tag];
//        [self aggregatePay:tag];
    }else if (lxTag == paySuccessState){
        // 待取票
        [self pushToOrderSuccessController:tag];
    }else if(lxTag == completeState){
        [self pushToOrderCompleteController:tag];
    }
}


/**
 聚合支付
 */
-(void)aggregatePay:(NSInteger)tag{
    PetOrderItem *item = self.pDataBase[tag];
    [self.requestDic removeAllObjects];
    [self.requestDic setObject:[LXUserDefault openid] forKey:@"openId"];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [self.requestDic setObject:item.oilOrderId forKey:@"oilOrderId"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%.0f", [item.realAmount floatValue]*100] forKey:@"realAmount"];
    [self.requestDic setObject:item.oilName forKey:@"oilName"];
    [[LXViewControllerManager shareManager] aggregatePay:@"order/payOrder" bodyparam:self.requestDic];
}

/**
 付款成功

 @param tag 订单列表位置
 */
-(void)pushToOrderSuccessController:(NSInteger)tag{
    PetOrderItem *item = self.pDataBase[tag];
    OrderSuccessController *ctr = [[OrderSuccessController alloc] init];
    ctr.orderid = item.oilOrderId;
    [self.navigationController pushViewController:ctr animated:YES];
}

/**
 付款失败

 @param tag <#tag description#>
 */
-(void)pushToOrderUnPayController:(NSInteger)tag{
    PetOrderItem *item = self.pDataBase[tag];
    OrderUnPayController *ctr = [[OrderUnPayController alloc] init];
    ctr.orderid = item.oilOrderId;
    [self.navigationController pushViewController:ctr animated:YES];
}

/**
 完成的订单

 @param tag 列表中的位置
 */
-(void)pushToOrderCompleteController:(NSInteger)tag{
    OrderCompleteController *ctr = [[OrderCompleteController alloc] init];
    ctr.item = self.pDataBase[tag];
    [self.navigationController pushViewController:ctr animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self deleteStation:indexPath.row];
}

/**
 删除某个订单

 @param index 位置
 */
-(void)deleteStation:(NSInteger)index{
    PetOrderItem *item = self.pDataBase[index];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault   handler:^(UIAlertAction * _Nonnull action) {
        [[LXViewControllerManager shareManager] showHUDOnly];
        [LXNetWork postDataWithParm:@{@"oilOrderId":item.oilOrderId} url:@"user/deleteMyOrder" successBlock:^(NSDictionary *dic) {
            [[LXViewControllerManager shareManager] hideHUD];
            if ([dic[@"status"] intValue] == 200) {
                [self.pDataBase removeObjectAtIndex:index];
                [self.pTableView reloadData];
                if (self.pDataBase.count == 0) {
                    [[LXViewControllerManager shareManager] addEmptyView:self frame:CGRectZero title:nil font:0 img:nil bgColor:nil];
                }
            }
        } errorBlock:^(NSError *error) {
            [[LXViewControllerManager shareManager] hideHUD];
        }];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [[LXViewControllerManager shareManager] showAlertView:nil message:@"是否确认删除" actions:@[sureAction, cancleAction]];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


@end
