//
//  PetrolController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/14.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PetrolController.h"
#import "YBPopupMenu.h"
#import "PetrolTableCell.h"
#import "OttoCycleLabel.h"
#import "MakeOrderController.h"
#import "EditOrderController.h"
#import "StationItem.h"


@interface PetrolController ()<YBPopupMenuDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet LXButtonWithRotaingImg *topCenterView;
@property (weak, nonatomic) IBOutlet LXButtonWithRotaingImg *topRightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otttLblH;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIView *priceBaseView;
@property (weak, nonatomic) IBOutlet UIView *ottLblView;
@property(nonatomic, strong)OttoCycleLabel *ottoLbl;
@property(nonatomic, strong)NSMutableArray *ottArr;
@property(nonatomic, strong)NSMutableArray *oilArr;
@property(nonatomic, strong)NSMutableArray *typeArr;
@property(nonatomic, strong)NSMutableArray *bannerArr;
@property(nonatomic, strong)NSString *oilTypeId;
@property(nonatomic, strong)NSString *sort;


@end

@implementation PetrolController


int kTopCenterViewTag = 1;
int kTopRightViewTag = 2;


- (void)viewDidLoad {
    self.leftButtonType = kNav_Left_Button_None;
    [super viewDidLoad];
    self.navTitle = @"加油";
    [self loadTopView];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    [self getOilType:@"10"];
    [self getBannerMsg];
}

-(void)loadData{
    [super loadData];
    [self.requestDic removeAllObjects];
    [self.requestDic setObject:[NSString stringWithFormat:@"%d", self.page] forKey:@"page"];
    [self.requestDic setObject:[LXUserDefault location].firstObject forKey:@"longitude"];
    [self.requestDic setObject:[LXUserDefault location].lastObject forKey:@"latitude"];
    if (self.oilTypeId) {
        [self.requestDic setObject:self.oilTypeId forKey:@"oilTypeId"];
    }
    [self.requestDic setObject:self.sort forKey:@"sort"];
//    油站列表
    [LXNetWork getDataWithParm:self.requestDic url:@"oilStation/getAllOilStation" successBlock:^(NSDictionary *dic) {
        [self.pTableView.mj_header endRefreshing];
        [self.pTableView.mj_footer endRefreshing];
        if ([dic[@"status"] intValue] == 200 ) {
            if (self.page == 1) {
                [self.pDataBase removeAllObjects];
                dispatch_async(kMainQueue, ^{
                    [self.pTableView setContentOffset:CGPointMake(0, 0) animated:NO];
                });
            }
            self.page++;
            NSArray *arr = (NSArray *)dic[@"data"];
            for (NSDictionary *data in arr) {
                StationItem *item =[StationItem mj_objectWithKeyValues:data];
                item.oilPrice = [[LXViewControllerManager shareManager] divided100:item.oilPrice];
                item.reducedPrice = [[LXViewControllerManager shareManager] divided100:item.reducedPrice];
                item.oilNowPrice = [[LXViewControllerManager shareManager] divided100:item.oilNowPrice];
                [self.pDataBase addObject:item];
            }
            if (arr.count > 0) {
                [self.pTableView reloadData];
            }
        }

    } errorBlock:^(NSError *error) {
        [self.pTableView.mj_header endRefreshing];
        [self.pTableView.mj_footer endRefreshing];
    }];
    
//    [self.oilArr removeAllObjects];
////    查询油品信息列表
//    [self getOilType:@"10"];
////    [self getOilType:@"20"];
//    [self getBannerMsg];
}


/**
 获取油号信息

 @param type 10 汽油 ； 20 柴油
 */
-(void)getOilType:(NSString *)type{
    [LXNetWork getDataWithParm:@{@"cateId":type} url:@"oilStation/getOilTypeListWithStatus" successBlock:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            NSArray *data = (NSArray *)dic[@"data"];
            for (NSDictionary *dataDic in data) {
                OilTypeItem *item = [OilTypeItem mj_objectWithKeyValues:dataDic];
                item.oilPrice = [[LXViewControllerManager shareManager] divided100:item.oilPrice];
                [self.oilArr addObject:item];
            }
            [self setPriceLblTextWithIndex:0];
        }
    } errorBlock:^(NSError *error) {
        
    }];
    
}

