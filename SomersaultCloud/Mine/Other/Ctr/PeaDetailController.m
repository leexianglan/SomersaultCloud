//
//  PeaDetailController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/28.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PeaDetailController.h"
#import "PeaDetailCell.h"

@interface PeaDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;


@end

@implementation PeaDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"交易详情";
    // Do any additional setup after loading the view from its nib.
    [[LXViewControllerManager shareManager] fixFontWithView:self.stateLbl];
}

-(void)reloadTableview{
    self.pDataBase = [NSMutableArray arrayWithObjects:@"获取金豆", @"商户", @"商品", @"订单金额", @"优惠", @"支付方式", nil];
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"PeaDetailCell" bundle:nil] forCellReuseIdentifier:@"PeaDetailCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.pDataBase.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    PeaDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeaDetailCell"];
    [cell resetSelf];
    cell.leftLbl.text = self.pDataBase[row];
    if (row ==0) {
        cell.line.hidden = NO;
        cell.leftLbl.textColor = k_3_Color;
        cell.leftLbl.font = [UIFont systemFontOfSize:14*kEqualHeight];
        cell.rightLbl.textColor = k_3_Color;
        cell.rightLbl.font = [UIFont systemFontOfSize:14*kEqualHeight];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        return 30*kEqualHeight;
    }
    return 40*kEqualHeight;
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
