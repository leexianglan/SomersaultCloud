//
//  MinePeaController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MinePeaController.h"
#import "QHNavSliderMenu.h"
#import "PeaBaseController.h"

@interface MinePeaController ()<QHNavSliderMenuDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *peaNumLbl;
@property (weak, nonatomic) IBOutlet UIView *baseView;


@property(nonatomic, strong)QHNavSliderMenu *navSliderMenu;
@property(nonatomic, strong)NSMutableDictionary  *listVCQueue;
@property(nonatomic, strong)UIScrollView *contentScrollView;
@property(nonatomic, assign)int menuCount; //total
@property(nonatomic, strong)NSArray *dataSource;

@end

@implementation MinePeaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的金豆";
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [[LXViewControllerManager shareManager] fixFontWithView:self.baseView];
    UserItem *item = [LXUserDefault userItem];
    if (item.userHeader) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.userHeader] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    self.peaNumLbl.text = item.userBeans;
    self.detailLbl.text = item.mobilePhone;
    self.titleLbl.text = item.wechat;
}


/**
加载分页视图
 */
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
        
        
        self.navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:CGRectMake(0, 128*kEqualHeight- 10, kDeviceHeight, 44*kEqualHeight) andStyleModel:model andDelegate:self showType:QHNavSliderMenuTypeTitleOnly];
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
            
            PeaBaseController *orderCtr = [[PeaBaseController alloc] init];
            orderCtr.type = [self getPeaType:index];
            [self addChildViewController:orderCtr];
            orderCtr.view.frame = CGRectMake( index*kDeviceWidth, 0, kDeviceWidth, kDeviceHeight - self.navSliderMenu.bottom);
            [self.contentScrollView addSubview:orderCtr.view];
            [self.listVCQueue setObject:orderCtr forKey:@(index)];
        }
        
    });
}

-(PeaType)getPeaType:(NSInteger)index{
    PeaType type = peaGetType;
    if (index == 0) {
        type = peaGetType;
    }else if (index == 1){
        type = peaCusType;
    }else{
        type = peaAllType;
    }
    return type;
}

-(NSArray *)dataSource{
    return @[@"金豆获取", @"金豆消费", @"全部"];
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
