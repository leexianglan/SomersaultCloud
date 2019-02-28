//
//  EditOrderController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/30.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "EditOrderController.h"
#import "MakeOrderPetNumTableCell.h"
#import "MakeOrderMoneyCell.h"
#import "MakeOrderSelectCell.h"
#import "EditAddressCell.h"
#import "ConfirmOrderController.h"
#import "UseCousView.h"
#import "CouponsBaseController.h"
#import "StationItem.h"
#import "StationDetailItem.h"
#import "BeaAndDiscountMoneyItem.h"



@interface EditOrderController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *pPriceLbl;
@property(nonatomic, strong)NSString *money;

@property(nonatomic, assign)NSInteger selectPetTag;
@property(nonatomic, strong)NSString *carNo;
@property (weak, nonatomic) IBOutlet UIView *bigBaseView;
@property(nonatomic, strong)BeaAndDiscountMoneyItem *bADItem;




@end

@implementation EditOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"订单";
    // Do any additional setup after loading the view from its nib.
    [[LXViewControllerManager shareManager] fixFontWithView:self.bigBaseView];
    
}

-(void)reloadTableview{

    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MakeOrderPetNumTableCell" bundle:nil] forCellReuseIdentifier:@"MakeOrderPetNumTableCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MakeOrderMoneyCell" bundle:nil] forCellReuseIdentifier:@"MakeOrderMoneyCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MakeOrderSelectCell" bundle:nil] forCellReuseIdentifier:@"MakeOrderSelectCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"EditAddressCell" bundle:nil] forCellReuseIdentifier:@"EditAddressCell"];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    if (section == 1) {
        return 1 + self.pDataBase.count;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 1) {
        
        __weak EditOrderController *weakSelf = self;
        if (self.pDataBase.count > row) {
            NSArray *arr = self.pDataBase[row];
            MakeOrderPetNumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeOrderPetNumTableCell"];
            [cell resetSelf];
            cell.line.hidden = row != self.pDataBase.count-1;
            NSInteger min = MIN(arr.count, 3);
            for (int i = 0; i < min; i++) {
                
                LXItem *lItem = arr[i];
                NSString *text = nil;
                if ([lItem isKindOfClass:[OilPriceItem class]]) {
                    OilPriceItem *item = (OilPriceItem *)lItem;
                    text = item.oilType;
                }else if ([lItem isKindOfClass:[OilTypeItem class]]){
                    OilTypeItem *item = (OilTypeItem *)lItem;
                    text = item.oilType;
                }
                
                LXButton *btn = cell.btns[i];
                btn.hidden = NO;
                [btn setTitle:text forState:UIControlStateNormal];
                btn.lxTag = row;
                if (self.selectPetTag/10 == row && self.selectPetTag%10 == i) {
                    [cell btnAction:btn];
                }
            }
            cell.block = ^(NSInteger lxTag, NSInteger tag) {
                if (weakSelf.selectPetTag != lxTag*10+tag) {
                    weakSelf.selectPetTag = lxTag*10+tag;
                    [weakSelf getGoldBean];
                    dispatch_async(kMainQueue, ^{
                        [weakSelf.pTableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    });
                }
            };
            
            return cell;
        }
        MakeOrderMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeOrderMoneyCell"];
        cell.txtField.text = self.money;
        cell.block = ^(NSString *money) {
            weakSelf.money = money;
            [weakSelf getGoldBean];
        };
        cell.moneyLbl.text = self.bADItem.discountMoney?self.bADItem.discountMoney:@"-";
        return cell;
    }else if (section == 2){
        MakeOrderSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeOrderSelectCell"];
        [cell resetSelf];
        cell.line.hidden = NO;
        cell.rightV.hidden = NO;
        if (row == 0) {
            cell.titleLbl.text = @"获取金豆";
            cell.jdLbl.text = self.bADItem.goldBean;
            cell.jdLbl.textColor = k_3_Color;
            cell.imgView.image = [UIImage imageNamed:@"icon_jd"];
        }else if (row == 1){
            cell.titleLbl.text = @"是否使用油券？";
            cell.jdLbl.text = @"无可用优惠券";
            cell.jdLbl.textColor = k_6_Color;
            cell.imgView.image = [UIImage imageNamed:@"icon_qan"];
        }
        return cell;
    }
    
    EditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressCell"];
    [cell resetSelf];
    cell.lbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14*kEqualHeight];
    cell.lbl.textColor = k_3_Color;
    cell.lbl.text = @"车牌号";
    cell.txtField.placeholder = @"请输入您的车牌号";
    cell.txtField.text = self.carNo;
    [cell.txtField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 2 && row == 1) {
        [self addUseCousView];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 1) {
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 0, kDeviceWidth-30, 44*kEqualHeight);
        label.text = @"选择油品种类:";
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14*kEqualHeight];
        label.textColor = k_3_Color;
        [view addSubview:label];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 44*kEqualHeight;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 1) {
        if (row == self.pDataBase.count) {
            return 105*kEqualHeight;
        }
        return 50*kEqualHeight;
    }else if (section == 0){
        return 55*kEqualHeight;
    }
    return 50*kEqualHeight;
}


