//
//  AddInvoiceController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/26.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "AddInvoiceController.h"
#import "EditAddressCell.h"
#import "InvoiceItem.h"

@interface AddInvoiceController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UIButton *unitsBtn;
@property(nonatomic, strong)NSMutableDictionary *txtFieldDic;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property(nonatomic, strong)InvoiceItem *item;


@end

@implementation AddInvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"发票信息";
    // Do any additional setup after loading the view from its nib.
    [self selectTypeBtn:self.personBtn];
    [self showRightButtonTitle:@"保存" tintColor:nil];
    [[LXViewControllerManager shareManager] fixFontWithView:self.baseView];
}


-(void)reloadTableview{
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
    [cell.txtField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];\
    cell.txtField.delegate = self;
    cell.lbl.text = dic[@"name"];
    cell.txtField.placeholder = dic[@"placeHolder"];
    cell.txtField.text = [self textWithRow:row];
    [self.txtFieldDic setObject:cell.txtField forKey:[NSString stringWithFormat:@"%ld", row]];
    return cell;
}

-(NSString *)textWithRow:(NSInteger)row{
    NSString *string = nil;
    if (self.personBtn.selected){
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string && [string isEqualToString:@"\n"]) {
        [self nextTxtFieldBecomeFirstResponderWithTag:textField.tag];
    }
    return YES;
}

-(void)nextTxtFieldBecomeFirstResponderWithTag:(NSInteger)tag{
    if (self.personBtn.selected || tag == 5) {
        [self.view endEditing:YES];
    }else{
        UITextField *txtField = self.txtFieldDic[[NSString stringWithFormat:@"%ld", tag+1]];
        [txtField becomeFirstResponder];
    }
}

-(void)textFieldDidChanged:(UITextField*)sender{
    NSInteger tag = sender.tag;
    if (self.personBtn.selected) {
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

/**
 保存按钮实现

 @param sender nil
 */
-(void)goRight:(id)sender{
    [self.view endEditing:YES];
    self.item.taxType = self.personBtn.selected?@"0":@"1";
    self.requestDic = self.item.mj_keyValues;
    
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"usersId"];
    [[LXViewControllerManager shareManager] showHUDOnly];
    [LXNetWork nativePost:@"invoice/insertInvoice" bodyparam:self.requestDic success:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            [[LXViewControllerManager shareManager] showHUD:dic[@"msg"]];
            [[LXNotifyManager shareInstance] postNotifyKey:kRefreshInvoiceList];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[LXViewControllerManager shareManager] showHUD:dic[@"msg"]];
        }
    } faile:^(NSError *error) {
        
    } contentType:nil];
}


/**
 个人还是单位发票

 @param sender 点几次试试
 */
- (IBAction)selectTypeBtn:(UIButton *)sender {
    if (!sender.selected) {
        self.item = nil;
        if (sender.tag == 0) {
            [self selectPersonBtn:YES];
        }else{
            [self selectPersonBtn:NO];
        }
    }
}


-(void)selectPersonBtn:(BOOL)select{
    if (select) {
        self.personBtn.layer.borderColor = kRedColor.CGColor;
        self.personBtn.selected = YES;
        self.unitsBtn.selected = NO;
        self.unitsBtn.layer.borderColor = k_9_Color.CGColor;
        [self.pDataBase removeAllObjects];
        [self.pDataBase addObject:@{@"name":@"名称", @"placeHolder":@"姓名（必填）"}];
    }else{
        self.personBtn.layer.borderColor = k_9_Color.CGColor;
        self.unitsBtn.layer.borderColor = kRedColor.CGColor;
        self.personBtn.selected = NO;
        self.unitsBtn.selected = YES;
        [self.pDataBase removeAllObjects];
        [self.pDataBase addObject:@{@"name":@"名称", @"placeHolder":@"公司名称（必填）"}];
        [self.pDataBase addObject:@{@"name":@"税号", @"placeHolder":@"公司纳税人识别号（必填）"}];
        [self.pDataBase addObject:@{@"name":@"单位地址", @"placeHolder":@"单位地址信息"}];
        [self.pDataBase addObject:@{@"name":@"电话号码", @"placeHolder":@"电话号码"}];
        [self.pDataBase addObject:@{@"name":@"开户银行", @"placeHolder":@"开户银行名称"}];
        [self.pDataBase addObject:@{@"name":@"银行账户", @"placeHolder":@"银行账户号码"}];
    }
    [self.pTableView reloadData];
}

-(NSMutableDictionary *)txtFieldDic{
    if (!_txtFieldDic) {
        self.txtFieldDic = [NSMutableDictionary dictionary];
    }
    return _txtFieldDic;
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
