//
//  MakeOrderMoneyCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/17.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MakeOrderMoneyCell.h"

@interface MakeOrderMoneyCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end

@implementation MakeOrderMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];

//    [self.txtField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    self.txtField.delegate = self;
    // Initialization code
    self.baseView.layer.borderColor = k_9_Color.CGColor;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string && [string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.block) {
        self.block(textField.text);
    }
}

-(void)textLengthChange:(UITextField *)sender{
    if (self.block) {
        self.block(sender.text);
    }
    [self setMoneyLblTextWithMoney:sender.text];
}

-(void)setMoneyLblTextWithMoney:(NSString *)money {
    self.moneyLbl.text = money;
//    money = [NSString stringWithFormat:@"￥%@ ", money];
//    preferential = [NSString stringWithFormat:@"优惠 ¥%@", preferential];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", money, preferential]];
//
//    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, money.length)];
//    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(money.length, preferential.length)];
//    self.moneyLbl.attributedText = string;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
