//
//  MyCouponsController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/29.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MyCouponsController.h"
#import "QHNavSliderMenu.h"
#import "CouponsBaseController.h"

@interface MyCouponsController ()<QHNavSliderMenuDelegate, UIScrollViewDelegate>


@property(nonatomic, strong)QHNavSliderMenu *navSliderMenu;
@property(nonatomic, strong)NSMutableDictionary  *listVCQueue;
@property(nonatomic, strong)UIScrollView *contentScrollView;
@property(nonatomic, assign)int menuCount; //total
@property(nonatomic, strong)NSArray *dataSource;

@end

@implementation MyCouponsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的券";
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)initView {
    
    if (!self.navSliderMenu) {
        
        [self.listVCQueue removeAllObjects];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
        
        self.menuCount = (int)self.dataSource.count;
        model.menuTitles                   = [self.dataSource copy];
        model.sliderMenuTextColorForNormal = k_6_Color;
        model.sliderMenuTextColorForSelect = kRedColor;
        model.titleLableFont               = [UIFont fontWithName:@"PingFangSC-Medium" size:14*kEqualHeight];
        model.menuWidth = kDeviceWidth/3.f;
        
        
        self.navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:CGRectMake(0, 0, kDeviceHeight, 44*kEqualHeight) andStyleModel:model andDelegate:self showType:QHNavSliderMenuTypeTitleOnly];
        self.navSliderMenu.backgroundColor =[UIColor whiteColor] ;
        [self.view addSubview:self.navSliderMenu];
        
        
        
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navSliderMenu.bottom, screenWidth, screenHeight-self.navSliderMenu.bottom)];
        self.contentScrollView.backgroundColor = BaseBgColor;
        self.contentScrollView.contentSize = (CGSize){screenWidth*self.menuCount,0};
        
        self.contentScrollView.pagingEnabled = YES;
        self.contentScrollView.delegate      = self;
        self.contentScrollView.scrollsToTop  = NO;
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.contentScrollView];
        
        [self addListVCWithIndex:0];
    }
}


#pragma mark -QHNavSliderMenuDelegate
- (void)navSliderMenuDidSelectAtRow:(NSInteger)row {
    //让scrollview滚到相应的位置
    [self.contentScrollView setContentOffset:CGPointMake(row*screenWidth, self.contentScrollView.contentOffset.y)  animated:NO];
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x;
    if (x < -screenWidth/2.f) {
        x = 0;
    }
    
    int index = (int)(x / screenWidth);
    if (index < 0) {
        index = 0;
    }
    [self.navSliderMenu selectAtRow:(int)((x+screenWidth/2.f)/screenWidth) andDelegate:NO];
    
    [self addListVCWithIndex:index];
    
    
}

#pragma mark -addVC
//  异步加载视图
- (void)addListVCWithIndex:(NSInteger)index {
    if (!self.listVCQueue) {
        self.listVCQueue=[[NSMutableDictionary alloc] init];
    }
    if (index<0||index>=self.menuCount) {
        return;
    }
    //根据页数添加相对应的视图 并存入数组
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![self.listVCQueue objectForKey:@(index)]) {
            
            CouponsBaseController *ctr = [[CouponsBaseController alloc] init];
            ctr.type = [self getCouposType:index];
            [self addChildViewController:ctr];
            ctr.view.frame = CGRectMake( index*kDeviceWidth, 0, kDeviceWidth, kDeviceHeight - self.navSliderMenu.bottom);
            [self.contentScrollView addSubview:ctr.view];
            [self.listVCQueue setObject:ctr forKey:@(index)];
        }
        
    });
}

-(CouponsType)getCouposType:(NSInteger)index{
    CouponsType type = noUsedCouponsType;
    if (index == 0) {
    }else if (index == 1){
        type = usedCouponsType;
    }else{
        type = outTimeCouponsType;
    }
    return type;
}

-(NSArray *)dataSource{
    return @[@"未使用", @"使用记录", @"已过期"];
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
