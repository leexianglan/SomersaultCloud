//
//  EditInvoiceController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/27.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "EditInvoiceController.h"
#import "EditAddressCell.h"

@interface EditInvoiceController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end

@implementation EditInvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"发票信息";
    // Do any additional setup after loading the view from its nib.
    [[LXViewControllerManager shareManager] fixFontWithView:self.saveBtn];
}

-(void)reloadTableview{
    if (!self.isPersonType) {
        [self.pDataBase addObject:@{@"name":@"名称", @"placeHolder":@"公司名称（必填）"}];
        [self.pDataBase addObject:@{@"name":@"税号", @"placeHolder":@"公司纳税人识别号（必填）"}];
        [self.pDataBase addObject:@{@"name":@"单位地址", @"placeHolder":@"单位地址信息"}];
        [self.pDataBase addObject:@{@"name":@"电话号码", @"placeHolder":@"电话号码"}];
        [self.pDataBase addObject:@{@"name":@"开户银行", @"placeHolder":@"开户银行名称"}];
        [self.pDataBase addObject:@{@"name":@"银行账户", @"placeHolder":@"银行账户号码"}];
    }else{
        [self.pDataBase addObject:@{@"name":@"名称", @"placeHolder":@"姓名（必填）"}];
    }
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
    cell.lbl.font = [UIFont systemFontOfSize:15*kEqualHeight];
    cell.txtField.font = [UIFont systemFontOfSize:15*kEqualHeight];
    [cell.txtField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    cell.txtField.delegate = self;
    cell.lbl.text = dic[@"name"];
    cell.txtField.placeholder = dic[@"placeHolder"];
    cell.txtField.text = [self textWithRow:row];
    return cell;
}

-(NSString *)textWithRow:(NSInteger)row{
    NSString *string = nil;
    if (self.isPersonType){
        return self.item.userName;
    }else{
        switch (row) {
            case 0:
                return self.item.taxCompany;
                break;
            case 1:
                return self.item.taxId;
            case 2:
                return self.item.address;
            case 3:
                return self.item.telephone;
            case 4:
                return self.item.openBank;
            case 5:
                return self.item.bankAccount;
                
            default:
                break;
        }
    }
    return string;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*kEqualHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 0) {
        view.frame = CGRectMake(0, 0, kDeviceWidth, 50*kEqualHeight);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth-20, 50*kEqualHeight)];
        label.font = [UIFont systemFontOfSize:15*kEqualHeight];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = k_3_Color;
        label.text = self.isPersonType?@"个人发票抬头":@"单位发票抬头";
        [view addSubview:label];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (IBAction)saveAction:(UIButton *)sender {
    
    self.requestDic = self.item.mj_keyValues;
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"usersId"];
    [self.requestDic setObject:self.item.lId forKey:@"id"];
    [self.requestDic removeObjectForKey:@"lId"];
    [self.requestDic removeObjectForKey:@"createTime"];
    [self.requestDic removeObjectForKey:@"updateTime"];
    
    [[LXViewControllerManager shareManager] showHUDOnly];
    
    [LXNetWork nativePost:@"/invoice/updateInvoice" bodyparam:self.requestDic success:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            [[LXNotifyManager shareInstance] postNotifyKey:kRefreshInvoiceList];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [[LXViewControllerManager shareManager] showHUD:dic[@"msg"]];
    } faile:^(NSError *error) {
        [[LXViewControllerManager shareManager] hideHUD];
    } contentType:nil];
    
;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string && [string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidChanged:(UITextField *)sender{
    NSInteger tag = sender.tag;
    if (self.isPersonType) {
        self.item.userName = sender.text;
    }else{
        if (tag == 0) {
            self.item.taxCompany = sender.text;
        }else if (tag == 1){
            self.item.taxId = sender.text;
        }else if (tag == 2){
            self.item.address = sender.text;
        }else if (tag == 3){
            self.item.telephone = sender.text;
        }else if (tag == 4){
            self.item.openBank = sender.text;
        }else if (tag == 5){
            self.item.bankAccount = sender.text;
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(InvoiceItem *)item{
    if (!_item) {
        self.item = [[InvoiceItem alloc] init];
    }
    return _item;
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
