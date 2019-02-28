//
//  CouponsBaseController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/29.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "CouponsBaseController.h"
#import "CouponsCell.h"

@interface CouponsBaseController ()

@end

@implementation CouponsBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[LXViewControllerManager shareManager] addEmptyView:self frame:CGRectZero title:@"无可使用油券～" font:0 img:nil bgColor:self.bgColor];
}

-(void)reloadTableview{
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"CouponsCell" bundle:nil] forCellReuseIdentifier:@"CouponsCell"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    CouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponsCell"];
    cell.block = ^(NSInteger lxTag, NSInteger tag) {
        
    };
    [cell canUseWithType:self.type];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*kEqualHeight;
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
