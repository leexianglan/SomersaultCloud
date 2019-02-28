//
//  EditAddressCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "EditAddressCell.h"

@interface EditAddressCell ()<UITextFieldDelegate>

@end

@implementation EditAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.txtField.delegate = self;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string && [string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    self.txtField.text = @"";
}

@end
