//
//  MineViewController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MineViewController.h"
#import "MineTopCell.h"
#import "MineTtitleCell.h"
#import "MineServeCell.h"
#import "MinePeaController.h"
#import "PersonalInfoController.h"
#import "FeedBackController.h"
#import "CollectPetStationController.h"
#import "PetOrderController.h"
#import "MyNewsContentController.h"
#import "MyCouponsController.h"
#import "MineShareView.h"


@interface MineViewController ()

@property(nonatomic, strong)NSArray *serveArr;
@property(nonatomic, strong)UserItem *item;

@end

@implementation MineViewController

- (void)viewDidLoad {
    self.leftButtonType = kNav_hide;
    [super viewDidLoad];
    self.navTitle = @"我的";
    
    // Do any additional setup after loading the view from its nib.
    [[LXNotifyManager shareInstance] addTarget:self withKey:kRefreshUserInfo withBlock:^(NSDictionary *userInfo) {
        [self loadData];
    }];
    [[LXNotifyManager shareInstance] addTarget:self withKey:kRefreshMineVC withBlock:^(NSDictionary *userInfo) {
        self.item = [LXUserDefault userItem];
        [self.pTableView reloadData];
    }];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)loadData{
    if ([LXUserDefault userid]) {
        [LXNetWork getDataWithParm:@{@"userId":[LXUserDefault userid]} url:@"/user/userInfo" successBlock:^(NSDictionary *dic) {
            if ([dic[@"status"] intValue] == 200) {
                NSDictionary *data = dic[@"data"];
                UserItem *item = [UserItem mj_objectWithKeyValues:data];
                self.item = item;
                [LXUserDefault saveUserItem:item];
                [self.pTableView reloadData];
            }
        } errorBlock:^(NSError *error) {
            
        }];
    }
}


-(void)reloadTableview{
    self.serveArr = @[@[@{@"text":@"我的订单", @"img":@"me_tab_icon_dingdan"}, @{@"text":@"油站关注", @"img":@"me_tab_icon_guanzhu"}, @{@"text":@"我的商城", @"img":@"me_tab_icon_shangcheng"}, @{@"text":@"帮助与反馈", @"img":@"me_tab_icon_fankui"}]];
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MineTopCell" bundle:nil] forCellReuseIdentifier:@"MineTopCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MineTtitleCell" bundle:nil] forCellReuseIdentifier:@"MineTtitleCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MineServeCell" bundle:nil] forCellReuseIdentifier:@"MineServeCell"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 1;
    }else if (section == 1) {
        return self.serveArr.count;
    }
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak MineViewController *weakSelf = self;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    MineTtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTtitleCell"];
    [cell resetSelf];
    if (section == 0) {
        if (row == 0) {
            MineTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTopCell"];
            if (self.item.userHeader) {
                [cell.smailImgView sd_setImageWithURL:[NSURL URLWithString:self.item.userHeader] placeholderImage:[UIImage imageNamed:@"logo"]];
            }
            cell.detailLbl.text = self.item.mobilePhone;
            cell.titleLbl.text = self.item.wechat;
            return cell;
        }else{
            cell.titleLbl.text = @"我的消息";
            cell.titleLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14*kEqualHeight];
            cell.detailLbl.text = @"查看详细";
            cell.detailLbl.textColor = k_6_Color;
            cell.signV.hidden = NO;
        }
    }else if(section == 2){
        if (row == 0) {
            cell.titleLbl.text = @"金豆";
            cell.detailLbl.text = self.item.userBeans;
        }else if(row == 1){
            cell.titleLbl.text = @"优惠券";
            cell.detailLbl.text = @"无";
        }
    }else if (section == 3){
        cell.titleLbl.text = @"邀请有礼";
        cell.detailLbl.text = @"邀请好友送大礼！";
        cell.detailLbl.textColor = kRedColor;
    }else if (section == 1){
        MineServeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineServeCell"];
        [cell resetSelf];
        cell.block = ^(NSInteger tag) {
            if (tag == 13) {// 反馈
                [weakSelf pushToFeedBackController];
            }else if (tag == 11){// 收藏
                [weakSelf pushToCollectPetStationController];
            }else if (tag == 10){// 加油订单
                [weakSelf pushToPetOrderController];
            }else if (tag == 12){
                // 商城订单
            }
        };
        NSArray *arr = self.serveArr[row];
        NSInteger min = MIN(arr.count, cell.views.count);
        for (NSInteger i = 0; i < min; i++) {
            NSDictionary *dic = arr[i];
            MineServeBaseView *view = cell.views[i];
            view.hidden = NO;
            view.lbl.text = dic[@"text"];
            view.imgView.image = [UIImage imageNamed:dic[@"img"]];
            view.btn.tag = section*10 + i;
            if (row == 0 && i == 2) {
                view.hintLbl.hidden = NO;
                view.hintLbl.text = @"99";
            }else if (row == 0 && i == 3){
                view.feedBackV.hidden = NO;
            }
        }
        return cell;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            return 90*kEqualHeight;
        }
        return 40*kEqualHeight;
    }else if (section == 1){
        return 100*kEqualHeight;
    }
    return 44*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40*kEqualHeight;
    }
    return 0.01;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 1) {
        view.frame = CGRectMake(0, 0, kDeviceWidth, 40*kEqualHeight);
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth-20, 40*kEqualHeight)];
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14*kEqualHeight];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = k_3_Color;
        label.text = @"我的服务";
        [view addSubview:label];
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 2) {
        if (row == 0) {
            [self pushToMinePeaController];
        }else if (row == 1){
            [self pushToMyCouponsController];
        }
    }else if (section == 0){
        if (row == 0) {
            [self pushToPersonalInfoController];
        }else if (row == 1){
            [self pushToMyNewsContentController];
        }
    }else if (section == 3){
        if (row == 0){
            [self showShareView];
        }
    }
}


-(void)pushToMinePeaController{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:YES];
        return;
    }
    MinePeaController *ctr = [[MinePeaController alloc] init];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}

-(void)pushToPersonalInfoController{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:YES];
        return;
    }
    PersonalInfoController *ctr = [[PersonalInfoController alloc] init];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}


-(void)pushToFeedBackController{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:YES];
        return;
    }
    FeedBackController *ctr = [[FeedBackController alloc] init];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}


-(void)pushToCollectPetStationController{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:YES];
        return;
    }
    CollectPetStationController *ctr = [[CollectPetStationController alloc] init];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}

-(void)pushToPetOrderController{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:YES];
        return;
    }
    PetOrderController *ctr = [[PetOrderController alloc] init];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}

-(void)pushToMyNewsContentController{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:YES];
        return;
    }
    MyNewsContentController *ctr = [[MyNewsContentController alloc] init];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}

-(void)pushToMyCouponsController{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:YES];
        return;
    }
    MyCouponsController *ctr = [[MyCouponsController alloc] init];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}

-(void)showShareView{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:YES];
        return;
    }
    MineShareView *view = [MineShareView share];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
