
//
//  EditAddressController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "EditAddressController.h"
#import "EditAddressCell.h"


@interface EditAddressController ()<UITextFieldDelegate>

@property(nonatomic, strong)NSMutableDictionary *txtFieldDic;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation EditAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"编辑地址";
    // Do any additional setup after loading the view from its nib.
    
    [[LXViewControllerManager shareManager] fixFontWithView:self.saveBtn];
    
    
}

-(void)reloadTableview{
    [self.pDataBase addObject:@{@"name":@"联系人", @"placeHolder":@"名字"}];
    [self.pDataBase addObject:@{@"name":@"手机号码", @"placeHolder":@"11位手机号"}];
    [self.pDataBase addObject:@{@"name":@"选择地区", @"placeHolder":@"地区信息"}];
    [self.pDataBase addObject:@{@"name":@"详细地址", @"placeHolder":@"街道门牌信息"}];
//    [self.pDataBase addObject:@{@"name":@"邮政编码", @"placeHolder":@"邮政编码"}];
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"EditAddressCell" bundle:nil] forCellReuseIdentifier:@"EditAddressCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pDataBase.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSDictionary *dic = self.pDataBase[row];
    EditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressCell"];
    [cell resetSelf];
    cell.txtField.tag = row;
    [cell.txtField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    cell.lbl.text = dic[@"name"];
    cell.txtField.delegate = self;
    cell.txtField.placeholder = dic[@"placeHolder"];
    [self.txtFieldDic setObject:cell.txtField forKey:[NSString stringWithFormat:@"%ld", row]];
    cell.txtField.text = [self textWithRow:row];
    return cell;
}
-(NSString *)textWithRow:(NSInteger)row{
    NSString *text = nil;
    switch (row) {
        case 0:
            return self.item.username;
            break;
        case 1:
            return self.item.telphone;
        case 2:
            return self.item.userAddress;
        case 3:
            return self.item.detailAddr;
            
        default:
            break;
    }
    return text;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*kEqualHeight;
}

-(void)textFieldDidChanged:(UITextField *)sender{
    NSInteger tag = sender.tag;
    NSString *text = sender.text;
    switch (tag) {
        case 0:
            self.item.username = text;
            break;
        case 1:
            self.item.telphone = text;
            break;
        case 2:
            self.item.userAddress = text;
            break;
        case 3:
            self.item.detailAddr = text;
            break;
            
        default:
            break;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string && [string isEqualToString:@"\n"]) {
        [self nextTxtFieldBecomeFirstResponderWithTag:textField.tag];
    }
    return YES;
}

/**
 后一个txt作为响应者

 @param tag 位置
 */
-(void)nextTxtFieldBecomeFirstResponderWithTag:(NSInteger)tag{
    if (self.item.lId) {
        [self.view endEditing:YES];
        return;
    }
    UITextField *txtField = self.txtFieldDic[[NSString stringWithFormat:@"%ld", tag + 1]];
    if (txtField) {
        [txtField becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
}


/**
 保存实现

 @param sender nil
 */
- (IBAction)saveAction:(id)sender {
    
    if ([[LXViewControllerManager shareManager] checkEmptyText:self.item.username msg:@"姓名"] || [[LXViewControllerManager shareManager] checkEmptyText:self.item.userAddress msg:@"地址"] || [[LXViewControllerManager shareManager] checkEmptyText:self.item.detailAddr msg:@"详细地址"]) {
        return;
    }
    if (![self.item.telphone isPhoneNumber]) {
        [[LXViewControllerManager shareManager] showHUD:@"请输入正确的手机号"];
        return;
    }
    NSString *url = @"user/addUserAddress";
    self.requestDic = [self.item mj_keyValues];
    
    [[LXViewControllerManager shareManager] showHUDOnly];
    if (self.item.lId) {
        [self.requestDic setObject:self.item.lId forKey:@"id"];
        [self.requestDic removeObjectForKey:@"lId"];
        url = @"user/updateAddress";
    }else{;
    }
    [LXNetWork nativePost:url bodyparam:self.requestDic success:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            [[LXViewControllerManager shareManager] showHUD:dic[@"msg"]];
            [[LXNotifyManager shareInstance] postNotifyKey:kRefreshAddressList];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } faile:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    } contentType:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableDictionary *)txtFieldDic{
    if (!_txtFieldDic) {
        self.txtFieldDic = [NSMutableDictionary dictionary];
    }
    return _txtFieldDic;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(AddressItem *)item{
    if (!_item) {
        self.item = [[AddressItem alloc] init];
        self.item.userId = [LXUserDefault userid];
    }
    return _item;
}

@end
