//
//  LoginViewController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2019/1/8.
//  Copyright © 2019年 李相兰. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *loginLine;
@property (weak, nonatomic) IBOutlet UIImageView *registerLine;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeViewH;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineViews;
@property (weak, nonatomic) IBOutlet UITextField *pwTxt;
@property (weak, nonatomic) IBOutlet UITextField *centerTxt;
@property (weak, nonatomic) IBOutlet UIImageView *centerImg;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewH;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *getCodeLbl;
@property(nonatomic, assign)int endDate;
@property(nonatomic, strong)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIView *btnsBaseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnsBaseViewWTH;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.leftButtonType = kNav_hide;
    [super viewDidLoad];
    [[LXViewControllerManager shareManager] fixFontWithView:self.view];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    for (UIView *view in self.lineViews) {
        view.layer.borderColor = Color1(210).CGColor;
        view.layer.borderWidth = 0.7;
    }
    if (self.isForget) {
        [self changeType:self.registerBtn];
        [self resetForgetView];
    }else{
        [self changeType:self.loginBtn];
    }
    [self showLeftButtonImage:@""];
    [self.pwTxt addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string && [string isEqualToString:@"\n"]) {
        if (textField.tag == 0) {
            [self.centerTxt becomeFirstResponder];
        }else if (textField.tag == 1){
            [self.pwTxt becomeFirstResponder];
        }else{
            [self.view endEditing:YES];
        }
    }
    return YES;
}

-(void)textLengthChange:(UITextField*)sender{
    if (sender.tag == 2) {
        [self maxLegth:16 sender:sender];
    }
}

-(void)maxLegth:(int)kMaxLength sender:(UITextField *)sender{
    NSString *toBeString = sender.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [sender markedTextRange];
        //获取高亮部分
        UITextPosition *position = [sender positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                sender.text = [toBeString substringToIndex:kMaxLength];
                [[LXViewControllerManager shareManager] showHUD:[NSString stringWithFormat:@"密码最多%d位", kMaxLength]];
            }
        }
        
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            sender.text = [toBeString substringToIndex:kMaxLength];
            [[LXViewControllerManager shareManager] showHUD:[NSString stringWithFormat:@"密码最多%d位", kMaxLength]];
        }
    }
}
//发送验证码
- (IBAction)sendCode:(id)sender {
    [self.view endEditing:YES];
    if ([self.phoneTxt.text isPhoneNumber]) {
        [[LXViewControllerManager shareManager] showHUDOnly];
        [LXNetWork getDataWithParm:@{@"phone":self.phoneTxt.text} url:@"user/sendMessage" successBlock:^(NSDictionary *dic) {
            [[LXViewControllerManager shareManager] hideHUD];
            if ([dic[@"status"] intValue] == 200) {
                self.phoneTxt.enabled = NO;
                [self beginTimer];
            }
            [[LXViewControllerManager shareManager] showHUD:dic[@"message"]];
        } errorBlock:^(NSError *error) {
            [[LXViewControllerManager shareManager] hideHUD];
        }];
    }else{
        [[LXViewControllerManager shareManager] showHUD:@"请输入正确的手机号"];
    }
}

-(void)beginTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.getCodeLbl.hidden = NO;
    self.getCodeBtn.enabled = NO;
    [self.getCodeBtn setTitle:@"" forState:UIControlStateNormal];
    self.endDate = 61;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}
