//
//  LXBaseController.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/12.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kNav_Left_Button_Back = 1,      // 黑
    kNav_Left_Button_White = 2,    // 白
    kNav_Left_Button_None = 3,       // 无
    kNav_hide = 4                           // 无导航栏
} NavLeftButtonType ;


@interface LXBaseController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,assign)NavLeftButtonType leftButtonType;
@property(nonatomic, strong)NSString *navTitle;
@property(nonatomic, strong)NSString *leftImageName;
@property(nonatomic, assign)int page;
@property(nonatomic, strong)NSMutableDictionary *requestDic;

@property(nonatomic,assign)IBOutlet UITableView* pTableView;

@property(nonatomic, strong)NSMutableArray *pDataBase;
@property(nonatomic, assign)CGFloat lHeaderHeight;

-(void)reloadTableview;
-(void)showLeftButtonImage:(NSString *)imageName;
-(void)showLeftButtonTitle:(NSString *)title tintColor:(UIColor*)tintColor;
-(void)showRightButtonImage:(NSString *)imageName space:(CGFloat)space color:(UIColor *)color;
-(void)showRightButtonTitle:(NSString *)title tintColor:(UIColor*)tintColor;

-(void)loadNewData;
-(void)loadData;
-(void)footerRefresh;
-(void)headerRefresh;

-(IBAction)goBack:(id)sender;
-(IBAction)goRight:(id)sender;
@end
