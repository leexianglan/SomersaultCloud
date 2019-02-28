//
//  MineShareView.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2019/1/12.
//  Copyright © 2019年 李相兰. All rights reserved.
//

#import "MineShareView.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>

@interface MineShareView()<MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *weChatViews;

@end

@implementation MineShareView

+(MineShareView*)share{
    MineShareView *view = [[NSBundle mainBundle] loadNibNamed:@"MineShareView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, -20, kDeviceWidth, kDeviceHeight+20);
    return view;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    if (![WXApi isWXAppInstalled]) {
        for (UIView *view in self.weChatViews) {
            view.hidden = YES;
        }
    }
}
//点击事件
- (IBAction)clickAction:(UIButton *)sender {
    if (sender.tag == 0) {//微信好友
        [self sendToWeChat:WXSceneSession];
    }else if (sender.tag == 1){//短信
        [self showSMSComposer];
    }else if (sender.tag == 2){//朋友圈
        [self sendToWeChat:WXSceneTimeline];
    }
    if (sender.tag != 1) {
        [self removeFromSuperview];
    }else{
        self.hidden = YES;
    }
}

//分享到微信
-(void)sendToWeChat:(int)tag{
//    https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317332&token=f22d5f28114cccff13c15a7eb235d670fd3ea3d5&lang=zh_CN
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"https://www.baidu.com";
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"筋斗云";
    message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"logo"]);
    message.description = @"这就是tmd筋斗云";
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.text = @"****这是筋斗云";
    req.bText =  NO;
    req.message = message;
    req.scene = tag;
    [WXApi sendReq:req];
}



//通过短信分享
-(void)showSMSComposer{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc]init];
        picker.messageComposeDelegate =self;
        NSString *smsBody =[NSString stringWithFormat:@"我分享了筋斗云，地址是%@",@"https://www.baidu.com"] ;
        picker.body=smsBody;
        [[LXViewControllerManager shareManager].currentVC presentViewController:picker animated:YES completion:^{
        }];
    }else{
        [[LXViewControllerManager shareManager] showHUD:@"该设备不支持发送短信"];
        [self removeFromSuperview];
    }
}
    
// 短信回调
- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result{
    
    [[LXViewControllerManager shareManager].currentVC dismissViewControllerAnimated:YES completion:^{}];
    NSString *string = nil;
    if(result ==MessageComposeResultCancelled)
    string = @"取消短信邀请";
    else if(result ==MessageComposeResultSent)
        string = @"邀请短信发送成功";
    else
        string = @"邀请短信发送失败";
    
    [[LXViewControllerManager shareManager] showHUD:string];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