-(void)timerAction{
    self.endDate --;
    if (self.endDate > 0) {
        self.getCodeLbl.text = [NSString stringWithFormat:@"重获验证码(%d)", self.endDate];
    }else{
        self.getCodeLbl.hidden = YES;
        [self.getCodeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
        self.getCodeBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

//注册||登录切换
- (IBAction)changeType:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [self.view endEditing:YES];
    sender.selected = YES;
    if (sender.tag == 0) {// 注册
        [self resetView:NO];
        self.loginBtn.selected = NO;
    }else{
        // 登录
        self.registerBtn.selected = NO;
        [self resetView:YES];
    }
    [self resetTxts];
}
//设置注册 登录页面
-(void)resetView:(BOOL)login{
    self.loginLine.hidden = !login;
    self.registerLine.hidden = login;
    self.centerImg.image = [UIImage imageNamed:login?@"user":@"message"];
    self.baseViewH.constant = (!login?370:345)*kEqualHeight;
    self.codeViewH.constant = (login?0:70)*kEqualHeight;
    self.codeView.hidden = login;
    self.centerTxt.placeholder = login?@"请输入您的用户名":@"请输入您的验证码";
    [self.actionBtn setTitle:login?@"登录":@"注册" forState:UIControlStateNormal];
    self.forgetBtn.hidden = !login;
}
// 忘记密码页面布局
-(void)resetForgetView{
    self.btnsBaseViewWTH.constant = CGFLOAT_MAX;
    self.btnsBaseView.hidden = YES;
     self.baseViewH.constant = 305*kEqualHeight;
    self.pwTxt.placeholder = @"请重设密码";
    [self.actionBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.view updateConstraints];
}
// 输入框初始化
-(void)resetTxts{
    self.phoneTxt.text = @"";
    self.centerTxt.text = @"";
    self.pwTxt.text = @"";
    self.phoneTxt.enabled = YES;
    [self.getCodeBtn setTitle:@"获取验证吗" forState:UIControlStateNormal];
    self.getCodeLbl.hidden = YES;
}
// 完成 || 注册 || 登录 按钮实现
- (IBAction)regAndLoginAction:(UIButton *)sender {
    [self.view endEditing:YES];

    if (self.loginBtn.selected) {// 登录
        if (![self.centerTxt.text isPhoneNumber]) {
            [[LXViewControllerManager shareManager] showHUD:@"请输入正确的手机号"];
            return;
        }
        if (self.pwTxt.text.length < 6) {
            [[LXViewControllerManager shareManager] showHUD:@"密码不能少于6位"];
            return;
        }
        [self.requestDic removeAllObjects];
        [self.requestDic setObject:self.centerTxt.text forKey:@"mobilePhone"];
        [self.requestDic setObject:self.pwTxt.text forKey:@"password"];
        [LXNetWork nativePost:@"/user/mobilePhoneLogin" bodyparam:self.requestDic success:^(NSDictionary *dic) {
            [[LXViewControllerManager shareManager] hideHUD];
            if ([dic[@"status"] intValue] == 200) {
                [[LXViewControllerManager shareManager] showHUD:@"登录成功"];
                NSDictionary *data = dic[@"data"];
                UserItem *user = [UserItem mj_objectWithKeyValues:data];
                [LXUserDefault saveUserItem:user];
                [LXUserDefault saveUserid:user.userId];
                [LXUserDefault saveOpenid:user.openId];
                [[LXNotifyManager shareInstance] postNotifyKey:kRefreshMineVC];
                [self goBack:nil];
            }
        } faile:^(NSError *error) {
            [[LXViewControllerManager shareManager] hideHUD];
        } contentType:@"application/json;text/html;charset=utf-8"];

    }else{// 注册||找回密码
        if (![self.phoneTxt.text isPhoneNumber]) {
            [[LXViewControllerManager shareManager] showHUD:@"请输入正确的手机号"];
            return;
        }
        if (self.centerTxt.text.length <= 0) {
            [[LXViewControllerManager shareManager] showHUD:@"验证码不能为空"];
            return;
        }
        if (self.pwTxt.text.length < 6) {
            [[LXViewControllerManager shareManager] showHUD:@"密码不能少于6位"];
            return;
        }
        [self.requestDic removeAllObjects];
        [self.requestDic setObject:self.phoneTxt.text forKey:@"mobilePhone"];
        [self.requestDic setObject:self.centerTxt.text forKey:@"codeMsg"];
        [self.requestDic setObject:self.pwTxt.text forKey:@"password"];
        
        NSString *url = @"/user/mobilePhonePwdReset";
        if (self.isForget) {// 找回密码
        }else{ //            注册
            url = @"/user/mobilePhoneRegister";
        }

        [[LXViewControllerManager shareManager] showHUDOnly];
        [LXNetWork nativePost:url bodyparam:self.requestDic success:^(NSDictionary *dic) {
            [[LXViewControllerManager shareManager] hideHUD];
            if ([dic[@"status"] intValue] == 200) {
                if (self.isForget) {
                    [[LXViewControllerManager shareManager] showHUD:@"找回密码成功，去登录吧"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [[LXViewControllerManager shareManager] showHUD:@"注册成功，去登录吧"];
                    [self changeType:self.loginBtn];
                }
            }else{
                [[LXViewControllerManager shareManager] showHUD:dic[@"msg"]];
            }
        } faile:^(NSError *error) {
            [[LXViewControllerManager shareManager] hideHUD];
        } contentType:nil];
    }
}
//忘记密码实现
- (IBAction)forgetAction:(id)sender {
    LoginViewController *ctr = [[LoginViewController alloc] init];
    ctr.isForget = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)keyboardWillShow:(NSNotification *)sender{
    NSDictionary *userInfo = [sender userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat  y = kDeviceHeight - (CGRectGetMinY(self.baseView.frame) + CGRectGetHeight(self.baseView.frame));
    if (y < CGRectGetHeight(keyboardRect)) {
        self.view.frame = CGRectMake( 0, y - CGRectGetHeight(keyboardRect), kDeviceWidth, kDeviceHeight+CGRectGetHeight(keyboardRect));
    }
    
}

-(void)keyboardDisappear:(NSNotification *)sender{
    self.view.frame = [UIScreen mainScreen].bounds;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [LXViewControllerManager shareManager].isLoginVC = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (IBAction)back:(id)sender {
    [self goBack:nil];
}

-(void)goBack:(id)sender{
    if (self.toRootVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