/**
 获取头部轮播数据
 */
-(void)getBannerMsg{
    [LXNetWork getDataWithParm:nil url:@"oilStation/getAllOilInfo" successBlock:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            [self.bannerArr removeAllObjects];
            NSArray *arr = (NSArray *)dic[@"data"];
            for (NSDictionary *dataDic in arr) {
                [self.bannerArr addObject:[OilBannerItem mj_objectWithKeyValues:dataDic]];
            }
            [self loadOttoCycleLabel];
        }
    } errorBlock:^(NSError *error) {
        
    }];
}

-(void)loadNewData{
    [super loadNewData];
    [self loadData];
}


-(void)reloadTableview{
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"PetrolTableCell" bundle:nil] forCellReuseIdentifier:@"PetrolTableCell"];
    [self headerRefresh];
    [self footerRefresh];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pDataBase.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak PetrolController *weakSelf = self;
    NSInteger row = indexPath.row;
    StationItem *item = self.pDataBase[row];
    PetrolTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PetrolTableCell"];
    cell.block = ^(NSInteger tag) {
        [weakSelf navActionWithTag:tag];
    };
    [cell setModel:item row:row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110*kEqualHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StationItem *item = self.pDataBase[indexPath.row];
    MakeOrderController *ctr = [[MakeOrderController alloc] init];
    ctr.hidesBottomBarWhenPushed  =YES;
    ctr.stationid = item.stationId;
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 头部视图约束
 */
-(void)loadTopView{
    self.otttLblH.constant = 30*kEqualHeight;
    self.topViewH.constant = 44*kEqualHeight;
    [self.view updateConstraints];
    [[LXViewControllerManager shareManager] fixFontWithView:self.priceBaseView];
    __weak PetrolController *weakSelf = self;
    CGRect center = self.topCenterView.frame;
    self.topCenterView = [LXButtonWithRotaingImg shareViewWithBtnTitle:@"全部油号"];
    self.topCenterView.frame = CGRectMake(kDeviceWidth/3.f, 0, kDeviceWidth/3.f, CGRectGetHeight(center));
    self.topCenterView.btn.tag = kTopCenterViewTag;
    self.topCenterView.block = ^(NSInteger tag) {
        [weakSelf showPopupMenuWithTag:tag];
    };
    [self.topView addSubview:self.topCenterView];
    
    
    self.topRightView = [LXButtonWithRotaingImg shareViewWithBtnTitle:@"距离最近"];
    self.topRightView.frame = CGRectMake(kDeviceWidth*2/3.f, 0, kDeviceWidth/3.f, CGRectGetHeight(center));
    self.topRightView.btn.tag = kTopRightViewTag;
    self.topRightView.block = ^(NSInteger tag) {
        [weakSelf showPopupMenuWithTag:tag];
    };
    [self.topView addSubview:self.topRightView];
//    角标旋转
    [[LXNotifyManager shareInstance] addTarget:self withKey:kkkHideYBPopView withBlock:^(NSDictionary *userInfo) {
        if (userInfo) {
            NSInteger tag = [userInfo[@"tag"] integerValue];
            if (tag == kTopRightViewTag) {
                [self.topRightView rotatingBehindImage];
            }else{
                [self.topCenterView rotatingBehindImage];
            }
        }
    }];
}

/**
 显示选择框

 @param tag 不同的选择框tag
 */
-(void)showPopupMenuWithTag:(NSInteger)tag{
    
    CGPoint point =CGPointMake(kDeviceWidth*5/6.f,CGRectGetMaxY(self.topView.frame) + (IPhoneXAbove?84:64));
    NSMutableArray *titleArr = [NSMutableArray array];
    if (tag == kTopCenterViewTag) {
        for (OilTypeItem *item in self.oilArr) {
            [titleArr addObject:item.oilType];
        }
        point = CGPointMake(kDeviceWidth/2.f, CGRectGetMaxY(self.topView.frame) + (IPhoneXAbove?84:64));
    }else if (tag == kTopRightViewTag){
        titleArr = [self.typeArr copy];
    }
    if (titleArr.count) {
        YBPopupMenu *menu = [YBPopupMenu showAtPoint:point titles:titleArr menuWidth:100 delegate:self tag:tag];
        menu.dismissNotify = YES;
    }
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if (ybPopupMenu.tag == kTopCenterViewTag) {
        OilTypeItem *item = self.oilArr[index];
        [self.topCenterView.btn setTitle:item.oilType forState:UIControlStateNormal];
        [self setPriceLblTextWithIndex:index];
        self.oilTypeId = item.oilTypeId;
        [self loadNewData];
    }else if (ybPopupMenu.tag == kTopRightViewTag){
        [self.topRightView.btn setTitle:self.typeArr[index] forState:UIControlStateNormal];
        self.sort = index == 1?@"2":@"1";
        [self loadNewData];
    }
}

-(void)setPriceLblTextWithIndex:(NSInteger)index{
    if (index >= self.oilArr.count) {
        return;
    }
    OilTypeItem *item = self.oilArr[index];
    self.priceLbl.text = [NSString stringWithFormat:@"%@ ￥%@/升", item.oilType, item.oilPrice];
}

/**
 付油费按钮实现

 @param sender nil
 */
- (IBAction)scanCodePayAction:(id)sender {
    [self pushToEditOrderController];
}

/**
 加载轮播label
 */
-(void)loadOttoCycleLabel{
    if (self.ottoLbl) {
        [self.ottoLbl removeFromSuperview];
        self.ottoLbl = nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (OilBannerItem *item in self.bannerArr) {
        [arr addObject:@[[NSString stringWithFormat:@"%@于%@分钟前，在%@", item.carId, item.minute, item.stationName], [NSString stringWithFormat:@"  节省%@元", item.discount]]];
    }
    OttoCycleLabel *label = [[OttoCycleLabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30*kEqualHeight) texts:arr colorArr:@[k_3_Color, kRedColor]];
    label.timeInterval = 0.5;
    label.backgroundColor = [UIColor clearColor];
    label.directionMode = DirectionTransitionFromTop;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12*kEqualHeight weight:UIFontWeightRegular];
    label.textColor = [UIColor blackColor];
    self.ottoLbl = label;
    [self.ottLblView addSubview:label];
    [label startCycling];
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.topCenterView.frame = CGRectMake(kDeviceWidth/3.f, 0, kDeviceWidth/3.f, 44*kEqualHeight);
        self.topRightView.frame = CGRectMake(kDeviceWidth*2/3.f, 0, kDeviceWidth/3.f, 44*kEqualHeight);
    });
    if (self.pDataBase.count == 0) {
        [self loadNewData];
    }
}