- (IBAction)selectBtnAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
}

/**
 提交订单

 @param sender nil
 */
- (IBAction)makOrderAction:(id)sender {
    [self submitOrder];
}

/**
 提交订单
 */
-(void)submitOrder{
    if (!self.carNo) {
        [[LXViewControllerManager shareManager] showHUD:@"请输入您的车牌号"];
        return;
    }
    if (!self.bADItem) {
        [[LXViewControllerManager shareManager] showHUD:@"请输入正确的加油金额"];
        return;
    }
    [self.requestDic removeAllObjects];
    [self.requestDic setObject:self.carNo forKey:@"carId"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%.0f", [self.bADItem.discountMoney floatValue]*100] forKey:@"discountAmount"];
    [self.requestDic setObject:self.bADItem.platformDiscountPrice forKey:@"discountPrice"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%.0f", [self.bADItem.goldBean floatValue]*100] forKey:@"goldBean"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%.0f", [self.money floatValue]*100] forKey:@"oilAmount"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%.0f", [self.bADItem.oilDensity floatValue]*100] forKey:@"oilDensity"];
    [self.requestDic setObject:self.bADItem.oilType forKey:@"oilName"];
    [self.requestDic setObject:self.bADItem.literNum forKey:@"oilNum"];
    [self.requestDic setObject:self.bADItem.oilTypeId forKey:@"oilTypeId"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%.0f", [self.bADItem.realAmount floatValue]*100] forKey:@"realAmount"];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork nativePost:@"order/submitOrder" bodyparam:self.requestDic success:^(NSDictionary *dic) {
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] == 200) {
            NSString *orderid = dic[@"data"];
            ConfirmOrderController *ctr = [[ConfirmOrderController alloc] init];
            ctr.orderid = orderid;
            ctr.carNo = self.carNo;
            ctr.bADitem = self.bADItem;
            [self.navigationController pushViewController:ctr animated:YES];
        }else{
            [[LXViewControllerManager shareManager] showHUD:dic[@"msg"]];
        }
    } faile:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    } contentType:nil];
    

    
}

/**
 跳转到协议页面

 @param sender nil

 */
- (IBAction)goProtocal:(id)sender {
}


-(void)textFieldTextChanged:(UITextField *)sender{
    self.carNo = sender.text;
}

-(void)setOldPriceText:(NSString *)text{
    [[LXViewControllerManager shareManager] setThroughAttributedStringLbl:self.oldPriceLbl str:text throughColor:k_9_Color];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 添加选择优惠券视图
 */
-(void)addUseCousView{
    UseCousView *view = [UseCousView share];
    view.frame = self.view.bounds;
    CouponsBaseController *ctr = [[CouponsBaseController alloc] init];
    ctr.bgColor = [UIColor whiteColor];
    ctr.type = noUsedCouponsType;
    ctr.pTableView.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:ctr];
    ctr.view.frame = view.baseView.bounds;
    [view.baseView addSubview:ctr.view];
    [self.view addSubview:view];
}

/**
 通过接口获取优惠金额和返回金豆数
 */
-(void)getGoldBean{
    if ([self.money intValue] == 0) {
        return;
    }
    NSArray *arr = self.pDataBase[(int)self.selectPetTag/10];
    NSInteger index = self.selectPetTag%10;
    LXItem *lItem = arr[index];
    NSString *text = nil;
    if ([lItem isKindOfClass:[OilPriceItem class]]) {
        OilPriceItem *item = (OilPriceItem *)lItem;
        text = item.oilType;
    }else if ([lItem isKindOfClass:[OilTypeItem class]]){
        OilTypeItem *item = (OilTypeItem *)lItem;
        text = item.oilType;
    }

    [LXNetWork getDataWithParm:@{@"oilType":text, @"money":[NSString stringWithFormat:@"%d", [self.money intValue]*100]} url:@"oilStation/selectWithType" successBlock:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            NSDictionary *data = (NSDictionary *)dic[@"data"];
            BeaAndDiscountMoneyItem *item = [BeaAndDiscountMoneyItem mj_objectWithKeyValues:data];
            item.oilPrice = [[LXViewControllerManager shareManager] divided100:item.oilPrice];
            item.goldBean = [NSString stringWithFormat:@"%.0f", roundf([item.goldBean floatValue]/100.f)];
            item.realAmount = [[LXViewControllerManager shareManager] divided100:item.realAmount];
            item.discountMoney = [[LXViewControllerManager shareManager] divided100:item.discountMoney];
            
            self.bADItem = item;
            [self.pTableView reloadData];
            [self setBottomView];
        }
    } errorBlock:^(NSError *error) {
        
    }];
}


-(void)setBottomView{
    [self setOldPriceText:self.money];
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", self.bADItem.realAmount];
    self.pPriceLbl.text = [NSString stringWithFormat:@"本次为您节省：%@", self.bADItem.discountMoney];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
