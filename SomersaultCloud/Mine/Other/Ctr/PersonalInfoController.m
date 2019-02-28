//
//  PersonalInfoController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PersonalInfoController.h"
#import "MineTtitleCell.h"
#import "ChangePhoneNumController.h"
#import "MyAddressController.h"
#import "MyInvoiceController.h"
#import "MyCarController.h"


@interface PersonalInfoController ()

@property(nonatomic, strong)NSArray *dataSource;
@property(nonatomic, strong)UserItem *item;

@end

@implementation PersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"个人信息";
    self.dataSource = @[@[@"切换城市"], @[@"手机号",@"微信账号"], @[@"我的地址", @"我的发票", @"我的车辆"]];
    // Do any additional setup after loading the view from its nib.
    [[LXNotifyManager shareInstance] addTarget:self withKey:kRefreshUserInfo withBlock:^(NSDictionary *userInfo) {
        [self loadData];
    }];
    [self loadData];
}

-(void)loadData{
    if ([LXUserDefault userid]) {
        [LXNetWork getDataWithParm:@{@"userId":[LXUserDefault userid]} url:@"/user/userInfo" successBlock:^(NSDictionary *dic) {
            if ([dic[@"status"] intValue] == 200) {
                NSDictionary *data = dic[@"data"];
                self.item = [UserItem mj_objectWithKeyValues:data];
                [self.pTableView reloadData];
            }
        } errorBlock:^(NSError *error) {
            
        }];
    }
}

-(void)reloadTableview{
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MineTtitleCell" bundle:nil] forCellReuseIdentifier:@"MineTtitleCell"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataSource[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSArray *arr = self.dataSource[section];
    MineTtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTtitleCell"];
    [cell resetSelf];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14*kEqualHeight];
    cell.titleLbl.text = arr[row];
    cell.detailLbl.font = [UIFont systemFontOfSize:14*kEqualHeight];
    cell.detailLbl.textColor = Color1(136);
    if (section == 0) {
        cell.detailLbl.text = self.item.userAddress;
    }else if (section == 1){
        if (row == 0) {
            cell.detailLbl.text = self.item.mobilePhone;
        }else if (row == 1){
            cell.detailLbl.text = self.item.wechat;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
    }else if (section == 1){
        if (row == 0) {
            [self pushToChangePhoneNumController];
        }
    }else if ( section == 2){
        if (row == 0) {
            [self pushToMyAddressController];
        }else if (row == 1){
            [self pushToMyInvoiceController];
        }else if (row == 2){
            [self pushToMyCarController];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return (self.lHeaderHeight+23)*kEqualHeight;
    }
    return self.lHeaderHeight*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kDeviceWidth, self.lHeaderHeight*kEqualHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth-20, self.lHeaderHeight*kEqualHeight)];
    label.font = [UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = k_9_Color;
    NSString *title = @"常用设置";
    if (section == 1) {
        title = @"修改用户";
    }else if (section == 2){
        title = @"信息设置";
    }
    label.text = title;
    [view addSubview:label];
    if (section == 1) {
        view.frame = CGRectMake(0, 0, kDeviceWidth, (self.lHeaderHeight+23)*kEqualHeight);
        UILabel *smallLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lHeaderHeight*kEqualHeight, kDeviceWidth, 23*kEqualHeight)];
        smallLbl.backgroundColor = Color(255, 227, 227);
        smallLbl.textAlignment = NSTextAlignmentCenter;
        smallLbl.adjustsFontSizeToFitWidth = YES;
        smallLbl.font = [UIFont systemFontOfSize:12];
        smallLbl.textColor = kRedColor;
        smallLbl.text = @"为了确保您的账号信息安全，限制每个账号每月只可修改一次";
        [view addSubview:smallLbl];
    }
    [[LXViewControllerManager shareManager] fixFontWithView:view];
    return view;
}


/**
 更换手机号页面
 */
-(void)pushToChangePhoneNumController{
    ChangePhoneNumController *ctr = [[ChangePhoneNumController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}

/**
 我的地址页面
 */
-(void)pushToMyAddressController{
    MyAddressController *ctr = [[MyAddressController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}

/**
 我的发票页面
 */
-(void)pushToMyInvoiceController{
    MyInvoiceController *ctr = [[MyInvoiceController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}

/**
 我的车页面
 */
-(void)pushToMyCarController{
    MyCarController *ctr = [[MyCarController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
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
- (IBAction)loginOut:(id)sender {
    [[LXViewControllerManager shareManager] showAlertView:nil message:@"确定退出吗？" actions:@[[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [LXUserDefault clear];
        [[LXNotifyManager shareInstance] postNotifyKey:kRefreshMineVC];
        [self.navigationController popViewControllerAnimated:YES];
    }], [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]]];
}

@end
