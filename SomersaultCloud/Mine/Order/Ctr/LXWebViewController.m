//
//  LXWebViewController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/11/19.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXWebViewController.h"

@interface LXWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation LXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadWebWithData:self.data];
    if (@available(iOS 11.0, *)) {
        _webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)loadWebWithData:(NSData*)data{
    [self.webview loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
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
