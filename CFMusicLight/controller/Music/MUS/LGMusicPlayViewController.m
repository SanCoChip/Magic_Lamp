//
//  LGMusicPlayViewController.m
//  CFMusicLight
//
//  Created by 金港 on 16/5/13.
//
//

#import "LGMusicPlayViewController.h"
#import "PopupView.h"
#import "UIImageView+RotateImgV.h"
#import "LGMusic.h"
#import "SVProgressHUD.h"
#import "MPVolumeView+Slider.h"
#import "UIView+Util.h"
#import "LMJScrollTextView.h"

@interface LGMusicPlayViewController () <AVAudioPlayerDelegate> {
    
    AVAudioSession *session;
    NSArray *mediaItems;
    NSMutableArray *showArray;//显示到表视图上的数据
    
    NSURL *urlOfSong;
    NSInteger modleNumber;//模型数
    
    BOOL HaveMusic;//本地播放库有没有音乐，有音乐为YES，没有音乐为NO。
    NSInteger lastMusicID;//内存中保存的最后一次播放的音乐ID
    NSIndexPath *lastIndexPath;//最后选择的行,刷新界面的依据
    BOOL ISChangeMusic;//是否重新初始化播放器.YES需要重新初始化播放器，NO不需要
    
    //    NSTimer *timer;
    BOOL ISSendMusic;
    BOOL StPy;
    
    //判断是不是跳到歌曲列表
    BOOL isPush;
    
    
    
    
    LMJScrollTextView *_scrollText;
    
    CGRect slideFrame;
}


//设置音量
@property (nonatomic,strong)MPVolumeView *mpVolumeView;

@property (nonatomic, strong) MPMediaItem *item;//歌曲
@property (nonatomic,strong)UISlider *volumviewslider;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
//@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIView *musicNameBG;








//播放顶部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playTopLayout;


@property (weak, nonatomic) IBOutlet UIImageView *musicSlider;








- (void)loadMediaItemsForMediaType:(MPMediaType)mediaType;
@end
@implementation LGMusicPlayViewController
@synthesize SliderPlay;
@synthesize time;
@synthesize changeVolume;


#pragma mark -  设置UI
-(void)initLayout{
    if ([UIScreen mainScreen].bounds.size.height==568) {
         self.playTopLayout.constant = 10;
    }
   
    if ([UIScreen mainScreen].bounds.size.height==667) {
        self.playTopLayout.constant = 30;
    }

    if ([UIScreen mainScreen].bounds.size.height == 736) {
        self.playTopLayout.constant = 45;
    }

   
}


-(void)initNavigationBar
{
    self.navigationItem.title = NSLocalizedString(@"蓝牙播放", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    
    //title居中
    NSArray *vcArr = [self.navigationController viewControllers];
    NSInteger index = [vcArr indexOfObject:self]-1;
    
    if (index >= 0) {
        UIViewController *vc = [vcArr objectAtIndex:index];
        vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"图层"]forBarMetrics:UIBarMetricsDefault];
}



//初始化音量ui
-(void)initVolumeUI{
    
    
    
    //    NSLog(@"player.volume=%f",player.volume);
    
//    self.mpVolumeView = [[MPVolumeView alloc]ini tWithFrame:self.volumviewslider.frame];
    //将changeVolume 隐藏
//    self.changeVolume.hidden = YES;
    
//    self.mpVolumeView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.mpVolumeView];
    
    [self.mpVolumeView mpVolumeViewOfSlider];
    
    
}


//子控件UI
-(void)viewDidLayoutSubviews{
    
    self.mpVolumeView.frame = self.changeVolume.frame;
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.mpVolumeView.top = self.mpVolumeView.top+6;
    }else{
        self.mpVolumeView.top = self.mpVolumeView.top+8;
    }
    
}




#pragma mark ---加载数据源---

- (MPMediaItem *)item {
    if(_item == nil) {
        _item = [[MPMediaItem alloc] init];
    }
    return _item;
}


#pragma mark -  读取中心设备音乐
-(void)loadMediaItemsForMediaType:(MPMediaType)mediaType{
    
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    NSNumber *mediaTypeNumber= [NSNumber numberWithInteger:mediaType];
    
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:mediaTypeNumber forProperty:MPMediaItemPropertyMediaType];
    //根据条件查找到本地的音乐数据
    [query addFilterPredicate:predicate];
    //两个数组赋值
    mediaItems = [query items];
