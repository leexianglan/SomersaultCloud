//
//  ConfirmOrderController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "ConfirmOrderController.h"
#import "ConfirmOrderTableCell.h"
#import "ConfirmOrderSelectCell.h"
#import "PayStateController.h"

@interface ConfirmOrderController ()

@property(nonatomic, strong)NSMutableArray *preferArr;
@property(nonatomic,assign)BOOL showPrefer;
@property(nonatomic, assign)NSInteger selectPayType;
@property(nonatomic, assign)NSInteger selectRow;
@property (weak, nonatomic) IBOutlet UIView *bigBaseView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ConfirmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"确认订单";
    self.selectPayType = 0;
    [[LXViewControllerManager shareManager] fixFontWithView:self.bigBaseView];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    禁止左滑手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)reloadTableview{
    self.showPrefer = YES;
    [self.btn setTitle:[NSString stringWithFormat:@"%@元，确认付款", self.bADitem.realAmount] forState:UIControlStateNormal];
    [self.pDataBase addObject:@[@{@"title":@"车牌号:",@"detail":self.carNo}, @{@"title":@"手机号:",@"detail":@"未实现"}]];
    [self.pDataBase addObject:@[@{@"title":@"油品种类:",@"detail":self.bADitem.oilType}, @{@"title":@"加油金额:",@"detail":[NSString stringWithFormat:@"%.f", [self.bADitem.realAmount floatValue] + [self.bADitem.discountMoney floatValue]]},@{@"title":@"优惠金额:",@"detail":self.bADitem.discountMoney},@{@"title":@"待付金额:",@"detail":self.bADitem.realAmount} ]];
    [self.pDataBase addObject:@[@{@"title":@"微信支付",@"img":@"fukuan_icon_weixin"}, @{@"title":@"支付宝支付",@"img":@"ali_pay"}]];
    
    [self.preferArr addObject:@{@"title":@". 平台优惠",@"detail":[NSString stringWithFormat:@"￥%@", self.bADitem.discountMoney]}];
//    [self.preferArr addObject:@{@"title":@". 优惠券",@"detail":@"￥10"}];
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"ConfirmOrderTableCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderTableCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"ConfirmOrderSelectCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderSelectCell"];
    self.selectRow = 2;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.pDataBase.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.pDataBase[section];
    if (self.showPrefer && section == 1) {
        return arr.count + self.preferArr.count;
    }
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSArray *arr = self.pDataBase[section];
    NSDictionary *dic = @{};
    if (section == 2) {
        dic = arr[row];
        __weak ConfirmOrderController *weakSelf = self;
        ConfirmOrderSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderSelectCell"];
        [cell resetSelf];
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
    if (!self.showPrefer) {
        dic = arr[row];
    }else{
        if (row >self.selectRow) {
            if (row - self.selectRow -1 < self.preferArr.count) {
                dic = self.preferArr[row - self.selectRow -1];
                cell.titleLbl.textColor = kRedColor;
                cell.titleLbl.font = [UIFont systemFontOfSize:11*kEqualHeight];
                cell.detailLbl.font = [UIFont systemFontOfSize:11*kEqualHeight];
            }else{
                dic = arr[3];
            }
        }else{
            dic = arr[row];
        }
    }
    if (section == 0) {
        cell.detailLbl.font = [UIFont systemFontOfSize:14*kEqualHeight];
        cell.detailLbl.textColor = k_3_Color;
    }
    if (section == 1 && row >1) {
        cell.detailLbl.textColor = kRedColor;
    }
    cell.titleLbl.text = dic[@"title"];
    cell.detailLbl.text = dic[@"detail"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    if (section == 1 && row == self.selectRow) {
//        self.showPrefer = !self.showPrefer;
//        [self.pTableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 10;
    if (section == 0) {
        height = 30;
    }else if (section ==2){
        height = 54;
    }
    
    return height*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*kEqualHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 0 || section == 2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth-30, 30*kEqualHeight)];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = section==0?kRedColor:k_3_Color;
        label.text = section == 0?@"为了不必要的错误，请核实您所填写的信息！":@"   支付方式：";
        label.font = section == 0?[UIFont systemFontOfSize:12*kEqualHeight]:[UIFont fontWithName:@"PingFangSC-Medium" size:14*kEqualHeight];
        label.backgroundColor = section == 0?[UIColor clearColor]:[UIColor whiteColor];
        if (section == 2) {
            label.frame = CGRectMake(0, 10, kDeviceWidth, 44*kEqualHeight);
        }
        [view addSubview:label];
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


/**
 选择付款方式

 @param index <#index description#>
 */
-(void)selectPayTypeWithIndex:(NSInteger)index{
    self.selectPayType = index;
    [self.pTableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
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

/**
 提交数据 到聚合支付

 */
- (IBAction)confirmBtnAction:(UIButton *)sender {
    [self.requestDic removeAllObjects];
    [self.requestDic setObject:[LXUserDefault openid] forKey:@"openId"];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [self.requestDic setObject:self.orderid forKey:@"oilOrderId"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%.0f", [self.bADitem.realAmount floatValue]*100] forKey:@"realAmount"];
    [self.requestDic setObject:self.bADitem.oilType forKey:@"oilName"];
    
    [[LXViewControllerManager shareManager] aggregatePay:@"order/payOrder" bodyparam:self.requestDic];
    

    
//    [self pushToPayStateController];
}


/**
 支付状态显示
 */
-(void)pushToPayStateController{
    PayStateController *ctr = [[PayStateController alloc] init];
    ctr.success = self.selectPayType == 0;
    ctr.orderid = self.orderid;
    [self.navigationController pushViewController:ctr animated:YES];
}

-(void)goBack:(id)sender{
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [[LXViewControllerManager shareManager] showAlertView:nil message:@"订单未完成，确认退出吗" actions:@[sureAction, cancleAction]];
}

@end
