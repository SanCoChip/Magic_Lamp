//
//  LGDeviceTableViewController.m
//  CFMusicLight
//
//  Created by 金港 on 16/7/26.
//
//

#import "LGDeviceTableViewController.h"
#import "JRBLESDK.h"
#import "UIImageView+RotateImgV.h"
#import "LGAlarmViewController.h"
#import "LGMusicViewController.h"
#import "PopupView.h"
#import "SVProgressHUD.h"
#import "BLE Tool.h"
@interface LGDeviceTableViewController ()


@property(nonatomic)  JRBLESDK * bleManager;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger didSelectedRow;


@property (nonatomic,strong)UITableViewCell*cell;



@end

@implementation LGDeviceTableViewController{

    PopupView  *popUpView;
    UIView *_isConnectBack;
    UIActivityIndicatorView *_isConnectView;}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶背景"]forBarMetrics:UIBarMetricsDefault];
    
    
    [self initBLE_ENV];
    
    self.Device_list.delegate=self;
    self.Device_list.dataSource=self;
   
    
    //self.Device_list.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellBG"]];
    //设置背景和分割线
    self.Device_list.backgroundColor = [UIColor  colorWithPatternImage:[UIImage imageNamed:@"背景---"]];
//    [self.Device_list setSeparatorColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    
    _Device_list.layer.borderWidth=10;
    _Device_list.layer.borderColor =[UIColor clearColor].CGColor;
    _Device_list.layer.cornerRadius =25;
    [self.view addSubview:_Device_list];
    
    [self Roundedbtn];
    
    [self addBLEObserver];
    
    //页面背景颜色
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景-"]];
    
    //标题颜色和字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
//圆
-(void)Roundedbtn{
    
    
    [_btn_Image_Bg.layer setMasksToBounds:YES];
    //    _btn_Image_Bg .layer.cornerRadius=10;
    [_btn_Image_Bg.layer setCornerRadius:30];
    [self.view addSubview:_btn_Image_Bg];
}
#pragma  mark btn

-(void)viewWillAppear:(BOOL)animated{
    
    if([_bleManager isConnected]){
        
        [_bleManager.bleTool startDiscoverWithServices:nil andOptions:nil];

        [_ImageBG rotate360DegreeWithImageView:1.5];
        
    }
    
}

-(void)SearchTime :(NSTimer *)timer{
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        
    }
    
}
-(void)timeChange{
    
    [_ImageBG stopRotate];
    [_bleManager.bleTool stopDiscover];
    
    [_timer invalidate];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bleDevices count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString * CELL_ID = @"deviceCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:CELL_ID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text =NSLocalizedString(@"ClickConnectionBLE", nil);
    cell.detailTextLabel.textColor =[UIColor  whiteColor];
    cell.detailTextLabel.font =[UIFont systemFontOfSize:15];
    //#warning change
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBPeripheral * peripheral = [_bleDevices objectAtIndex:[indexPath row]];
    cell.textLabel.textColor = [UIColor  whiteColor];
    
    cell.textLabel.text = peripheral.name;
    
    //    peripheral.name.backgroundColor = [UIColor  colorWithRed:114/255.0f green:140/255.0f blue:54/255.0f alpha:1];
    
    
    if (peripheral.state == CBPeripheralStateConnected) {
        
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
        cell.detailTextLabel.text =NSLocalizedString(@"Bluetooth Is Connected", nil);
        [_ImageBG stopRotate];
        [self SenderSystemTime:_Systemtimer];
        
        [self.navigationController popViewControllerAnimated:YES];
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"蓝牙已连接", nil)];
      
        
        
          [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth Is Connected", nil)];
        
        
    }else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.detailTextLabel.text = NSLocalizedString(@"ClickConnectionBLE", nil);
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CBPeripheral * peripheral = [_bleDevices objectAtIndex:[indexPath row]];
    NSLog(@"%@",peripheral);
    
    //#warning change
    
    if (peripheral.state != CBPeripheralStateConnected && (!_bleManager.peripheral)) {
        
        [_bleManager.bleTool connectPeripheral:peripheral andOptions:nil];
        
        //增加小菊花
        [self isConnectingPeripheral];
        
        [_bleManager.bleTool connectPeripheral:peripheral andOptions:nil];
        [_bleManager.bleTool stopDiscover];

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.cell = cell;
        _didSelectedRow = indexPath.row;

        
    }else{
        
        //        [_bleManager.bleTool disconnectWithPeripheral:_bleManager.peripheral];
        
        
        [self disconnectWithBlueTooth];
    }
    
    
}






-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.01;
    
}









