//
//  LXBaseController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/12.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXBaseController.h"
#import "UIImage+KKCategory.h"
#import <MJRefresh/MJRefresh.h>


#define kTagLeftArrowView 1  // 左边按钮箭头
#define kTagLeftLabelView 2  // 左边按钮标题

#define kNavRightButonOffset 16 // 导航条右边按钮向右偏移值
#define kNavRightButonTextOffset 3 // 导航条右边文字按钮向右偏移值
#define kNavLeftButonTextOffset 10 // 导航条左边文字按钮向左偏移值
#define kNavLeftLabelTextOffset 8 // 导航条左边文字按钮向左偏移值

#define kNavigationBarHighLightColor [UIColor colorWithRed:136.f/255.f green:136.f/255.f blue:136.f/255.f alpha:1.f]

@interface LXBaseController ()



@end

@implementation LXBaseController

-(instancetype)init{
    self = [super init];
    self.leftButtonType = kNav_Left_Button_Back;
    self.lHeaderHeight = 44;
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseBgColor;
    // Do any additional setup after loading the view.
    [self reloadTableview];
    
    if(self.leftButtonType == kNav_Left_Button_White || self.leftButtonType == kNav_Left_Button_Back){
        [self initNavigationBar];
        [self showBackButton];
    }else if (self.leftButtonType == kNav_Left_Button_None){
        [self initNavigationBar];
        self.navigationItem.hidesBackButton = YES;
    }else{
    }
    
}
/**
 初始化tableview
 */
-(void)reloadTableview{
    if (self.pTableView) {
        self.pTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.pTableView setSeparatorInset:UIEdgeInsetsZero];
        [self.pTableView setLayoutMargins:UIEdgeInsetsZero];
        self.pTableView.backgroundColor = BaseBgColor;
        if (@available(iOS 11.0, *)) {
            self.pTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

-(void)headerRefresh{
    if (self.pTableView) {
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        NSArray * arr = [UIImage gifImages:@"loading"];
        [header setImages:arr forState:MJRefreshStatePulling];
        [header setImages:arr forState:MJRefreshStateRefreshing];
        self.pTableView.mj_header = header;
    }
}

-(void)footerRefresh{
    if (self.pTableView) {
        MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        NSArray * arr = [UIImage gifImages:@"loading"];
        [footer setImages:arr forState:MJRefreshStatePulling];
        [footer setImages:arr forState:MJRefreshStateRefreshing];
        footer.stateLabel.hidden = YES;
        footer.refreshingTitleHidden = YES;
        self.pTableView.mj_footer = footer;
    }
}

/**
 网络请求
 */
-(void)loadData{
    
}

/**
 刷新数据
 */
-(void)loadNewData{
    self.page = 1;
    [self.pTableView.mj_footer endRefreshing];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.leftButtonType == kNav_hide) {
        if (!self.navigationController.navigationBar.hidden) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }else{
        if (self.navigationController.navigationBar.hidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    [self initNavigationBar];
    }

    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // 显示白色文字高亮状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:(self.leftButtonType == kNav_Left_Button_Back || self.leftButtonType == kNav_Left_Button_None)? UIStatusBarStyleLightContent:UIStatusBarStyleDefault];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [LXViewControllerManager shareManager].currentVC = self;
}


-(void)initNavigationBar{
    NSString *imgName = (self.leftButtonType == kNav_Left_Button_Back || self.leftButtonType == kNav_Left_Button_None)?@"navibar_bg":@"navibar_clear";
    UIImage *backgroundImage = [UIImage imageNamed:imgName];
    
    UINavigationBar* bar=self.navigationController.navigationBar;
    [bar setBackgroundImage:backgroundImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;// 半透明
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self setNavigationTitle];
}


-(void)setNavigationTitle{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont systemFontOfSize:20*kEqualHeight];// weight:0.1];
    titleLabel.textColor = (self.leftButtonType == kNav_Left_Button_Back || self.leftButtonType == kNav_Left_Button_None)?[UIColor whiteColor]:k_3_Color;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.navTitle;
    [self.navigationItem setTitleView:titleLabel];
}

-(void)showBackButton{
    [self showLeftButtonImage:self.leftImageName];
}



-(void)showLeftButtonImage:(NSString *)imageName{
    UIImage* normalImage = [UIImage imageNamed:imageName];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:normalImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    left.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:left] ;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}



