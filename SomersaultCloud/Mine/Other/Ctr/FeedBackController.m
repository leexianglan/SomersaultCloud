//
//  FeedBackController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "FeedBackController.h"

@interface FeedBackController ()<UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *placeHolder;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, assign)CGRect rect;

@end

@implementation FeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"意见反馈";
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.scrollEnabled = YES;
    [[LXViewControllerManager shareManager] fixFontWithView:self.scrollView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.rect = self.view.frame;
    self.scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceWidth ==320? 550:kDeviceHeight-(IPhoneXAbove?84:64));
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""] && ![text isEqualToString:@"\n"]){
        self.placeHolder.hidden = YES;
    }
    
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        self.placeHolder.hidden = NO;
    }
    
    return YES;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string && [string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

/**
 提交数据

 @param sender nil
 */
- (IBAction)saveAction:(id)sender {
    if ([[LXViewControllerManager shareManager] checkEmptyText:self.txtView.text msg:@"反馈意见"] || [[LXViewControllerManager shareManager] checkEmptyText:self.txtField.text msg:@"手机号"]) {
        return;
    }
    if (![self.txtField.text isPhoneNumber]) {
        [[LXViewControllerManager shareManager] showHUD:@"请输入正确的手机号"];
        return;
    }
    [self.requestDic setObject:self.txtField.text forKey:@"contactNum"];
    [self.requestDic setObject:self.txtView.text forKey:@"suggestContent"];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork nativePost:@"user/insertSuggest" bodyparam:self.requestDic success:^(NSDictionary *dic) {
        if (dic[@"status"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [[LXViewControllerManager shareManager] showHUD:dic[@"msg"]];
    } faile:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    } contentType:nil];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)keyboardWillShow:(NSNotification *)sender{
    NSDictionary *userInfo = [sender userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.view.frame = CGRectMake(0, CGRectGetMinY(self.rect), kDeviceWidth, CGRectGetHeight(self.rect) - CGRectGetHeight(keyboardRect));
    self.scrollView.frame = self.view.bounds;
    [self.scrollView setContentOffset:CGPointMake(0, 210) animated:YES];

}

-(void)keyboardDisappear:(NSNotification *)sender{
    self.view.frame = self.rect;
}


-(void)tapAction:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
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