#pragma  mark ==== 小菊花 正在连接  ====
-(void)isConnectingPeripheral{
    
    //底
    _isConnectBack = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _isConnectBack.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    //菊花
    _isConnectView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _isConnectView.frame = CGRectMake(_isConnectBack.bounds.size.width/2, _isConnectBack.bounds.size.height/2, 0, 0);
    [_isConnectView startAnimating];
    
    
    [_isConnectBack addSubview:_isConnectView];
    [self.view addSubview:_isConnectBack];


}
//获取到正在连接外设的通知
-(void)isConnectPeripheralNotification:(NSNotification*)notification{
    
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(connectTimeOut:) userInfo:notification.object repeats:NO];
}


//连接超时
-(void)connectTimeOut:(NSTimer *)timer{
    
    CBPeripheral *peripheral =(CBPeripheral *)[timer userInfo];
    
    if (_isConnectView && _isConnectBack) {
        
        [_isConnectView removeFromSuperview];
        [_isConnectBack removeFromSuperview];
        _isConnectView = nil;
        _isConnectBack = nil;
        
        [_bleManager.bleTool disconnectWithPeripheral:peripheral];
        //重新搜索
        //        [self Btn:nil];
        
        
        [popUpView removeFromSuperview];
        popUpView = [[PopupView alloc]initWithFrame:CGRectMake(100, 300, 0, 0)];
        popUpView.ParentView = self.view;
        [popUpView setWarning:@"连接超时"];
        [self.view addSubview:popUpView];
        
    }
    
    
    
}


-(void)disconnectWithBlueTooth {
    
    [_bleManager.bleTool disconnectWithPeripheral:_bleManager.peripheral];
    //    [self setBlueToothPower:FALSE];
    
}


-(void)initBLE_ENV{
    _bleManager = [JRBLESDK getSDKToolInstance];
    _bleDevices = [[NSMutableArray alloc]init];
}
#pragma BLE SDK Notification
-(void)addBLEObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSearchPeripheralNotification:) name:BLESearchPeripheralNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectPeripheralNotification:) name:BLEConnectPeripheralNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectFailedPeripheralNotification:) name:BLEConnectFailPeripheralNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectFailedPeripheralNotification:) name:BLEDisconnectPeripheralNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDicoverServicelNotification:) name:BLEDiscoverServiceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDicoverCharacteristicsNotification:) name:BLEDiscoverCharacteristicNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didConnectFailedPeripheralNotification:) name:BLEUpdateStateNotification object:nil];
  
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isConnectPeripheralNotification:) name:BLEIsConnectingNotification object:nil];

    
}
//#warning change
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_bleManager.bleTool stopDiscover];
    //退出还原
    [_bleManager.bleTool setfirstinto:FALSE];
}
- (void)didSearchPeripheralNotification:(NSNotification*)notification
{
    
    NSDictionary *dict = notification.userInfo;
    CBPeripheral * peripheral = ( CBPeripheral *)[dict objectForKey:@"peripheral"];
    NSLog(@"%s\n %@ \n %d,%ld",__FUNCTION__,peripheral,[_bleDevices containsObject:peripheral],(unsigned long)[_bleDevices count]);
      //此处可以让搜索到的设备顺序不会乱保持第一次搜索到的样子，但是就没有刷新的感觉
    for (CBPeripheral *searchedPeripheral in _bleDevices) {
        
        if ([searchedPeripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            
            return;
        }
    }
    
    [_bleDevices addObject:peripheral];
    [self.Device_list reloadData];
}

- (void)didConnectPeripheralNotification:(NSNotification*)notification
{
    
    NSDictionary *dict = notification.userInfo;
    NSLog(@"%s\n %@",__FUNCTION__,dict);
    CBPeripheral * peripheral = ( CBPeripheral *)[dict objectForKey:@"peripheral"];
    _bleManager.peripheral = peripheral;
    [_bleManager.bleTool discoverServicesWithPeripheral:peripheral andArray:nil];
    
//    /连接成功删除菊花
    if (_isConnectBack && _isConnectView) {
        [_isConnectView removeFromSuperview];
        [_isConnectBack removeFromSuperview];
        _isConnectView = nil;
        _isConnectBack = nil;
        
    }
    

    //#warning change
    [self.Device_list reloadData];
}


- (void)didDicoverServicelNotification:(NSNotification*)notification
{
    
    NSDictionary *dict = notification.userInfo;
    CBPeripheral * peripheral = ( CBPeripheral *)[dict objectForKey:@"peripheral"];
    
    
    if (peripheral != _bleManager.peripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    NSArray	* services  = [peripheral services];
    if (!services || ![services count]) {
        return ;
    }
    
    for (CBService *service in services) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kBLEServiceUUIDString]]) {
            _bleManager.service = service;
            [_bleManager.bleTool discoverCharacteristicsWithPeripheral:peripheral andConditionalArray:nil andService:service];
            break;
        }
    }
}

