//
//  LXTabBarController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/12.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTabBarController.h"
#import "LXNavigationController.h"
#import "MineViewController.h"
#import "HomePageController.h"
#import "PetrolController.h"

@interface LXTabBarController ()

@end

@implementation LXTabBarController



//+ (void)load
//{
//    // 获取哪个类中UITabBarItem
//    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
//    // 创建一个描述文本属性的字典
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [[@"ff7d2d" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
//    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
//    
//    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
//    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
//}

//添加子控制器
- (void)setupAllChildViewController
{
    HomePageController * homeVC = [[HomePageController alloc] init];
    LXNavigationController * homeNav = [[LXNavigationController alloc] initWithRootViewController:homeVC];
    [self addChildViewController:homeNav];
    
    PetrolController * petrolVC = [[PetrolController alloc] init];
    LXNavigationController * petrolNav = [[LXNavigationController alloc] initWithRootViewController:petrolVC];
    [self addChildViewController:petrolNav];

    MineViewController * mineVC = [[MineViewController alloc] init];
    LXNavigationController * mineNav = [[LXNavigationController alloc] initWithRootViewController:mineVC];
    [self addChildViewController:mineNav];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllChildViewController];
    [self setupAllTitle];
}


- (void)setupAllTitle
{
    LXNavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"首页";
    nav.tabBarItem.image = [UIImage imageNamed:@"icon_home_n"];
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"icon_home_s"];
    
    LXNavigationController *nav3 = self.childViewControllers[1];
    nav3.tabBarItem.title = @"加油";
    nav3.tabBarItem.image =[UIImage imageOriginalWithName:@"icon_petrol_n"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"icon_petrol_s"];
    
    LXNavigationController *nav4 = self.childViewControllers[2];
    nav4.tabBarItem.title = @"我的";
    nav4.tabBarItem.image = [UIImage imageNamed:@"icon_me_n"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"icon_me_s"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : kRedColor }
                                             forState:UIControlStateSelected];
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
