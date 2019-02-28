//
//  MyNewsContentController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/27.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MyNewsContentController.h"
#import "MyNewsController.h"

@interface MyNewsContentController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;
@property (weak, nonatomic) IBOutlet UIButton *eventBtn;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewH;
@property(nonatomic, assign)NSInteger type;

@property(nonatomic, strong)UIScrollView *contentScrollView;
@property(nonatomic, strong)NSMutableDictionary *listVCQueue;

@end

@implementation MyNewsContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的消息";
    // Do any additional setup after loading the view from its nib.
    self.baseViewH.constant = 37*kEqualHeight;
    [self.view updateConstraints];
    [self initView];
    [[LXViewControllerManager shareManager] fixFontWithView:self.baseView];
}


-(void)initView{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.noticeBtn.bounds)+10, kDeviceWidth, kDeviceHeight-CGRectGetHeight(self.noticeBtn.bounds)-10)];
    self.contentScrollView.backgroundColor = BaseBgColor;
    self.contentScrollView.contentSize = (CGSize){kDeviceWidth*2,0};
    
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate      = self;
    self.contentScrollView.scrollsToTop  = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    
    [self addListVCWithIndex:0];
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x;
    if (x < -kDeviceWidth/2.f) {
        x = 0;
    }
    
    int index = (int)(x / kDeviceWidth);
    if (index < 0) {
        index = 0;
    }
    if (index) {
        [self typeBtnAction:self.eventBtn];
    }else{
        [self typeBtnAction:self.noticeBtn];
    }
    [self addListVCWithIndex:index];
    
    
}

#pragma mark -addVC
//  异步加载视图
- (void)addListVCWithIndex:(NSInteger)index {
    if (!self.listVCQueue) {
        self.listVCQueue=[[NSMutableDictionary alloc] init];
    }
    if (index<0||index>=2) {
        return;
    }
    //根据页数添加相对应的视图 并存入数组
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![self.listVCQueue objectForKey:@(index)]) {
            
            MyNewsController *orderCtr = [[MyNewsController alloc] init];
            orderCtr.type = index?eventType:newsType;
            [self addChildViewController:orderCtr];
            orderCtr.view.frame = CGRectMake( index*kDeviceWidth, 0, kDeviceWidth, kDeviceHeight - CGRectGetHeight(self.noticeBtn.bounds)-10);
            [self.contentScrollView addSubview:orderCtr.view];
            [self.listVCQueue setObject:orderCtr forKey:@(index)];
        }
        
    });
}



- (IBAction)typeBtnAction:(UIButton *)sender {
    if (!sender.selected) {
        self.type = sender.tag;
        sender.selected = YES;
        if (self.type) {
            self.noticeBtn.selected = NO;
            [self.contentScrollView setContentOffset:CGPointMake(kDeviceWidth, 0) animated:NO];
        }else{
            self.eventBtn.selected = NO;
            [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
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
