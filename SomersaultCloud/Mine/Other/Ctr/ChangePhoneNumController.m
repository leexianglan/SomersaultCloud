//
//  ChangePhoneNumController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "ChangePhoneNumController.h"

@interface ChangePhoneNumController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTxtF;
@property (weak, nonatomic) IBOutlet UITextField *codeTxtF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *remainLbl;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)int remainNum;
@property(nonatomic, strong)NSString *phone;


@end

@implementation ChangePhoneNumController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"更换手机号";
    // Do any additional setup after loading the view from its nib.
    self.getCodeBtn.layer.borderColor = k_6_Color.CGColor;
    [self.codeTxtF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [[LXViewControllerManager shareManager] fixFontWithView:self.view];
}




-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string && [string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}


-(void)textFieldChanged:(UITextView *)sender{
    self.changeBtn.enabled = sender.text.length > 3;
}


/**
 获取验证码

 @param sender <#sender description#>
 */
- (IBAction)getCodeAction:(UIButton *)sender {
    if ([self.phoneTxtF.text isPhoneNumber]) {
        [self.view endEditing:YES];
        self.phone = self.phoneTxtF.text;
        [self sendCode];
    }else{
        [[LXViewControllerManager shareManager] showHUD:@"请输入正确的手机号"];
    }
}

-(void)sendCode{
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork getDataWithParm:@{@"phone":self.phoneTxtF.text} url:@"user/sendMessage" successBlock:^(NSDictionary *dic) {
        [[LXViewControllerManager shareManager] hideHUD];
        if ([dic[@"status"] intValue] ==200) {
            NSLog(@"%@", dic[@"data"]);
            [self setWaitTime];
        }
        [[LXViewControllerManager shareManager] showHUD:dic[@"msg"]];
    } errorBlock:^(NSError *error) {
        
    }];
}

/**
 开始等待
 */
-(void)setWaitTime{
    self.getCodeBtn.hidden = YES;
    self.remainNum = 60;
    self.remainLbl.hidden = NO;
    [self.getCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)timerAction:(NSTimer *)sender{
    if (self.remainNum > 0) {
        self.remainLbl.text = [NSString stringWithFormat:@"%dS", self.remainNum];
        self.remainNum --;
    }else{
        self.remainLbl.hidden = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.getCodeBtn.hidden = NO;
    }
}



/**
 到协议页面

 @param sender <#sender description#>
 */
- (IBAction)goToProtocol:(id)sender {
}

/**
 更换手机号实现

 @param sender nil
 */
- (IBAction)changeAction:(id)sender {
    if (![self.phone isPhoneNumber]) {
        
        return;
    }
    [self.requestDic removeAllObjects];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [self.requestDic setObject:self.phone forKey:@"phone"];
    [self.requestDic setObject:self.codeTxtF.text forKey:@"vcode"];
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork postDataWithParm:self.requestDic url:@"user/bindPhone" successBlock:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            [[LXNotifyManager shareInstance] postNotifyKey:kRefreshUserInfo];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [[LXViewControllerManager shareManager] showHUD:dic[@"msg"]];
    } errorBlock:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
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

@end
