//
//  OrderCompleteController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/9.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "OrderCompleteController.h"
#import "ConfirmOrderTableCell.h"
#import "OrderCodeCell.h"

@interface OrderCompleteController ()

@property(nonatomic, strong)NSMutableArray *preferArr;
@property(nonatomic,assign)BOOL showPrefer;
@property(nonatomic, strong)UIImage *img;
@property(nonatomic, assign)NSInteger selectRow;

@end

@implementation OrderCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navTitle = @"订单已完成";
    // Do any additional setup after loading the view from its nib.
    [self loadData];
}

-(void)loadData{
    if (!self.item.oilOrderId) {
        return;
    }
    [self.requestDic setObject:self.item.oilOrderId forKey:@"orderId"];
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork getDataWithParm:self.requestDic url:@"order/getOrderById" successBlock:^(NSDictionary *dic) {
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] ==200) {
            NSDictionary *data = dic[@"data"];
            self.item = [PetOrderItem mj_objectWithKeyValues:data];
            self.item.realAmount = [[LXViewControllerManager shareManager] divided100:self.item.realAmount];
            self.item.oilAmount = [[LXViewControllerManager shareManager] divided100:self.item.oilAmount];
            self.item.oilPrice = [[LXViewControllerManager shareManager] divided100:self.item.oilPrice];
            self.item.stationPrice = [[LXViewControllerManager shareManager] divided100:self.item.stationPrice];
            self.item.unionDiscountPrice = [[LXViewControllerManager shareManager] divided100:self.item.unionDiscountPrice];
            [self reloadData];
            [self.pTableView reloadData];
        }
    } errorBlock:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    }];
}

-(void)reloadTableview{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_dingdan_icon_yiqupiao"]];
    CGFloat width = 142*kDeviceWidth/375.f;
    imgView.frame = CGRectMake(kDeviceWidth - width - 20, 44, width, width*53/71.f);
    [self.pTableView addSubview:imgView];
    [self reloadData];
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"ConfirmOrderTableCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderTableCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"OrderCodeCell" bundle:nil] forCellReuseIdentifier:@"OrderCodeCell"];
    dispatch_async(kMainQueue, ^{
        self.img = [[LXViewControllerManager shareManager] createCodeImgWithText:@"你试试" withSize:180];
    });
    self.selectRow = 6;
}

-(void)reloadData{
    [self.pDataBase removeAllObjects];
    [self.pDataBase addObjectsFromArray:@[@{@"title":@"订单号:",@"detail":[self getUnEmptyText:self.item.oilOrderId]},@{@"title":@"加油场站:",@"detail":[self getUnEmptyText:self.item.stationName]},@{@"title":@"车牌号:",@"detail":[self getUnEmptyText:self.item.carId]}, @{@"title":@"油品种类:",@"detail":[self getUnEmptyText:self.item.oilName]}, @{@"title":@"加油金额:",@"detail":[self getUnEmptyText:self.item.oilAmount]},@{@"title":@"支付金额:",@"detail":[self getUnEmptyText:self.item.realAmount]},@{@"title":@"优惠金额:",@"detail":[self getUnEmptyText:self.item.unionDiscountPrice]},@{@"title":@"实际加油金额:",@"detail":[self getUnEmptyText:self.item.oilAmount]},@{@"title":@"实际加油升数:",@"detail":[self getUnEmptyText:self.item.oilNum]}, @{@"title":@"统一油价:",@"detail":@"7000.4元/L"},@{@"title":@"场站油价:",@"detail":[self getUnEmptyText:self.item.stationPrice]}, @{@"title":@"平台油价:",@"detail":@"100000000元/L"},@{@"title":@"付款方式:",@"detail":[self getUnEmptyText:self.item.payType]},@{@"title":@"收款方:",@"detail":[self getUnEmptyText:self.item.payee]} ,@{@"title":@"支付时间:",@"detail":[self getUnEmptyText:self.item.insertDate]}]];
    
    [self.preferArr removeAllObjects];
    [self.preferArr addObject:@{@"title":@". 平台优惠",@"detail":@"￥1000"}];
    [self.preferArr addObject:@{@"title":@". 优惠券",@"detail":@"￥1000"}];
    
}

-(NSString *)getUnEmptyText:(NSString *)text{
    return text?text:@"";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.showPrefer) {
            return self.pDataBase.count + self.preferArr.count;
        }
        return self.pDataBase.count;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        OrderCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCodeCell"];
        [cell showBtn:YES];
        cell.imgView.image = self.img;
        return cell;
    }
    NSDictionary *dic = @{};
    ConfirmOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderTableCell"];
    [cell resetSelf];
    cell.titleLbl.textColor = k_6_Color;
    cell.titleLbl.font = [UIFont systemFontOfSize:12*kEqualHeight];
    cell.detailLbl.font = [UIFont systemFontOfSize:14*kEqualHeight];
    cell.detailLbl.textColor = k_6_Color;
    if (!self.showPrefer) {
        dic = self.pDataBase[row];
    }else{
        if (row >self.selectRow) {
            if (row - self.selectRow -1 < self.preferArr.count) {
                cell.baseView.hidden = NO;
                dic = self.preferArr[row - self.selectRow - 1];
                cell.titleLbl.font = [UIFont systemFontOfSize:11*kEqualHeight];
                cell.detailLbl.font = [UIFont systemFontOfSize:11*kEqualHeight];
            }else{
                dic = self.pDataBase[row - self.preferArr.count];
            }
        }else{
            dic = self.pDataBase[row];
        }
    }
    if (row == self.selectRow) {
        cell.downImgView.hidden = NO;
    }
    cell.titleLbl.text = dic[@"title"];
    cell.detailLbl.text = dic[@"detail"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row == self.selectRow) {
        self.showPrefer = !self.showPrefer;
        [self.pTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 360*kEqualHeight;
    }
    return 30*kEqualHeight;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(NSMutableArray *)preferArr{
    if (!_preferArr) {
        self.preferArr = [NSMutableArray array];
    }
    return _preferArr;
}

-(void)setImg:(UIImage *)img{
    _img = img;
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

@end
