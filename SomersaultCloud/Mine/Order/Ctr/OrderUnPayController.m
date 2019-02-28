//
//  OrderUnPayController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "OrderUnPayController.h"
#import "ConfirmOrderTableCell.h"
#import "ConfirmOrderSelectCell.h"
#import "PayStateController.h"
#import "PetOrderItem.h"

@interface OrderUnPayController ()

@property(nonatomic, strong)NSMutableArray *preferArr;
@property(nonatomic,assign)BOOL showPrefer;
@property(nonatomic, assign)NSInteger selectPayType;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property(nonatomic, strong)PetOrderItem *item;

@end

@implementation OrderUnPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"订单未完成";
    [[LXViewControllerManager shareManager] fixFontWithView:self.payBtn];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
}

/**
 通过orderid拿数据
 */
-(void)loadData{
    [self.requestDic setObject:self.orderid forKey:@"orderId"];
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork getDataWithParm:self.requestDic url:@"order/getOrderById" successBlock:^(NSDictionary *dic) {
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] ==200) {
            NSDictionary *data = dic[@"data"];
            self.item = [PetOrderItem mj_objectWithKeyValues:data];
            self.item.realAmount = [[LXViewControllerManager shareManager] divided100:self.item.realAmount];
            self.item.oilAmount = [[LXViewControllerManager shareManager] divided100:self.item.oilAmount];
            [self reloadData];
            [self.pTableView reloadData];
        }
    } errorBlock:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    }];
}

-(void)reloadTableview{
    [self reloadData];
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"ConfirmOrderTableCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderTableCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"ConfirmOrderSelectCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderSelectCell"];
}

-(void)reloadData{
    [self.pDataBase removeAllObjects];
    [self.pDataBase addObject:@[@{@"title":@"车牌号:",@"detail":[self getUnEmptyText:self.item.carId]}, @{@"title":@"油品种类:",@"detail":[self getUnEmptyText:self.item.oilName]}, @{@"title":@"加油金额:",@"detail":[self getUnEmptyText:self.item.oilAmount]},@{@"title":@"需支付金额:",@"detail":[self getUnEmptyText:self.item.realAmount]},@{@"title":@"优惠金额:",@"detail":[self getUnEmptyText:self.item.oilDensity]},@{@"title":@"收款方:",@"detail":[self getUnEmptyText:self.item.payee]} ,@{@"title":@"订单失效时间:",@"detail":@"2018.3.14.16:03-2018.3.14.18:07"}]];
    [self.pDataBase addObject:@[@{@"title":@"微信支付",@"img":@"fukuan_icon_weixin"}, @{@"title":@"支付宝支付",@"img":@"ali_pay"}]];
    
    [self.preferArr addObject:@{@"title":@". 平台优惠",@"detail":@"￥10"}];
    [self.preferArr addObject:@{@"title":@". 优惠券",@"detail":@"￥10"}];
}

-(NSString *)getUnEmptyText:(NSString *)text{
    return text?text:@"";
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.pDataBase.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.pDataBase[section];
    if (self.showPrefer && section == 0) {
        return arr.count + self.preferArr.count;
    }
    return arr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSArray *arr = self.pDataBase[section];
    NSDictionary *dic = @{};
    if (section == 1) {
        dic = arr[row];
        __weak OrderUnPayController *weakSelf = self;
        ConfirmOrderSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderSelectCell"];
        [cell resetSelf];
        cell.line.hidden = NO;
        cell.block = ^(NSInteger tag) {
            [weakSelf selectPayTypeWithIndex:tag];
        };
        cell.lbl.text = dic[@"title"];
        cell.imgView.image = [UIImage imageNamed:dic[@"img"]];
        cell.btn.tag = row;
        cell.btn.selected = row == self.selectPayType;
        return cell;
    }
    ConfirmOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderTableCell"];
    [cell resetSelf];
    cell.titleLbl.textColor = k_6_Color;
    cell.titleLbl.font = [UIFont systemFontOfSize:12*kEqualHeight];
    cell.detailLbl.font = [UIFont systemFontOfSize:14*kEqualHeight];
    cell.detailLbl.textColor = k_3_Color;
    if (!self.showPrefer) {
        dic = arr[row];
    }else{
        if (row >4) {
            if (row - 5 < self.preferArr.count) {
                dic = self.preferArr[row - 5];
                cell.titleLbl.textColor = kRedColor;
                cell.detailLbl.textColor = kRedColor;
                cell.titleLbl.font = [UIFont systemFontOfSize:11*kEqualHeight];
                cell.detailLbl.font = [UIFont systemFontOfSize:11*kEqualHeight];
            }else{
                dic = arr[row - self.preferArr.count];
            }
        }else{
            dic = arr[row];
        }
    }
    if (section == 0 && row == 4) {
        cell.detailLbl.textColor = kRedColor;
        cell.titleLbl.textColor = kRedColor;
    }
    cell.titleLbl.text = dic[@"title"];
    cell.detailLbl.text = dic[@"detail"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    if (section == 0 && row == 4) {
//        self.showPrefer = !self.showPrefer;
//        [self.pTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else if (section ==1){
        return 54;
    }
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 0) {
        return 30*kEqualHeight;
    }
    return 45*kEqualHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 44)];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = section==0?kRedColor:k_3_Color;
        label.text = @"   支付方式：";
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14*kEqualHeight];
        label.backgroundColor = [UIColor whiteColor];
        [view addSubview:label];
        LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, 53, kDeviceWidth, 0.5)];
        [view addSubview:line];
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


-(void)selectPayTypeWithIndex:(NSInteger)index{
    self.selectPayType = index;
    [self.pTableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSMutableArray *)preferArr{
    if (!_preferArr) {
        self.preferArr = [NSMutableArray array];
    }
    return _preferArr;
}


- (IBAction)payAction:(id)sender {
    [self.requestDic removeAllObjects];
    [self.requestDic setObject:[LXUserDefault openid] forKey:@"openId"];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [self.requestDic setObject:self.orderid forKey:@"oilOrderId"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%.0f", [self.item.realAmount floatValue]*100] forKey:@"realAmount"];
    [self.requestDic setObject:self.item.oilName forKey:@"oilName"];
    
    [[LXViewControllerManager shareManager] aggregatePay:@"order/payOrder" bodyparam:self.requestDic];
//    return;
//
//    [LXNetWork nativePost:@"order/payOrder" bodyparam:self.requestDic success:^(NSDictionary *dic) {
//        if ([dic[@"status"] intValue] == 200) {
//            NSLog(@"%@", dic);
//        }
//    } faile:^(NSError *error) {
//
//    } contentType:nil];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