//    NSLog(@" mediaItems=%@",mediaItems);
    showArray=[NSMutableArray arrayWithArray:mediaItems];
    
    
 
    
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    //判断是不是本地音乐被改变了
    if (mediaItems.count!=showArray.count) {
        showArray=[NSMutableArray arrayWithArray:mediaItems];
        lastIndexPath=[NSIndexPath indexPathForItem:lastMusicID inSection:0];
        lastMusicID = 0;
        
    }
    
//    if (player.playing) {
        [self.musicSlider stopRotateWithImage];
//    }
    
    
    
    
    if (!isPush) {
        switch (modleNumber) {
                //列表
            case 0:
                //            if(lastIndexPath.row!=[showArray count]-1){
                
                [self NextPlayer:nil];
                //            }else{
                //                [self StopAction];
                //            }
                break;
                //单曲
            case 1:
                [self playAction:nil];
                break;
                //随机
            case 2:
                [self NextPlayer:nil];
                break;
            default:
                //
                break;
        }
    }
}




-(void)StopAction{
    [_ImageView stopRotate];
    [player stop];
    [_PlayerButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
//    lastIndexPath=nil;//暂停时lastIndexPath=nil界面不会显示
    //
    //    [timer invalidate];
    
}
//当播放器遇到中断的时候（如来电），调用该方法
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)Myplayer{
    //    NSLog(@"打断");
    [self pauseAction:nil];
}
//中断事件结束后调用下面的方法
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    //    NSLog(@"结束打断");
    [self playAction:nil];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"error:%@",error);
}
- (BOOL) canBecomeFirstResponder
{
    return YES;
}
// 最后定义 remoteControlReceivedWithEvent，处理具体的播放、暂停、前进、后退等具体事件
- (void) remoteControlReceivedWithEvent:(UIEvent *)event
{
    [super remoteControlReceivedWithEvent:event];
    if(event.type == UIEventTypeRemoteControl)
    {
        switch (event.subtype) {
                //点击了播放
            case UIEventSubtypeRemoteControlPlay:
                [self playAction:nil];
                break;
                //点击了暂停
            case UIEventSubtypeRemoteControlPause:
                [self pauseAction:nil];
                break;
                //点击了下一首
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"Next");
                [self NextPlayer:nil];
                break;
                //点击了上一曲
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"Previous");
                [self preOneAction:nil];
                break;
            default:
                break;
        }
    }
}

#pragma mark ---View生命周期---