- (void)didDicoverCharacteristicsNotification:(NSNotification*)notification
{
    
    NSDictionary *dict = notification.userInfo;
    CBPeripheral * peripheral = ( CBPeripheral *)[dict objectForKey:@"peripheral"];
    CBService * service = ( CBService *)[dict objectForKey:@"service"];
    
    if (peripheral != _bleManager.peripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (service != _bleManager.service) {
        NSLog(@"Wrong Service.\n");
        return ;
    }
    
    NSArray		*characteristics	= [ service characteristics];
    CBCharacteristic *characteristic = nil;
    
    for (characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kBLECTRL_UUIDString]]) {
            NSLog(@"Discovered BLE Ctrl Characteristic");
            
            _bleManager.ctrlCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kBLEACK_UUIDString]]) {
            NSLog(@"Discovered BLE Acknowledge Characteristic");
            
            _bleManager.ackCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
        }
        else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kLEDCTRL_UUIDString]]) {
            NSLog(@"Discovered LED Ctrl Characteristic");
            
            _bleManager.ledCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            //            [characteristic.value.bytes ];
            
            
            
        }
        else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kVOLUME_UUIDString]]) {
            NSLog(@"Discovered Temperature Characteristic");
            
            _bleManager.volumeCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            
        } else if([[characteristic UUID]isEqual:[CBUUID UUIDWithString:kFM_UUIDString]]){
            NSLog(@"Discovered FM Discovered");
            
            _bleManager.fmCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            
        }else if([[characteristic UUID]isEqual:[CBUUID UUIDWithString:KBLESD_UUIDString]]){
            
            _bleManager.musicCharacteristic=characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            
        }else  if ([[characteristic UUID]isEqual:[CBUUID UUIDWithString:KBLEALARM_UUIDString]]){
            
            _bleManager .alarmCharacteristics = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
}

- (void)dealloc {
    
}

- (void)didConnectFailedPeripheralNotification:(NSNotification*)notification
{
    
    if (![_bleManager isConnected]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
    NSDictionary *dict = notification.userInfo;
    NSLog(@"%s\n %@",__FUNCTION__,dict);
    
    [self.Device_list reloadData];
    CBPeripheral * peripheral = ( CBPeripheral *)[dict objectForKey:@"peripheral"];
    if (peripheral == _bleManager.peripheral) {
        _bleManager.peripheral = nil;
        NSLog(@"Wrong Peripheral.\n");
        return ;
        
        
    }
}



- (IBAction)Btn:(UIButton *)sender {
    
    if ([_bleManager isConnected]) {
//        _ImageBG.hidden = YES;
//        sender.hidden = NO;
        [_ImageBG stopRotate];
        [_bleManager.bleTool stopDiscover];
    }else{
//        _ImageBG.hidden = NO;
//        sender.hidden = YES;
        [_bleDevices removeAllObjects];
//        [self.Device_list reloadData];
        
        [_ImageBG rotate360DegreeWithImageView:5];
        
        [_bleManager.bleTool startDiscoverWithServices:nil andOptions:nil];
        
        [self SearchTime:_timer];
        [self.Device_list reloadData];
    }}

-(void)SynchronizationTime:(NSData *)valueDate{
    //声明一个字符串
    NSString *str = [NSString stringWithFormat:@"ALARM"];
    //转成Data
    [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //声明一个可变Data
    NSMutableData *mutableData = [NSMutableData alloc];
    //两个Data合并
    
    
    [mutableData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    [mutableData appendData: valueDate];
    
    [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.alarmCharacteristics andValue:mutableData andResponseWriteType:CBCharacteristicWriteWithResponse];
    NSLog(@"!!!!!!!!!!!!!!!!发送命令的方法!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",mutableData);
    
    
    
    
}
//同步系统时间到板子
-(void)SenderSystemTime:(NSTimer *)timer{
    
    if (!_Systemtimer) {
        _Systemtimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(SystemTimer) userInfo:nil repeats:YES];
        
    }
    
    
    
}
-(void)SystemTimer{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm"];
    
    
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:unit fromDate:currentDate];
    
    NSInteger hour = comps.hour;
    NSInteger minute = comps.minute;
    
    //    NSLog(@"当前系统时间！！！！！！！！！ %ld  %ld" ,hour, minute);
    
    
    
    [self  setAlarmtype:6 Switch:0 powerOn:0 HourStart:hour minStart:minute];
    
    
    //断开连接  销毁同步时间
    if ([_bleManager isConnected]) {
        
    }else{
        
        [_Systemtimer invalidate];
    }
    
    
    
}
-(void)setAlarmtype:(NSInteger)type Switch:(NSInteger)switcherValue powerOn:(NSInteger)powerOn HourStart:(NSInteger)hourStart minStart:(NSInteger)minStart{
    
    Byte bytes[] = {type,switcherValue,powerOn,hourStart,minStart};
    
    NSData *data = [NSData dataWithBytes:bytes length:5];
    
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!%@",data);
    
    [self SynchronizationTime:data];
    
    
    
}

@end
