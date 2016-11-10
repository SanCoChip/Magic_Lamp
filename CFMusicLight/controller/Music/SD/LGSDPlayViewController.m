//
//  LGSDPlayViewController.m
//  CFMusicLight
//
//  Created by 金港 on 16/7/4.
//
//

#import "LGSDPlayViewController.h"
#import "LGSDPlayModel.h"
#import "PopupView.h"
#import "LGTFMusicViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+RotateImgV.h"
#import "LGMusicViewController.h"
@interface LGSDPlayViewController ()

@property (nonatomic,strong) LGSDPlayModel *model;

@property (nonatomic,strong)NSString *modelStr; //通过这个字符串来判断SD卡是否已经插入


//播放按钮顶部适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playTopLayout;



@end


@implementation LGSDPlayViewController{


NSInteger modleNumber;//模型数
}
//@synthesize PlayProgress;
@synthesize time;



-(void)initLayout{

   
    if ( [UIScreen mainScreen].bounds.size.height == 568) {
        self.playTopLayout.constant = 10;

    }
    if ([UIScreen mainScreen].bounds.size.height == 667) {
        self.playTopLayout.constant = 30;
    }

    if ([UIScreen mainScreen].bounds.size.height == 736) {
        self.playTopLayout.constant = 40;
    }

}



#pragma mark View视图周期
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //断开蓝牙状态 disConnect
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotification:) name:BLEDisconnectPeripheralNotification object:nil];
    
    //中心管理者的状态为非on 状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveCentralStateNotification:) name:BLEUpdateStateNotification object:nil];
    
    
    if (![_bleManager isConnected]) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
    
    if (self.model.isPlay) {
        [_ImageVIew rotate360DegreeWithImageView:1.5];
    }
    
    if([_bleManager isConnected]){
        
        //通过判断播放还是暂停来强制PlayButton状态
        if (self.model.isPlay) {
            self.playBtn.selected = YES;
        } else {
            self.playBtn.selected = NO;
            
        }
        
        
      
        
        //蓝牙断开状态
    }else {
        
        self.playBtn.selected = NO;
        [_ImageVIew stopRotate];
    }
    //如果SD没有插入让转盘停止
    if ([self.modelStr isEqualToString:@"AU"]) {
        [_ImageVIew stopRotate];
    }
    
    
    
    
    
    
}
-(void)dealloc {
   [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //[userDefault removeObjectForKey:@"volume"];
   
    
    if ([userDefault boolForKey:@"firstLaunch"]==YES) {
       
         self.ProgressVolumeSlider.value = 0.5;
        
    } else{
         NSInteger volume = [userDefault integerForKey:@"volume"];
        self.ProgressVolumeSlider.value =(CGFloat) volume/15;
        NSLog(@"self.ProgressVolumeSlider.value=%lf",self.ProgressVolumeSlider.value);
    }
    
   

    [self initLayout];
    
    
    
//设置标题和颜色
    
 self.navigationItem.title = NSLocalizedString(@"TF音乐模式", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置Title居中
    NSArray *vcArr = [self.navigationController viewControllers];
    NSInteger index = [vcArr indexOfObject:self]-1;
    if (index >= 0) {
        UIViewController *vc = [vcArr objectAtIndex:index];
        vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    
    NSString  *startseach = [NSString stringWithFormat:@"AT#MUBW"];
    
    [startseach dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [startseach dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",data);
    [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ctrlCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
    
    NSString  *startseach1 = [NSString stringWithFormat:@"AT#CSBW"];
    
    [startseach1 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data1 = [startseach1 dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",data1);
    [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ctrlCharacteristic andValue:data1 andResponseWriteType:CBCharacteristicWriteWithResponse];
    
    self.model = [[LGSDPlayModel alloc] init];
    
    [self setupNotification];
    //[self.PlayProgress setThumbImage:[UIImage imageNamed:@"椭圆"] forState:UIControlStateNormal];
    
   // [self.ProgressVolumeSlider setThumbImage:[UIImage imageNamed:@"椭圆"] forState:UIControlStateNormal];
    
    [self.PlayProgress addTarget:self action:@selector(stopWrite) forControlEvents:UIControlEventTouchUpOutside];
    self.PlayProgress.userInteractionEnabled=NO;
    
    //增加processVolumeSlider的点击事件
    [self.ProgressVolumeSlider addTarget:self action:@selector(volume) forControlEvents:UIControlEventTouchUpInside];
    
    //判断是否有sd卡 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveSDState:) name:@"musicModel" object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disreciveSDState:) name:@"dismusicModel" object:nil];
    
    
}





- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentSongNameNotification:) name:MusicCurrentSongNameLoadCompelete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentMusicStateNotification:) name:MusicCurrentStateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicListLoadCompleteNotification:) name:MusicSongListPeripheralLoadCompelete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicListSaveCompleteNotification:) name:MusicSongListLoadCompelete object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didConnectFailedPeripheralNotification:) name:BLEUpdateStateNotification object:nil];
    
    
    
    
}



- (void)didConnectFailedPeripheralNotification:(NSNotification*)notification
{
    if (![_bleManager isConnected]) {
        //         UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
    //    LGMusicViewController *vc = [story instantiateViewControllerWithIdentifier:@"MUSView"];
    
    [self.navigationController popViewControllerAnimated:YES];
    NSDictionary *dict = notification.userInfo;
    NSLog(@"%s\n %@",__FUNCTION__,dict);
    
    
    CBPeripheral * peripheral = ( CBPeripheral *)[dict objectForKey:@"peripheral"];
    if (peripheral == _bleManager.peripheral) {
        _bleManager.peripheral = nil;
        NSLog(@"Wrong Peripheral.\n");
        return ;
        
        
    }
}


- (void)musicListLoadCompleteNotification:(NSNotification *)note {
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"歌曲列表加载中", nil)];
    [self.model sendMusicCommandWithCommand:MusicCommandGetSongList];
    
}