/**
 导航实现

 @param tag 位置
 */
-(void)navActionWithTag:(NSInteger )tag{
    StationItem *item = self.pDataBase[tag];
    [[LXViewControllerManager shareManager] navActionWithCtr:self lon:item.longitude lat:item.latitude name:item.name];
}


/**
 跳转到下订单页面
 */
-(void)pushToEditOrderController{
    if (![LXUserDefault userid]) {
        [[LXViewControllerManager shareManager] pushToLoginVCFromVC:self toRootVC:YES];
        return;
    }
    if (self.oilArr.count > 0) {
        EditOrderController *ctr = [[EditOrderController alloc] init];
        ctr.hidesBottomBarWhenPushed = YES;
        NSMutableArray *temp = [NSMutableArray array];
        for (OilTypeItem *item  in self.oilArr) {
            [temp addObject:item];
            if (temp.count == 3) {
                [ctr.pDataBase addObject:[temp copy]];
                [temp removeAllObjects];
            }
        }
        if (temp.count > 0) {
            [ctr.pDataBase addObject:[temp copy]];
        }
        [self.navigationController pushViewController:ctr animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSMutableArray *)ottArr{
    if (!_ottArr) {
        self.ottArr = [NSMutableArray array];
    }
    return _ottArr;
}

-(NSMutableArray *)oilArr{
    if (!_oilArr) {
        self.oilArr = [NSMutableArray array];
    }
    return _oilArr;
}

-(NSMutableArray *)typeArr{
    if (!_typeArr) {
        self.typeArr = [NSMutableArray arrayWithObjects:@"距离最近", @"综合最高", nil];
    }
    return _typeArr;
}

-(NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        self.bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

-(NSString *)sort{
    if (!_sort) {
        self.sort = @"1";
    }
    return _sort;
}

@end
