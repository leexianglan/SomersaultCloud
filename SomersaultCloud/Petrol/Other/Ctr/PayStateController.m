//
//  PayStateController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PayStateController.h"
#import "OrderUnPayController.h"
#import "PetOrderController.h"

@interface PayStateController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *topStateLbl;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *preferLbl;
@property (weak, nonatomic) IBOutlet UILabel *douLbl;
@property (weak, nonatomic) IBOutlet UILabel *hintAddPetLbl;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeViewH;
@property (weak, nonatomic) IBOutlet LXButton *btn1;
@property (weak, nonatomic) IBOutlet LXButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *hintCodeLbl;



@end

@implementation PayStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = self.success ? @"支付成功":@"支付失败";
    // Do any additional setup after loading the view from its nib.
    [self resetSubViews];
    [[LXViewControllerManager shareManager] fixFontWithView:self.scrollView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)resetSubViews{
    if (!self.success) {
        self.topStateLbl.text = @"支付失败！请重新支付";
        self.stateImgView.image = [UIImage imageNamed:@"zhifushibai_icon_shibai"];
        self.stateLbl.text = @"支付失败";
        self.codeViewH.constant = 10*kEqualHeight;
        [self.codeView updateConstraints];
        self.hintAddPetLbl.hidden = YES;
        self.hintCodeLbl.text = @"";
        [self.btn2 setBackgroundColor:kRedColor];
        [self.btn2 setTitle:@"重新支付" forState:UIControlStateNormal];
        [self.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.btn2.layer.borderColor = kRedColor.CGColor;
        dispatch_async(kMainQueue, ^{
            self.codeImgView.image = [[LXViewControllerManager shareManager] createCodeImgWithText:@"逗你呢" withSize:140];
        });
    }
    self.scrollView.contentSize = CGSizeMake(kDeviceWidth, 667);
    FlatLineDash *line = [[FlatLineDash alloc] initWithFrame:CGRectMake(15, 15, kDeviceWidth-30, 1)];
    [self.lineView addSubview:line];
    self.btn1.layer.borderColor = k_6_Color.CGColor;
    self.btn2.layer.borderColor = kRedColor.CGColor;
    [[LXViewControllerManager shareManager] setMutableAttributedStringLbl:self.preferLbl strArr:@[@"节省金额：     ", @"-"] colorArr:@[k_6_Color, kRedColor]];
    self.douLbl.text = @"-";
}


- (IBAction)btnAction:(UIButton *)sender {
    if (sender.tag == 0) {
        // 查看订单
        [self pushToPetOrderCtr];
    }else{
        if (self.success) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            // 重新支付
            [self pushToOrderUnPayController];
        }
    }
}

/**
 跳转到订单页面
 */
-(void)pushToPetOrderCtr{
    PetOrderController *ctr = [[PetOrderController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}

/**
 订单未完成页面
 */
-(void)pushToOrderUnPayController{
    OrderUnPayController *ctr = [[OrderUnPayController alloc] init];
    ctr.orderid = self.orderid;
    [self.navigationController pushViewController:ctr animated:YES];
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
