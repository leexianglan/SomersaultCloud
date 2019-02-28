//
//  EditCarController.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/28.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "EditCarController.h"
#import "MineTtitleCell.h"
#import "EditCarCell.h"
#import "YBPopupMenu.h"


@interface EditCarController ()<UITextFieldDelegate,YBPopupMenuDelegate>

@property(nonatomic, strong)NSMutableDictionary *txtFieldDic;
@property(nonatomic, assign)CGRect tableFrame;
@property(nonatomic, strong)NSArray *provinceArr;
@property(nonatomic, strong)UIButton *provinceBtn;
@property(nonatomic, strong)NSString *province;
@property(nonatomic, assign)int selectCarTypeIndex;
@property(nonatomic, strong)NSString *carTypes;
@property (weak, nonatomic) IBOutlet UIButton *completBtn;
@property(nonatomic, strong)NSMutableArray *brandArr;
@property(nonatomic, strong)NSMutableArray *brandIdArr;
@property(nonatomic, strong)NSString *seriesName;


@end

@implementation EditCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"编辑车辆";
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [[LXViewControllerManager shareManager] fixFontWithView:self.completBtn];
    self.selectCarTypeIndex  =-1;
    
    if (self.car.carNo&& self.car.carNo.length>1) {
        self.province = [self.car.carNo substringToIndex:1];
        self.car.carNo = [self.car.carNo stringByReplacingOccurrencesOfString:self.province withString:@""];
    }

    [self loadData:1];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableFrame = self.pTableView.frame;
}

/**
 车联品牌信息数据

 @param index 1 车品牌， 2车型号
 */
-(void)loadData:(NSInteger)index{
    NSString *url =@"car/getCarBrandList";
    NSDictionary *request = nil;
    if (index == 2) {
        url = @"car/getCarSeriesList";
        CarBrandItem *item = self.brandArr[self.selectCarTypeIndex];
        request = @{@"brandId":item.brandId};
        [LXNetWork  getDataWithParm:request url:url successBlock:^(NSDictionary *dic) {
            [[LXViewControllerManager shareManager] hideHUD];
            if ([dic[@"status"] intValue] == 200) {
                [self.brandIdArr removeAllObjects];
                NSArray *dataArr = (NSArray *)dic[@"data"];
                for (NSDictionary *dataDic in dataArr) {
                    [self.brandIdArr addObject:[CarBrandItem mj_objectWithKeyValues:dataDic]];
                }
                [self selectCarType:2];
            }
        } errorBlock:^(NSError *error) {
            [[LXViewControllerManager shareManager] hideHUD];
        }];
    }else{
        [LXNetWork  getDataWithParm:request url:url successBlock:^(NSDictionary *dic) {
            if ([dic[@"status"] intValue] == 200) {
                [self.brandArr removeAllObjects];
                NSArray *dataArr = (NSArray *)dic[@"data"];
                for (NSDictionary *dataDic in dataArr) {
                    [self.brandArr addObject:[CarBrandItem mj_objectWithKeyValues:dataDic]];
                }
            }
        } errorBlock:^(NSError *error) {
            
        }];
    }
    
}

