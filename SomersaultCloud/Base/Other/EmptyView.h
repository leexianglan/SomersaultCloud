//
//  EmptyView.h
//
//
//  Created by 李相兰 on 2018/4/18.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

+(instancetype)shareView;

//
@end

// 