- (void)musicListSaveCompleteNotification:(NSNotification *)note {
    
    
    [SVProgressHUD dismissWithCompletion:^{
        
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"歌曲列表加载完成", nil)];
        
        if (self.model.isPlay==YES) {
            [_ImageVIew rotate360DegreeWithImageView:1.5];
        } else {
            [_ImageVIew stopRotate];
            
        }
        
    }];
}

- (void)currentMusicStateNotification:(NSNotification *)note {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.playBtn.selected = self.model.isPlay;
        
        //整形转字符串总时间
        NSInteger inter = self.model.TotalTime;
        
        NSString *str = [NSString stringWithFormat:@"%lu",inter];
        //%zd %d的加强版
        str= [NSString stringWithFormat:@"%02zd:%02zd",inter/60,inter%60];
        self.Total_Time.text = str;
        self.Total_Time.textColor = [UIColor whiteColor];
        
        //整形转字符串 实时时间
        NSInteger  uininter = self.model.Realtime;
        NSString *  string   = [NSString stringWithFormat:@"%lu",uininter];
        
        string = [NSString stringWithFormat:@"%02zd:%02zd",uininter/60,uininter%60];
        
        self.Real_Time.text =string;
        self.Real_Time.textColor = [UIColor whiteColor];
        
        self.PlayProgress.value =self.model.Realtime/(CGFloat)self.model.TotalTime;
        
        //启用定时更新的方法
        
        if (time) {
            [time invalidate];
            time = nil;
        }
        time = [NSTimer scheduledTimerWithTimeInterval:0.1+1 target:self selector:@selector(updateMusicSliderValue) userInfo:nil repeats:YES];
        
    });
}

- (void)currentSongNameNotification:(NSNotification *)note {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.ArtistsName.text = self.model.currentSongName;
        self.ArtistsName.textColor = [UIColor whiteColor];
    });
    
}

- (IBAction)Mode_BT:(UIButton *)sender {
    
    if (modleNumber<3) {
        modleNumber++;
    }else{
        
        modleNumber=0;
    }
    
  
    //弹出变换的提示
    PopupView  *popUpView;
    popUpView = [[PopupView alloc]initWithFrame:CGRectMake(100, 240, 0, 0)];
    popUpView.ParentView = self.view;
   
    switch (modleNumber) {
        case 0:{
            [self .model setMusicPlayMode:MusicPlayModeAllPlay];
            [_ModeImage setImage:[UIImage imageNamed:@"列表循环"] forState:UIControlStateNormal];
            [popUpView setText: NSLocalizedStringFromTable(@"列表循环", @"Localizable", nil)];
              }
            break;
        case 1:{
            [self.model setMusicPlayMode:MusicPlayModeSinglePlay];
            [_ModeImage setImage:[UIImage imageNamed:@"单曲循序"] forState:UIControlStateNormal];
            [popUpView setText: NSLocalizedStringFromTable(@"单曲循环", @"Localizable", nil)];
               }
            break;{
        case 2:
            [self.model setMusicPlayMode:MusicPlayModeRandomPlay];
            [_ModeImage setImage:[UIImage imageNamed:@"随机播放"] forState:UIControlStateNormal];
            [popUpView setText: NSLocalizedStringFromTable(@"随机循环", @"Localizable", nil)];
            }
        default:
            break;
    }
    
    [self.view addSubview:popUpView];
    
}