-(void)viewDidAppear:(BOOL)animated{
    
    if([_bleManager isConnected]){
        NSString  *startseach = [NSString stringWithFormat:@"AT#BTBW"];
        
        [startseach dataUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [startseach dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",data);
        [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ctrlCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
        
        
        
        NSString  *startseach1 = [NSString stringWithFormat:@"AT#CSBW"];
        
        [startseach1 dataUsingEncoding:NSUTF8StringEncoding];
        NSData *data1 = [startseach dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",data1);
        [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ctrlCharacteristic andValue:data1 andResponseWriteType:CBCharacteristicWriteWithResponse];
        
    }
    if (player.playing) {
         [_ImageView rotate360DegreeWithImageView:1.5];
    }
    
   
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}




-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //视图将要消失时保存当前正在播放的ID，以便下次继续播放
    NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:lastMusicID forKey:@"lastMusicKey"];
    [userDefaults setBool:player.playing forKey:@"isPlaying"];
    
//    self.navigationController.childViewControllers.count;
//    NSLog(@"%zd",self.navigationController.childViewControllers.count);
    if (self.navigationController.childViewControllers.count == 1) {
        
        [player stop];
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isPush = NO;
    //获取上次播放的歌曲行数
    NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
    //第一次加载，没有播放歌曲的时候 lastMusicID 是没有有效值的。有的只是一个乱码值
    lastMusicID=[[userDefaults objectForKey:@"lastMusicKey"] integerValue];
    //添加滑块和定时器的联动,这里一定要加非空判断，不然定时器立马就启用了
    
    [SliderPlay addTarget:self action:@selector(processChanged) forControlEvents:UIControlEventValueChanged];
    //启用定时更新的方法
    
    if (time) {
        [time invalidate];
        time = nil;
    }
    time = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
    
    
    
    if (lastMusicID) {
        lastIndexPath=[NSIndexPath indexPathForItem:lastMusicID inSection:0];
    }else{
        
        lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        lastMusicID = 0;
    }
    
    
    //判断是否在播放
    if (player.playing) {
        [_PlayerButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        
        
    }else{
        
        [_PlayerButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }
    
    //每次都读取本地音乐库
    [self loadMediaItemsForMediaType:MPMediaTypeMusic];
    //    [self audioPlayerDidFinishPlaying:player successfully:NO];
    
    [self scrollText];
    
    
    
    
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initLayout];
    //标题颜色和字体
    [self initNavigationBar];
    
    //初始化显示数组
    showArray = [NSMutableArray array];
    //初始化状态下，不需要初始化播放器
    ISChangeMusic=NO;
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    // 设置标题，设置导航栏左侧按钮，视图背景色
//    self.title = NSLocalizedStringFromTable(@"MUSICPAGE", @"Localizable", nil);
    //    [self setupLeftMenuButton];
    
    
    
    
    
    self.view.backgroundColor=[UIColor whiteColor];

    //加载本地音乐数据
    [self loadMediaItemsForMediaType:MPMediaTypeMusic];
    //后台播放 音频设置
    session = [AVAudioSession sharedInstance];
    //[session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    ISSendMusic=YES;

    
    //如果没有本地音乐，默认加载一首音乐
    if([mediaItems count]==0){
        HaveMusic=NO;
        
        //[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No local Music", nil)];
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"No local Music", nil)];
    }else{
        HaveMusic=YES;

    }
    
    
    [self initVolumeUI];
    
    [self scrollText];
    
    
    
    
    
//    CGFloat width = self.ImageView.width * 0.4;
//    CGFloat height = self.ImageView.height * 0.5;
//    CGFloat x = self.musicSlider.frame.origin.x;
//    CGFloat y = self.musicSlider.frame.origin.y;
//    
//    self.musicSlider.frame = CGRectMake(x, y, width, height);
    
    
    //设置旋转点
    slideFrame = self.musicSlider.frame;
    self.musicSlider.layer.anchorPoint = CGPointMake(0.33, 0.12);
    self.musicSlider.frame = slideFrame;
    
    
    
    
    
}









#pragma mark ---slider拖动方法---
-(void)processChanged
{
    [player setCurrentTime:SliderPlay.value*player.duration];
    
}

-(void)updateSliderValue
{
    self.RealTime.text = [NSString stringWithFormat:@"%02ld:%02ld",((NSInteger)player.currentTime / 60) ,((NSInteger)player.currentTime % 60)];
    //设置目前时间的颜色
    self.RealTime.textColor = [UIColor whiteColor];
    
    SliderPlay.value = player.currentTime/player.duration;
}

-(void)reSetlastMusicAction{
    MPMediaItem *item = [showArray objectAtIndex:lastIndexPath.row];
    for (int i=0; i<mediaItems.count; i++) {
        if ([mediaItems objectAtIndex:i] == item) {
            lastMusicID = i;
            //            NSLog(@"重新对应lastMusicID:%d",i);
        }
    }
    
}



#pragma mark - 播放器事件
- (IBAction)modleAction:(id)sender {
    if (modleNumber<2) {
        modleNumber++;
    }else{
        modleNumber=0;
    }
    //弹出变换的提示
    PopupView  *popUpView;
    popUpView = [[PopupView alloc]initWithFrame:CGRectMake(100, 240, 0, 0)];
    popUpView.ParentView = self.view;
    switch (modleNumber) {

        case 0:
            [_ModeButton setImage:[UIImage imageNamed:@"列表循环"] forState:UIControlStateNormal];
            [popUpView setText: NSLocalizedStringFromTable(@"列表循环", @"Localizable", nil)];
//              [player setNumberOfLoops:1000000];
            break;
        case 1:
            [_ModeButton setImage:[UIImage imageNamed:@"单曲循序"] forState:UIControlStateNormal];
            [popUpView setText:NSLocalizedStringFromTable(@"单曲循序", @"Localizable", nil)];
            
            break;
        case 2:
            [_ModeButton setImage:[UIImage imageNamed:@"随机播放"] forState:UIControlStateNormal];
            [popUpView setText: NSLocalizedStringFromTable(@"随机播放", @"Localizable", nil)];
            break;
        default:
            break;
    }
    [self.view addSubview:popUpView];
}
//暂停播放
- (void)pauseAction:(id)sender {
    [_ImageView stopRotate];
    [self.musicSlider stopRotateWithImage];
    [player stop];
    //[player pause]; //暂停播放
    [_PlayerButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    lastIndexPath=nil;//暂停时lastIndexPath=nil界面不会显示
    //    [_musicTableView reloadData];
    //    [timer invalidate];
}

//停止播放
-(void)stopAction{
    [player stop];
    [_PlayerButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    lastIndexPath=nil;//暂停时lastIndexPath=nil界面不会显示
//        [_musicTableView reloadData];
    //    [timer invalidate];
}

//上一曲
- (IBAction)preOneAction:(UIButton *)sender {
    if (mediaItems.count!=showArray.count) {
        showArray=[NSMutableArray arrayWithArray:mediaItems];
        lastIndexPath=[NSIndexPath indexPathForItem:lastMusicID inSection:0];
    }
    ISChangeMusic=YES;
    NSInteger oldRow;
    if(modleNumber==2){
        oldRow = (int) (arc4random() % ([showArray count]));
    }else if (!lastIndexPath) {
        if(showArray.count==0)return;
        oldRow= 0;
    }else if(lastIndexPath.row==0){
        oldRow = [showArray count]-1;
    }else if(lastIndexPath.row>0){
        oldRow = [lastIndexPath row]-1;
    }
    lastIndexPath=[NSIndexPath indexPathForRow:oldRow inSection:0];
    lastMusicID=oldRow;
    
    
    
    if (player.playing) {
        [self.musicSlider stopRotateWithImage];
    }
    
    [self playAction:nil];
    ISChangeMusic=NO;



}
//播放
- (IBAction)playAction:(UIButton*)sender {
    
    
    
    
    
    
    
    //如果是点击界面按钮
    //    sender.selected=!sender.selected;
    if (sender.selected) {
        //暂停
        [_ImageView stopRotate];
        sender.selected=!sender.selected;
        [self pauseAction:nil];
        
    }else{
        
     
        [self.musicSlider rotateDegreeWithImage:slideFrame];
        
        
        
        
        
        //播放
        [_ImageView rotate360DegreeWithImageView:1.5];
        [_PlayerButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        _PlayerButton.selected=YES;
        
        
        
        if (ISChangeMusic==NO&&player!=nil&&urlOfSong!=nil) {
            //            NSLog(@"继续播放");
            //如果有播放记录不需要重新初始化
            
            if (!lastMusicID) {
                lastMusicID = 0;
                
            }
            
            
            [player play]; //播放音乐
            
            //            [timer invalidate];
            
        }else{
            NSError *error;
            //重新初始化播放器URL
            if (HaveMusic) {
                //如果有本地音乐，播放音乐
                if (lastMusicID > mediaItems.count) {
                    lastMusicID = 0;
                }
                
                
                
                
                urlOfSong=[[mediaItems objectAtIndex:lastMusicID] valueForProperty:MPMediaItemPropertyAssetURL];
                player=[[AVAudioPlayer alloc]initWithContentsOfURL:urlOfSong error:&error];
            }else{
                //                NSLog(@"没有本地音乐");
                
            }
            
            if (!player) {
                return;
            }
            [player setDelegate:self];
            [player prepareToPlay];
            player.meteringEnabled=YES;
            [player play]; //播放音乐
            //            [timer invalidate];
            //                        timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateMeter) userInfo:nil repeats:YES];
        }
        if (!lastIndexPath) {
            lastIndexPath=[NSIndexPath indexPathForRow:lastMusicID inSection:0];
        }
        
        
//        self.musicName.text = [NSString stringWithFormat:@"%@-%@",[[mediaItems objectAtIndex:lastMusicID] valueForProperty:MPMediaItemPropertyTitle],[[mediaItems objectAtIndex:lastMusicID] valueForKey:MPMediaItemPropertyArtist]];
        
        [self scrollText];
        
        
        
        //设置总时间
        self.TotalTime.text = [NSString stringWithFormat:@"%02ld:%02ld",((NSInteger)player.duration / 60) ,((NSInteger)player.duration % 60)];
        //设置总时间颜色
        self.TotalTime.textColor = [UIColor whiteColor];
    }
    
    
    
    
    
    
    
   

}
//下一首
- (IBAction)NextPlayer:(id)sender {
    if (mediaItems.count!=showArray.count) {
        showArray=[NSMutableArray arrayWithArray:mediaItems];
        lastIndexPath=[NSIndexPath indexPathForItem:lastMusicID inSection:0];
    }
    ISChangeMusic=YES;
    NSLog(@"下一首");
    NSInteger oldRow;
    if(modleNumber==2){
        oldRow = (int) (arc4random() % ([showArray count]));
    }else if (!lastIndexPath) {
        if(showArray.count==0)return;
        oldRow= 0;
    }else if(lastIndexPath.row==[showArray count]-1){
        oldRow = 0;
    }else if(lastIndexPath.row>=0){
        oldRow = [lastIndexPath row]+1;
    }
    
    NSLog(@"oldRow:%ld",(long)oldRow);
    lastIndexPath=[NSIndexPath indexPathForRow:oldRow inSection:0];
    lastMusicID=oldRow;
    
    
    
    
    
    if (player.playing) {
        [self.musicSlider stopRotateWithImage];
    }
    
    
    
    
    [self playAction:nil];
    
    ISChangeMusic=NO;
}






#pragma mark ---截获目录控制器---
//设置LGMusic的代理,因为是从xib上获取的，而你又是直接通过xib拖线的方式推出的界面，所以比较麻烦点，要先获得跳转控制器的实例。
//当前的视图控制器即将被另一个视图控制器所替代时，segue将处于激活状态，从而调用prepareForSegue:sender: 方法。
//为了区分视图的跳转，可以用上一个、下一个来表示，也可以用源视图、目标视图来表示。 即： sourceViewController 和destinationViewController。  目标视图控制器是指：即将显示（加载）的视图， 而源视图控制器是指：即将被取代的视图控制器。
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //1.sender   这个参数是谁触发跳转动作的主体，一般是button  或其他的
    //2.segue    这个参数是在故事版中的跳转到的那条线
    //3.DisplayViewController 是显示界面，也就是目标VC
    //4.destinationViewController  是捕获的目标VC的引用
    LGMusic* vc = segue.destinationViewController;
    //设代理
    vc.delegate = self;
    
    
}

#pragma mark ---LGMusic代理---
-(void)didSelectMusic:(MPMediaItem *)item
{
    self.item = item;
//    self.musicName.text = [NSString stringWithFormat:@"%@-%@",[item valueForProperty:MPMediaItemPropertyTitle],[item valueForKey:MPMediaItemPropertyArtist]];
    //设置歌曲颜色
//    self.musicName.textColor = [UIColor whiteColor];
    

    [self scrollText];
    
    
    //播放音乐
    urlOfSong = [item valueForProperty:MPMediaItemPropertyAssetURL];
    NSError *error = nil;
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlOfSong error:&error];
     [_PlayerButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    
    //设置总时间
    self.TotalTime.text = [NSString stringWithFormat:@"%02ld:%02ld",((NSInteger)player.duration / 60) ,((NSInteger)player.duration % 60)];
    
    
    [player setDelegate:self];
    [player prepareToPlay];
    player.meteringEnabled=YES;
//    [player play];
    //    self.play.selected =YES;
    self.PlayerButton.selected = YES;
    [_ImageView rotate360DegreeWithImageView:1.5];
    player.currentTime = 00.00;
//    [player play];
    self.play.selected =YES;
    
    
    BOOL isPlaying = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"];
    
    if(isPlaying){
        [self.musicSlider stopRotateWithImage];
    }
    
    
    
    [self playAction:nil];
    
    
    
}


- (IBAction)SliderValue:(id)sender {
   
    float value= self.changeVolume.value;
    player.volume=value;
    
    NSLog(@"self.changeVolume.value=%f",self.changeVolume.value);
   
   
}



#pragma mark -  断开蓝牙连接
-(void)didConnectFailedPeripheralNotification:(NSNotification *)notification
{
    
    [self pauseAction:nil];
    
}


















#pragma mark -  字幕滚动
-(void)scrollText{

    
    
    
    

    if (_scrollText) {
        [_scrollText removeFromSuperview];
    }
    
    
    
    self.musicNameBG.clipsToBounds = YES;
   
    _scrollText = [[LMJScrollTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-40, self.musicNameBG.height) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
    
    _scrollText.backgroundColor = [UIColor clearColor];
    
    [self.musicNameBG addSubview:_scrollText];
    
    if(mediaItems.count != 0){
    
        [_scrollText startScrollWithText:[NSString stringWithFormat:@"%@-%@",[[mediaItems objectAtIndex:lastMusicID] valueForProperty:MPMediaItemPropertyTitle],[[mediaItems objectAtIndex:lastMusicID] valueForKey:MPMediaItemPropertyArtist]] textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16]];
 
    }else{
    
        [_scrollText startScrollWithText:@"艺术家" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16]];
    
    
    
    }

    
    

    
    


  


}















@end


