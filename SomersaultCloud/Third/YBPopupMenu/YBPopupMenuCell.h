//
//  YBPopupMenuCell.h
//  YBPopupMenuDemo
//
//  Created by mac book air on 2017/7/11.
//  Copyright © 2017年 LYB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBPopupMenuCell : UITableViewCell
@property (nonatomic, assign) BOOL isShowSeparator;
@property (nonatomic, strong) UIColor * separatorColor;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UILabel *lbl;


@end


