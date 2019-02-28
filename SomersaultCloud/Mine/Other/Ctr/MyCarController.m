//
//  MyCarController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/28.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MyCarController.h"
#import "MyCarCell.h"
#import "EditCarController.h"

@interface MyCarController ()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation MyCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的车辆";
    // Do any additional setup after loading the view from its nib.
    [[LXViewControllerManager shareManager] fixFontWithView:self.addBtn];
    
    [[LXNotifyManager shareInstance] addTarget:self withKey:kRefreshCarList withBlock:^(NSDictionary *userInfo) {
        [self loadData];
    }];
    [self loadData];
}


-(void)loadData{
    [super loadData];
    [LXNetWork getDataWithParm:@{@"userId":[LXUserDefault userid]} url:@"user/myCar" successBlock:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            NSArray *arr = dic[@"data"];
            [self.pDataBase removeAllObjects];
            for (NSDictionary *arrDic in arr) {
                [self.pDataBase addObject:[CarItem mj_objectWithKeyValues:arrDic]];
            }
            if (self.pDataBase.count > 0) {
                [[LXViewControllerManager shareManager] removeEmptyView:self];
                [self.pTableView reloadData];
            }else{
                [[LXViewControllerManager shareManager] addEmptyView:self frame:CGRectZero title:@"还没有车辆信息哦" font:0 img:nil bgColor:nil];
            }
        }
    } errorBlock:^(NSError *error) {
        
    }];
}

-(void)reloadTableview{
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MyCarCell" bundle:nil] forCellReuseIdentifier:@"MyCarCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pDataBase.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    CarItem *car = self.pDataBase[row];
    MyCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCarCell"];
    [cell setModel:car];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarItem *item = self.pDataBase[indexPath.row];
    EditCarController *ctr = [[EditCarController alloc] init];
    NSDictionary *dic = [item mj_keyValues];
    ctr.car = [CarItem mj_objectWithKeyValues:dic];
    [self.navigationController pushViewController:ctr animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130*1;
}


/**
 添加车辆信息

 @param sender nil
 */
- (IBAction)addCar:(id)sender {
    EditCarController *ctr = [[EditCarController alloc] init];
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
