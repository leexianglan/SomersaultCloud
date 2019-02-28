//
//  MakeOrderController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/15.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MakeOrderController.h"
#import "MakeOrderTableCell.h"
#import "StationDetailItem.h"
#import "PetStationPriceCell.h"
#import "MineTtitleCell.h"
#import "PetStationBtnCell.h"
#import "EditOrderController.h"

@interface MakeOrderController ()

@property(nonatomic, strong)StationDetailItem *item;
@property(nonatomic, assign)int collectState; //1 已关注  0 未关注

@end

@implementation MakeOrderController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"加油站详情";
    // Do any additional setup after loading the view from its nib.
    [self loadData];
}

-(void)loadData{
    [super loadData];

    [self.requestDic removeAllObjects];
    [self.requestDic setObject:self.stationid forKey:@"id"];
    [self.requestDic setObject:[LXUserDefault location].firstObject forKey:@"longitude"];
    [self.requestDic setObject:[LXUserDefault location].lastObject forKey:@"latitude"];
    
    [LXNetWork getDataWithParm:self.requestDic url:@"oilStation/selectStationAndOilType" successBlock:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200 ) {
            NSDictionary *data = (NSDictionary *)dic[@"data"];
            self.item = [StationDetailItem mj_objectWithKeyValues:data];
            [self.pDataBase removeAllObjects];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *arrD in self.item.oilPriceList) {
                OilPriceItem *item = [OilPriceItem mj_objectWithKeyValues:arrD];
                item.oilPrice = [[LXViewControllerManager shareManager] divided100:item.oilPrice];
                item.reducedPrice = [[LXViewControllerManager shareManager] divided100:item.reducedPrice];
                item.oilNowPrice = [[LXViewControllerManager shareManager] divided100:item.oilNowPrice];
                [temp addObject:item];
                if (temp.count ==3) {
                    [self.pDataBase addObject:[temp copy]];
                    [temp removeAllObjects];
                }
            }
            if (temp.count > 0) {
                [self.pDataBase addObject:temp];
            }
            [self.pTableView reloadData];
        }
    } errorBlock:^(NSError *error) {
        
    }];
    
    if ([LXUserDefault userid]) {
        [LXNetWork getDataWithParm:@{@"userId":[LXUserDefault userid], @"stationId":self.stationid} url:@"user/isFollow" successBlock:^(NSDictionary *dic) {
            if ([dic[@"status"] intValue] == 200) {
                self.collectState = [dic[@"data"] intValue];
                [self.pTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            }
        } errorBlock:^(NSError *error) {
            
        }];
    }
}

- (void)reloadTableview{
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MakeOrderTableCell" bundle:nil] forCellReuseIdentifier:@"MakeOrderTableCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MineTtitleCell" bundle:nil] forCellReuseIdentifier:@"MineTtitleCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"PetStationPriceCell" bundle:nil] forCellReuseIdentifier:@"PetStationPriceCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"PetStationBtnCell" bundle:nil] forCellReuseIdentifier:@"PetStationBtnCell"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    if (section == 1) {
        return self.pDataBase.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    __weak MakeOrderController *weakSelf = self;
    if (section == 1) {
        NSArray *tempArr = self.pDataBase[row];
        PetStationPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PetStationPriceCell"];
        [cell setModelWithArr:tempArr];
        return cell;
    }else if (section == 3){
        PetStationBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PetStationBtnCell"];
        [cell.btn addTarget:self action:@selector(payForPet) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (section == 2){
        MineTtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTtitleCell"];
        [cell resetSelf];
        cell.titleLbl.font = [UIFont systemFontOfSize:12*kEqualHeight];
        cell.titleLbl.textColor = k_6_Color;
        if (row == 0) {
            cell.line.hidden = NO;
            cell.titleLbl.text = @"联系油站";
        }else{
            cell.titleLbl.text = @"油站通知";
        }
        return cell;
    }
    MakeOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeOrderTableCell"];
    cell.block = ^(BOOL select) {
        [weakSelf collectStation:select];
    };
    [cell setModel:self.item];
    [cell selectFocusBtn:self.collectState == 1];
    [cell.navBtn addTarget:self action:@selector(navAction) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 2) {
        if (row == 0) {
            [self callPetStation];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 1) {
        view.frame = CGRectMake(0, 0, kDeviceWidth, 70*kEqualHeight);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 60*kEqualHeight)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14*kEqualHeight];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = k_6_Color;
        label.text = @"— 今日场站油价 —";
        [view addSubview:label];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            return 140*kEqualHeight;
            break;
        case 1:
            return 146*kEqualHeight;
        case 3:
            return 144*kEqualHeight;
            
        default:
            break;
    }
    return 40*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return (10 + 60)*kEqualHeight;
    }
    return 10*kEqualHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/**
 联系油站
 */
-(void)callPetStation{
    UIAlertController *ctr = [UIAlertController alertControllerWithTitle:self.item.name message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"电话：%@", self.item.telephone] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.item.telephone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }];

    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [callAction setValue:k_3_Color forKey:@"_titleTextColor"];
    [cancleAction setValue:Color(255, 88, 76) forKey:@"_titleTextColor"];
    
    [ctr addAction:callAction];
    [ctr addAction:cancleAction];
    [self presentViewController:ctr animated:YES completion:nil];
}

/**
 付油费
 */
-(void)payForPet{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:NO];
        return;
    }
    EditOrderController *ctr = [[EditOrderController alloc] init];
    ctr.pDataBase = [NSMutableArray arrayWithArray:self.pDataBase];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}

/**
 导航实现
 */
-(void)navAction{
    if (self.item) {
        [[LXViewControllerManager shareManager] navActionWithCtr:self lon:self.item.longitude lat:self.item.dimension name:self.item.name];
    }
}

/**
 收菜实现

 @param collect <#collect description#>
 */
-(void)collectStation:(BOOL)collect{
    if (![LXUserDefault userid] || !self.item) {
        [[LXViewControllerManager shareManager] showHUD:@"先去登录吧"];
        return;
    }
    [self.requestDic removeAllObjects];
    NSString *url = @"/user/addUsersFollow";
    [self.requestDic setObject:self.stationid forKey:@"stationId"];
    [self.requestDic setObject:self.item.name forKey:@"stationName"];
    [self.requestDic setObject:self.item.address forKey:@"stationAddress"];
    [self.requestDic setObject:self.item.logo forKey:@"logo"];
    [self.requestDic setObject:self.item.longitude  forKey:@"longitude"];
    [self.requestDic setObject:self.item.dimension forKey:@"latitude"];
    [self.requestDic setObject:[LXUserDefault openid] forKey:@"openId"];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    
    [LXNetWork nativePost:url bodyparam:self.requestDic success:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            self.collectState = self.collectState== 1?0:1;
            [self.pTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    } faile:^(NSError *error) {
        
    } contentType:nil];

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