-(void)reloadTableview{
    [self.pDataBase addObject:@[@{@"title":@"车牌号码", @"place":@"请输入车牌号码"}, @{@"title":@"车架号码", @"place":@"输入完整的车架号"}]];
    [self.pDataBase addObject:@[@{@"title":@"选择车型", @"place":@""}, @{@"title":@"行驶里程", @"place":@"填写后可获取爱车最新报价"}, @{@"title":@"备注信息", @"place":@"例如：我的爱车"}]];
    [super reloadTableview];
    [self.pTableView registerNib:[UINib nibWithNibName:@"MineTtitleCell" bundle:nil] forCellReuseIdentifier:@"MineTtitleCell"];
    [self.pTableView registerNib:[UINib nibWithNibName:@"EditCarCell" bundle:nil] forCellReuseIdentifier:@"EditCarCell"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.pDataBase.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.pDataBase[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSArray *arr = self.pDataBase[section];
    NSDictionary *dic = arr[row];
    
    if (section == 1 && row == 0) {
        MineTtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTtitleCell"];
        [cell resetSelf];
        cell.titleLbl.text = dic[@"title"];
        NSString *string = self.car.carType;
        if (self.selectCarTypeIndex >= 0) {
            CarBrandItem *item = self.brandArr[self.selectCarTypeIndex];
            string = item.brand;
            if (self.seriesName) {
                string = [NSString stringWithFormat:@"%@-%@", string, self.seriesName];
            }
        }
        cell.detailLbl.text = string;
        return cell;
    }
    
    EditCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditCarCell"];
    [cell resetSelf];
    cell.leftLbl.text = dic[@"title"];
    cell.txtField.placeholder = dic[@"place"];
    cell.txtField.tag = 10*section + row;
    cell.txtField.delegate = self;
    cell.txtField.text = [self textWithTag:10*section + row];
    [cell.txtField addTarget:self action:@selector(txtFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txtFieldDic setObject:cell.txtField forKey:[NSString stringWithFormat:@"%ld", 10*section + row]];
    if (section == 0) {
        if (row == 0) {
            [cell baseViewShow:YES];
            [cell.btn addTarget:self action:@selector(changeProvinces:) forControlEvents:UIControlEventTouchUpInside];
            self.provinceBtn = cell.btn;
            [self setProvinceBtnTitle];
        }else{
            cell.leftLbl.textColor = kRedColor;
        }
    }else if (section == 1 && row == 1){
        cell.rightLbl.text = @"万公里";
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [self.view endEditing:YES];
    if (section == 1 && row == 0) {
        [self selectCarType:1];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65*kEqualHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*kEqualHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30*kEqualHeight)];
    if (section == 0) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = kRedColor;
        label.frame = view.bounds;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"车辆信息不全，请您完善";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }else if (section == 1){
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 0, kDeviceWidth - 30, 30*kEqualHeight);
        label.text = @"更多信息";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = k_3_Color;
        [view addSubview:label];
    }
    [[LXViewControllerManager shareManager] fixFontWithView:view];
    return view;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag > 10) {
        [self.pTableView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string && [string isEqualToString:@"\n"]) {
        [self nextTxtFieldBecomeFirstResponderWithTag:textField.tag];
    }
    return YES;
}

-(void)nextTxtFieldBecomeFirstResponderWithTag:(NSInteger)tag{
    int nextTag = (int)tag+1;
    if (nextTag > 12) {
        [self.view endEditing:YES];
        return;
    }
    if (nextTag == 2) {
        nextTag = 11;
    }
    UITextField *txtField = self.txtFieldDic[[NSString stringWithFormat:@"%d", nextTag]];
    if (txtField) {
        [txtField becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
}

-(void)txtFieldDidChanged:(UITextView *)sender{
    NSInteger tag = sender.tag;
    NSString *text = sender.text;
    if (tag == 0) {
        self.car.carNo = text;
    }else if (tag == 1){
        self.car.vinNo = text;
    }else if (tag == 11){
        self.car.travelDistance = text;
    }else if (tag == 12){
        self.car.remark = text;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

/**
 保存按钮

 @param sender nil
 */
- (IBAction)saveAction:(id)sender {
    
    if ([[LXViewControllerManager shareManager] checkEmptyText:self.car.carNo msg:@"车牌号"] || [[LXViewControllerManager shareManager] checkEmptyText:self.car.vinNo msg:@"车架号"] || [[LXViewControllerManager shareManager] checkEmptyText:self.car.travelDistance msg:@"公里数"]) {
        return;
    }
    if (!self.car.carType && (!self.carTypes || !self.seriesName)) {
        [[LXViewControllerManager shareManager] showHUD:@"请选择车品牌和型号"];
        return;
    }
    
    NSString *url = @"car/insertCar";
    if (self.car.lId) {
        [self.requestDic setObject:self.car.lId forKey:@"id"];
        url = @"car/updateCar";
    }
    [self.requestDic setObject:[NSString stringWithFormat:@"%@%@", self.province, self.car.carNo] forKey:@"carNo"];
    [self.requestDic setObject:[LXUserDefault userid] forKey:@"userId"];
    if (self.car.carType) {
        [self.requestDic setObject:self.car.carType forKey:@"carType"];
    }
    if (self.carTypes) {
        [self.requestDic setObject:[NSString stringWithFormat:@"%@-%@", self.carTypes, self.seriesName] forKey:@"carType"];
    }
    if (self.car.remark) {
        [self.requestDic setObject:self.car.remark forKey:@"remark"];
    }
    // llxl username 是否要传
    [self.requestDic setObject:@"username" forKey:@"username"];
    [self.requestDic setObject:self.car.travelDistance forKey:@"travelDistance"];
    [self.requestDic setObject:self.car.vinNo forKey:@"vinNo"];
    
    [LXNetWork nativePost:url bodyparam:self.requestDic success:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 200) {
            [[LXNotifyManager shareInstance] postNotifyKey:kRefreshCarList];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } faile:^(NSError *error) {
        
    } contentType:nil];
}

/**
 省份切换

 @param sender nil
 */
-(void)changeProvinces:(UIButton *)sender{
    CGFloat y = kEqualHeight*(IPhoneXAbove?164:140);
    CGPoint point =CGPointMake(48+90*kEqualHeight,y);
    [YBPopupMenu showAtPoint:point titles:self.provinceArr menuWidth:100 delegate:self tag:0];
}


/**
 、品牌选择视图

 @param index 1品牌。 2型号
 */
-(void)selectCarType:(NSInteger)index{
    CGFloat y = kEqualHeight*65*3.5+(IPhoneXAbove?84:64);
    CGPoint point =CGPointMake(kDeviceWidth/2.f,y);
    NSMutableArray *arr = [NSMutableArray array];
    if (index == 1) {
        for (CarBrandItem *item in self.brandArr) {
            [arr addObject:item.brand];
        }
    }else if (index == 2){
        for (CarBrandItem *item in self.brandIdArr) {
            [arr addObject:item.seriesName];
        }
    }
    if (arr.count>0) {
        YBPopupMenu *menu = [YBPopupMenu showAtPoint:point titles:arr menuWidth:kDeviceWidth/2.f delegate:self tag:index];
        menu.dismissOnTouchOutside = NO;
    }else{
        [[LXViewControllerManager shareManager] showHUD:@"数据异常"];
    }
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if (ybPopupMenu.tag == 0) {
        self.province = self.provinceArr[index];
        [self setProvinceBtnTitle];
    }else if (ybPopupMenu.tag == 1){
        self.selectCarTypeIndex = (int)index;
        self.seriesName = nil;
        self.car.carType = nil;
        CarBrandItem *item = self.brandArr[index];
        self.carTypes = item.brand;
        [self.pTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        [[LXViewControllerManager shareManager] showHUDOnly];
        [self loadData:2];
    }else if (ybPopupMenu.tag == 2){
        CarBrandItem *item = self.brandIdArr[index];
        self.seriesName = item.seriesName;
        [self.pTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)setProvinceBtnTitle{
    if (![self.province isEqualToString:self.provinceBtn.currentTitle]) {
        [self.provinceBtn setTitle:self.province forState:UIControlStateNormal];
    }
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

-(void)keyboardWillShow:(NSNotification *)sender{
    NSDictionary *userInfo = [sender userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.pTableView.frame = CGRectMake(CGRectGetMinX(self.tableFrame), CGRectGetMinY(self.tableFrame), kDeviceWidth, CGRectGetHeight(self.tableFrame)-CGRectGetHeight(keyboardRect)+44+15);
}

// 键盘回收
-(void)keyboardDisappear:(NSNotification *)sender{
    self.pTableView.frame = self.tableFrame;
}

-(void)tap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

-(NSArray *)provinceArr{
    if (!_provinceArr) {
        self.provinceArr = @[@"豫",@"京",@"津",@"沪",@"渝",@"蒙",@"新",@"藏",@"宁",@"桂",@"港",@"澳",@"黑",@"吉",@"辽",@"晋",@"冀",@"青",@"鲁",@"苏",@"皖",@"浙",@"闽",@"赣",@"湘",@"鄂",@"粤",@"琼",@"甘",@"陕",@"贵",@"云"];
    }
    return _provinceArr;
}

-(NSString *)province{
    if (!_province) {
        self.province = self.provinceArr[0];
    }
    return _province;
}

-(NSMutableArray *)brandIdArr{
    if (!_brandIdArr) {
        self.brandIdArr = [NSMutableArray array];
    }
    return _brandIdArr;
}

-(NSMutableArray *)brandArr{
    if (!_brandArr) {
        self.brandArr = [NSMutableArray array];
    }
    return _brandArr;
}

-(CarItem *)car{
    if (!_car) {
        self.car = [[CarItem alloc] init];
    }
    return _car;
}



-(NSString *)textWithTag:(NSInteger)tag{
    NSString *str = nil;
    if (tag == 0) {
        return self.car.carNo;
    }else if (tag == 1){
        return self.car.vinNo;
    }else if (tag == 11){
        return self.car.travelDistance;
    }else if (tag == 12){
        return self.car.remark;
    }
    return str;
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