-(void)showRightButtonImage:(NSString *)imageName space:(CGFloat)space color:(UIColor *)color{
    
    [self.navigationItem setRightBarButtonItems:nil];
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStyleDone target:self action:@selector(goRight:)];
    item.tintColor=color ? color: [UIColor whiteColor];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    
    flexSpacer.width = -6.f+space;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:flexSpacer,item, nil]];
}


-(void)showRightButtonTitle:(NSString *)title tintColor:(UIColor*)tintColor{
    if (!tintColor) {
        tintColor = (self.leftButtonType == kNav_Left_Button_Back || self.leftButtonType == kNav_Left_Button_None)?[UIColor whiteColor]:k_3_Color;
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(goRight:)];
    item.tintColor=tintColor;
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15*kEqualHeight],NSFontAttributeName, nil] forState:UIControlStateNormal];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    
    flexSpacer.width = 2;
    if (kDeviceWidth >= 414) {
        flexSpacer.width = -8.f;
    }else if (kDeviceWidth == 375){
        flexSpacer.width = -6.f;
    }
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:flexSpacer,item, nil]];
}





-(void)showLeftButtonTitle:(NSString *)title  tintColor:(UIColor*)tintColor{
    if (!tintColor) {
        tintColor = k_3_Color;
    }
    if (!title) {
        title  = @"";
    }
    UIImageView* leftView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_title"]];
    
    
    CGRect leftViewFrame=leftView.frame;
    leftViewFrame.origin.x+=-10.f;
    leftViewFrame.origin.y+=10;
    leftView.frame=leftViewFrame;

    CGFloat width = title.length * 17;
    leftView.tag=kTagLeftArrowView;
    UIButton* mainView=[UIButton buttonWithType:UIButtonTypeCustom];
    mainView.frame=CGRectMake(2, 0, width, 44);
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(kNavLeftLabelTextOffset, -1, width, 44)];
    label.tag=kTagLeftLabelView;
    label.text=title;
    label.font = [UIFont systemFontOfSize:15*kEqualHeight];
    label.textColor= tintColor;
    CGRect rectLabel=label.frame;
    rectLabel.origin.x+=2.f;
    label.frame=rectLabel;
    
    
    CGRect mainFrame=mainView.frame;
    mainFrame.size.width=label.frame.size.width;
    mainView.frame=mainFrame;
    
    [mainView addSubview:label];
    [mainView addSubview:leftView];
    
    [mainView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithCustomView:mainView];
    left1.tintColor = [UIColor whiteColor];
    UIBarButtonItem *left2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    left2.width = 5;
    self.navigationItem.leftBarButtonItems =@[left2, left1];
}



-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)goRight:(id)sender{
}

-(void)setLeftButtonType:(NavLeftButtonType)leftButtonType{
    switch (leftButtonType) {
        case kNav_Left_Button_Back:
            self.leftImageName = @"arrowWhite";
            break;
        case kNav_Left_Button_White:
            self.leftImageName = @"arrowBlack";
            break;
        default:
            break;
    }
    _leftButtonType = leftButtonType;
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LXTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseCellID"];
    if (!cell) {
        cell = [[LXTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"baseCellID"];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSMutableArray *)pDataBase{
    if (!_pDataBase) {
        self.pDataBase = [NSMutableArray array];
    }
    return _pDataBase;
}

-(int)page{
    if (_page <= 0) {
        self.page = 1;
    }
    return _page;
}

-(NSMutableDictionary *)requestDic{
    if (!_requestDic) {
        self.requestDic = [NSMutableDictionary dictionary];
    }
    return _requestDic;
}

-(void)tap:(UITapGestureRecognizer*)sender{
    [self.view endEditing:YES];
}

-(void)dealloc{
    NSLog(@"%@", NSStringFromClass([self class]));
}

@end
