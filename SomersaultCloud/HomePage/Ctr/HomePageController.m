//
//  HomePageController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/14.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "HomePageController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol HomePageCtrJSExport<JSExport>

@end

@interface HomePageController ()<UIWebViewDelegate, HomePageCtrJSExport>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation HomePageController

- (void)viewDidLoad {
    self.leftButtonType = kNav_hide;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.url = [NSString stringWithFormat:@"%@/views/mall/mall.html", host];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url ? self.url : @"https://www.baidu.com"]]];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //    [webView.scrollView.mj_header endRefreshing];
    NSString *url = [webView.request.URL absoluteString];
    
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    context[@"Interface"] = self;
//    [context evaluateScript:@"getTokens()"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = [request.URL absoluteString];
    
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    [webView.scrollView.mj_header endRefreshing];
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
- (IBAction)back:(id)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}
- (IBAction)goShop:(id)sender {
    HomePageController *ctr = [[HomePageController alloc] init];
    ctr.url = [NSString stringWithFormat:@"%@/views/mall/mall.html", host];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}


@end
