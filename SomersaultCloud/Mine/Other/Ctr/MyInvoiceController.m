//
//  MyInvoiceController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/26.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MyInvoiceController.h"
#import "MakeOrderSelectCell.h"
#import "MyInvoiceCell.h"
#import "AddInvoiceController.h"
#import "EditInvoiceController.h"

@interface MyInvoiceController ()

@end

@implementation MyInvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的发票";
    // Do any additional setup after loading the view from its nib.
    [[LXViewControllerManager shareManager] showHUDOnly];
    [self loadData];
    [[LXNotifyManager shareInstance] addTarget:self withKey:kRefreshInvoiceList withBlock:^(NSDictionary *userInfo) {
        [self loadData];
    }];
}

-(void)loadData{
    [super loadData];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [LXNetWork getDataWithParm:self.requestDic url:@"invoice/getUserInvoice" successBlock:^(NSDictionary *dic) {
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] == 200) {
            [self.pDataBase removeAllObjects];
            NSArray *arr = (NSArray *)dic[@"data"];
            for (NSDictionary *arrD in arr) {
                [self.pDataBase addObject:[InvoiceItem mj_objectWithKeyValues:arrD]];
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
    [self.pTableView registerNib:[UINib nibWithNibName:@"MyInvoiceCell" bundle:nil] forCellReuseIdentifier:@"MyInvoiceCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pDataBase.count +1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row) {
        MyInvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInvoiceCell"];
        InvoiceItem *item = self.pDataBase[row -1];
        if ([item.taxType intValue] == 0) {
            cell.detailLbl.text = @"个人";
            cell.titleLbl.text = item.userName;
        }else{
            cell.titleLbl.text = item.taxCompany;
            cell.detailLbl.text = @"单位";
        }
        return cell;
    }
    MakeOrderSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeOrderSelectCell"];
    [cell resetSelf];
    [cell setImgWidth:-8*kEqualHeight];
    cell.rightV.hidden = NO;
    cell.imgView.image = [UIImage imageNamed:@"me_dizhi_icon_tianjia"];
    cell.titleLbl.text = @"添加发票信息";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row == 0 ) {
        [self pushToAddInvoiceController];
    }else{
        [self pushToEditInvoiceController:row-1];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        return 60*kEqualHeight;
    }
    return 50*kEqualHeight;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self deleteStation:indexPath.row - 1];
}

/**
 删除发票信息

 @param index 位置
 */
-(void)deleteStation:(NSInteger)index{
    InvoiceItem *item = self.pDataBase[index];
    [LXNetWork postDataWithParm:@{@"id":item.lId} url:@"/invoice/deleteInvoice" successBlock:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            [self.pDataBase removeObjectAtIndex:index];
            [self.pTableView reloadData];
//            if (self.pDataBase.count == 0) {
//                [[LXViewControllerManager shareManager] addEmptyView:self frame:CGRectZero title:nil font:0 img:nil bgColor:nil];
//            }
        }
    } errorBlock:^(NSError *error) {
        
    }];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

/**
 添加发票
 */
-(void)pushToAddInvoiceController{
    AddInvoiceController *ctr = [[AddInvoiceController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}

/**
 编辑发票

 @param index 位置
 */
-(void)pushToEditInvoiceController:(NSInteger)index{
    InvoiceItem *item = self.pDataBase[index];
    EditInvoiceController *ctr = [[EditInvoiceController alloc] init];
    NSDictionary *dic = [item mj_keyValues];
    ctr.item = [InvoiceItem mj_objectWithKeyValues:dic];
    ctr.isPersonType = [item.taxType  intValue] == 0;
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
