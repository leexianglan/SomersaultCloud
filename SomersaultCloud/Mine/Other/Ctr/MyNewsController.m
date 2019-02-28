//
//  MyNewsController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/27.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MyNewsController.h"
#import "NewsTableCell.h"
#import "NewsDetailController.h"

@interface MyNewsController ()

@end

@implementation MyNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.type == eventType) {
        [[LXViewControllerManager shareManager] addEmptyView:self frame:CGRectZero title:@"你还没有消息呦～" font:14 img:@"me_message_meiyouxiaoxi" bgColor:[UIColor whiteColor]];
    }
}

- (void)reloadTableview{
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"NewsTableCell" bundle:nil] forCellReuseIdentifier:@"NewsTableCell"];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableCell"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailController *ctr = [[NewsDetailController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120*kEqualHeight;
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
