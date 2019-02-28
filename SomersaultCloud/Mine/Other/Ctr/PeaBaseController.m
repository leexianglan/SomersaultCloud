//
//  PeaBaseController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PeaBaseController.h"
#import "PeaBaseCell.h"
#import "PeaDetailController.h"
#import "BeanItem.h"

@interface PeaBaseController ()

@end

@implementation PeaBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

-(void)loadData{
    [super loadData];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [self.requestDic setObject:[NSString stringWithFormat:@"%ld", self.type] forKey:@"consumType"];

    [LXNetWork getDataWithParm:self.requestDic url:@"goldBean/selectByUserId" successBlock:^(NSDictionary *dic) {
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] == 200) {
            [self.pDataBase removeAllObjects];
            NSArray *arr = (NSArray *)dic[@"data"];
            for (NSDictionary *arrD in arr) {
                BeanItem *item = [BeanItem mj_objectWithKeyValues:arrD];
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
    [self.pTableView registerNib:[UINib nibWithNibName:@"PeaBaseCell" bundle:nil] forCellReuseIdentifier:@"PeaBaseCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pDataBase.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    BeanItem *item = self.pDataBase[row];
    PeaBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeaBaseCell"];
    
    [cell setModel:item];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*kEqualHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BeanItem *item = self.pDataBase[indexPath.row];
    int temp = [item.transactionType intValue];
    if (temp == 1 || temp == 2 || temp == 3 || temp ==4 ) {
        [self pushToPeaDetailController:indexPath.row];
    }
}

/**
 金豆详情页面

 @param index 位置
 */
-(void)pushToPeaDetailController:(NSInteger)index{
    BeanItem *item = self.pDataBase[index];
    PeaDetailController *ctr = [[PeaDetailController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
