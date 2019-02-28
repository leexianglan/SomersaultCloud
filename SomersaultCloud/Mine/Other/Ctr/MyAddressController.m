//
//  MyAddressController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MyAddressController.h"
#import "MakeOrderSelectCell.h"
#import "MyAddressTableCell.h"
#import "EditAddressController.h"

@interface MyAddressController ()



@end

@implementation MyAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的地址";
    // Do any additional setup after loading the view from its nib.
    [[LXNotifyManager shareInstance] addTarget:self withKey:kRefreshAddressList withBlock:^(NSDictionary *userInfo) {
        [self loadData];
    }];
    
    [self loadData];
}


-(void)loadData{
    [super loadData];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork getDataWithParm:self.requestDic url:@"user/getUserAddress" successBlock:^(NSDictionary *dic) {
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] == 200) {
            [self.pDataBase removeAllObjects];
            NSArray *arr = (NSArray *)dic[@"data"];
            for (NSDictionary *arrD in arr) {
                [self.pDataBase addObject:[AddressItem mj_objectWithKeyValues:arrD]];
                NSLog(@"%@", arrD);
            }
            [self.pTableView reloadData];
        }
    } errorBlock:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    }];
}

-(void)reloadTableview{
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MakeOrderSelectCell" bundle:nil] forCellReuseIdentifier:@"MakeOrderSelectCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MyAddressTableCell" bundle:nil] forCellReuseIdentifier:@"MyAddressTableCell"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.pDataBase.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section > 0) {
        AddressItem *item = self.pDataBase[section -1];
        MyAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAddressTableCell"];
        [cell resetSelf];
        cell.lbl.text = item.username;
        cell.detailLbl.text = [NSString stringWithFormat:@"%@%@", item.userAddress, item.detailAddr];
        
        return cell;
    }
    
    MakeOrderSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeOrderSelectCell"];
    [cell resetSelf];
    [cell setImgWidth:-8*kEqualHeight];
    cell.imgView.image = [UIImage imageNamed:@"me_dizhi_icon_tianjia"];
    cell.titleLbl.text = @"新增地址";
    cell.rightV.hidden = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    [self pushToEditAddressController:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section) {
        AddressItem *item = self.pDataBase[section -1];
        return [[LXViewControllerManager shareManager] heightForText:[NSString stringWithFormat:@"%@%@", item.userAddress, item.detailAddr] font:12 marginW:30 marginH:55];
    }
    return 60*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*kEqualHeight;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self deleteStation:indexPath.section - 1];
}

-(void)deleteStation:(NSInteger)index{
    AddressItem *item = self.pDataBase[index];

    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork postDataWithParm:@{@"id":item.lId} url:@"user/deleteAddress" successBlock:^(NSDictionary *dic) {
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] == 200) {
            [self.pDataBase removeObjectAtIndex:index];
            [self.pTableView reloadData];
//            if (self.pDataBase.count == 0) {
//                [[LXViewControllerManager shareManager] addEmptyView:self frame:CGRectZero title:nil font:0 img:nil bgColor:nil];
//            }
        }
    } errorBlock:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    }];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}



/**
 跳转到x编辑地址页面

 @param section 位置
 */
-(void)pushToEditAddressController:(NSInteger)section{
    EditAddressController *ctr = [[EditAddressController alloc] init];
    if (section > 0) {
        AddressItem *item = self.pDataBase[section -1];
        NSDictionary *dic = [item mj_keyValues];
        ctr.item = [AddressItem mj_objectWithKeyValues:dic];
    }
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



@end