- (IBAction)preOneAction:(UIButton *)sender {
    
    [self.model sendMusicCommandWithCommand:MusicCommandPrev];
    
}
- (IBAction)playAction:(UIButton *)sender {
    [self.model sendMusicCommandWithCommand:MusicCommandPlayAndPause];
    if (sender.selected) {
         [_ImageVIew stopRotate];
        
    }else{
        [_ImageVIew rotate360DegreeWithImageView:1.5];
    }
    
}
- (IBAction)NextSong:(UIButton *)sender {
    
    [self.model sendMusicCommandWithCommand:MusicCommandNext];
}
- (IBAction)volumeSlider:(UISlider *)sender {
    
    [self volume];
    
     [sender addTarget:self action:@selector(volume) forControlEvents:UIControlEventTouchUpInside];
}
-(void)volume{
    
    NSInteger a = self.ProgressVolumeSlider.value*15;
    
    //保存a 再次启动App时 音量和滑竿同步
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    [userDefalut setInteger:a forKey:@"volume"];
    [userDefalut synchronize];
    
    NSLog(@"音量大小：a=%ld",a);
    Byte bytes[] = {a};
    
    //    [NSData dataWithBytes:bytes length:1];
    NSData *data = [NSData dataWithBytes:bytes length:1];
    [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.volumeCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    LGTFMusicViewController *musicListVC = (LGTFMusicViewController *)segue.destinationViewController;
    musicListVC.songListArr = [NSMutableArray arrayWithArray:self.model.songListArr];
    musicListVC.model = self.model;
    
}
#pragma  mark 定时
-(void)updateMusicSliderValue{
    //判断当前播放状态
    if (!self.model.isPlay) {
        return;
    }
    //歌曲实时时间加1
    self.model.Realtime++;
    //整形装字符
    NSInteger  uininter = self.model.Realtime;
    NSString *  string   = [NSString stringWithFormat:@"%lu",uininter];
    
    string = [NSString stringWithFormat:@"%02zd:%02zd",uininter/60,uininter%60];
    
    self.Real_Time.text =string;
    
    _PlayProgress.value=self.model.Realtime/(CGFloat)self.model.TotalTime;
    
    
}
- (void)stopWrite
{
  

}
#pragma mark - 接受蓝牙断开或者拔出TF通知

-(void)reciveNotification:(NSNotification*)noti{
    //蓝牙断开状态
    NSDictionary *dict = noti.userInfo;
    CBPeripheral *peripheral = (CBPeripheral*)dict[@"peripheral"];
    if (peripheral.state==CBPeripheralStateDisconnected ) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
//中心设备的权限不为打开状态

-(void)reciveCentralStateNotification:(NSNotification*)noti{
    
    NSDictionary *dict = noti.userInfo;
    CBCentralManager *central =(CBCentralManager*)dict[@"central"];
    if (central.state != CBCentralManagerStatePoweredOn) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

//sd卡状态
-(void)reciveSDState:(NSNotification*)noti{
    
    
    NSDictionary *dict = noti.userInfo;
    
    NSNumber *modelStr = dict[@"model"];
    NSLog(@"modelStr=%@",modelStr);
    
    if (!([modelStr isEqual:@1] ||[modelStr isEqual:@2])) {
        [_ImageVIew stopRotate];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



-(void)disreciveSDState:(NSNotification*)noti{
    
    
    NSDictionary *dict = noti.userInfo;
    
    self.modelStr = dict[@"dismodel"];
    NSLog(@"modelStr=%@",self.modelStr);
    if ([self.modelStr isEqual:@"AU"]) {
        //[SVProgressHUD showWithStatus:@"请插入TF卡 "];
        [_ImageVIew stopRotate];
        
        //这里出现一些小BUG 通过定时0.02秒强制让装盘停止旋转
        [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(afterTime) userInfo:nil repeats:YES];
        
    }
    
}

-(void)afterTime{
    
    [_ImageVIew stopRotate];
    
}



@end
