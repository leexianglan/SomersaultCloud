//
//  CollectPetStationController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "CollectPetStationController.h"
#import "CollectPetStationCell.h"
#import "CollectionSationItem.h"
#import "MakeOrderController.h"

@interface CollectPetStationController ()

@end

@implementation CollectPetStationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"油站关注";
    // Do any additional setup after loading the view from its nib.
    [self loadData];
}

-(void)loadData{
    [super loadData];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [self.requestDic setObject:[LXUserDefault location].firstObject forKey:@"longitude"];
    [self.requestDic setObject:[LXUserDefault location].lastObject forKey:@"latitude"];
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork getDataWithParm:self.requestDic url:@"user/getUsersFollow" successBlock:^(NSDictionary *dic) {
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] == 200) {
            NSArray *arr = dic[@"data"];
            for (NSDictionary *arrD in arr) {
                CollectionSationItem *item = [CollectionSationItem mj_objectWithKeyValues:arrD];
                item.oilPrice = [[LXViewControllerManager shareManager] divided100:item.oilPrice];
                [self.pDataBase addObject:item];
            }
            if (self.pDataBase.count > 0) {
                [[LXViewControllerManager shareManager] removeEmptyView:self];
                [self.pTableView reloadData];
            }else{
                [[LXViewControllerManager shareManager] addEmptyView:self frame:CGRectZero title:nil font:0 img:nil bgColor:nil];
            }
        }
    } errorBlock:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    }];
    

}

-(void)reloadTableview{
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"CollectPetStationCell" bundle:nil] forCellReuseIdentifier:@"CollectPetStationCell"];
    [self headerRefresh];
    [self footerRefresh];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.pDataBase.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    CollectionSationItem *item = self.pDataBase[section];
    CollectPetStationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectPetStationCell"];
    [cell setModel:item section:section];
    [cell.navBtn addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
//    [cell resetSelf];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionSationItem *item = self.pDataBase[indexPath.section];
    MakeOrderController *ctr = [[MakeOrderController alloc] init];
    ctr.stationid = item.stationId;
    [self.navigationController pushViewController:ctr animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self deleteStation:indexPath.section];
}

/**
 取消关注

 @param index 位置
 */
-(void)deleteStation:(NSInteger)index{
    CollectionSationItem  *item = self.pDataBase[index];
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork postDataWithParm:@{@"id":item.lId} url:@"user/deleteUsersFollow" successBlock:^(NSDictionary *dic) {
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
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 导航实现

 @param sender 位置
 */
-(void)navAction:(UIButton*)sender{
    NSInteger tag = sender.tag;
    CollectionSationItem *item = self.pDataBase[tag];
    [[LXViewControllerManager shareManager] navActionWithCtr:self lon:item.longitude lat:item.latitude name:item.stationName];
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
