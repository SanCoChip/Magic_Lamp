//
//  LightViewController.m
//  CFMusicLight
//
//  Created by cfans on 5/4/16.
//  Copyright © 2016 cfans. All rights reserved.
//

#import "LightViewController.h"
#import "MSColorWheelView.h"
#import "MSColorUtils.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
#import "ButtonView.h"

#import <MediaPlayer/MediaPlayer.h>

//拖动发送间隔时间
#define kSend_Time_Interval (0.1f)

static int red = 127;
static int green =127;
static int blue = 127;
static int white = 127;






@interface LightViewController()

@property (nonatomic,strong)NSMutableArray *bytemuArr;

//显示开和关的label
@property (nonatomic,strong)UILabel *offLabel;
@property (nonatomic,strong)UILabel *onLabel;
@property (nonatomic,strong)ButtonView *btnView;



//深色图片 slider 浅色图片 距离下边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopSun;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopLightSun;

//slider左边
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SliderLeadLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeadLightLayout;

//滑竿右边
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TrailLightLayout;
@property (weak, nonatomic) IBOutlet UISlider *lightslider;


@end


@implementation LightViewController

{
    NSTimer *timer;
    NSTimer *timerLight;
    MSColorWheelView  * wheelView ;
    IBOutlet UISlider *_Slider;
    NSString *str;
    RGB  _rgb;
    
    NSArray * RedPoint;
    NSArray * GreenPoint;
    NSArray * BluenPoint;
    NSArray * whitePoint;
    //新增属性
    NSTimeInterval _proTouchTime;
    
    
    
    
    
    NSDate *_oldTime;
    BOOL isWhite;
    NSMutableArray *_saveColorArr;
    float colorSliderValue;
    
    
}
-(NSMutableArray *)bytemuArr{
    if (!_bytemuArr) {
        
        _bytemuArr = [NSMutableArray array];
        
    }
    return _bytemuArr;
}





#pragma mark - 适配滑竿的高度
-(void)layOutSlider{
    //5s
    if ([UIScreen mainScreen].bounds.size.height==568) {
        self.TopSun.constant = 15;
        self.TopLightSun.constant = 15;
        self.TopSlider.constant = 15;
        
        //slider左边的约束
        self.SliderLeadLayout.constant = 12;
        self.
        //深色图片距离左边距离
        self.LeadLightLayout.constant= 18;
        self.TrailLightLayout.constant = 22;
        
    }
    
    if ([UIScreen mainScreen].bounds.size.height==667) {
        
        self.LeadLightLayout.constant = 10;
    }
    
    if ([UIScreen mainScreen].bounds.size.height==736) {
        
        self.TrailLightLayout.constant = 18;
    }
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    

    //第一次进入界面就询问是否允许本地音乐
    [self loadMediaItemsForMediaType:MPMediaTypeMusic];
    
    _oldTime = [NSDate date];
    [self getPersistMethod];
    
    
    
    
    [self layOutSlider];
    [self initColorPicker];
    //加载Label 的开关
    [self initUI];
    
    //初始化生成 红 绿 蓝 白 按钮
    [self initBtnView];
    
    [self create];
    

    


}





-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:_saveColorArr forKey:@"colorArr"];
    [[NSUserDefaults standardUserDefaults] setObject:@(colorSliderValue) forKey:@"colorValue"];
}




-(void)getPersistMethod{

    _saveColorArr = [NSMutableArray array];
    [_saveColorArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorArr"]];
     colorSliderValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"colorValue"] floatValue];
}











-(void)create{
    self.navigationController.tabBarItem.image =[[UIImage imageNamed:@"形状-1-2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"彩灯"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶背景"]forBarMetrics:UIBarMetricsDefault];
    //底部bar颜色
    self.navigationController.tabBarController.tabBar.tintColor =[UIColor colorWithRed:152/255.0f green:216/255.0f blue:98/255.0f alpha:1];
    
//标题颜色和字体
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}






//生成BtnView
-(void)initBtnView{
    
    CGFloat hightFrame = self.view.bounds.size.height;
    CGFloat widthFrame = self.view.bounds.size.width;
    //self.btnView = [[ButtonView alloc] initWithFrame:CGRectMake(0, hightFrame*0.75, widthFrame,widthFrame*0.1)];
    self.btnView = [[ButtonView alloc]init];
    
    self.btnView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.btnView];
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(widthFrame);
        
        make.centerX.equalTo(self.view.mas_centerX);
        
        //6iphone
        if ([UIScreen mainScreen].bounds.size.height==667) {
            make.height.mas_equalTo(widthFrame*0.15);
            make.top.equalTo(self.SW.mas_bottom).offset(hightFrame*0.01);
        }
        
        //5s
        if ([UIScreen mainScreen].bounds.size.height ==568) {
            
            make.height.mas_equalTo(widthFrame*0.15);
            make.top.equalTo(self.SW.mas_bottom).offset(-5);
        }
        //6sp
        if ([UIScreen mainScreen].bounds.size.height==736) {
            make.height.mas_equalTo(widthFrame*0.15);
            make.top.equalTo(self.SW.mas_bottom).offset(25);
        }
        
        
        
        
    }];
    
    [self.btnView.redBtn addTarget:self action:@selector(red:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView.greenBtn addTarget:self action:@selector(green:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnView.blueBtn addTarget:self action:@selector(blue:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnView.whiteBtn addTarget:self action:@selector(white:) forControlEvents:UIControlEventTouchUpInside];
    
    
}












#pragma mark -  灯光点击按钮

- (void)red:(UIButton *)sender
{
   
   
    
    if([_bleManager isConnected]){
         _Slider.value= 0.5;
        [self adjustColorBytevalue1:127 Value2:0 Value3:0 Value4:0];
        
        isWhite = NO;
        
        //这段代码是点击红色跳转跳到取色盘红色的区域
        RedPoint =[NSArray arrayWithObject:[UIColor redColor]];
        _rgb = MSRGBColorComponents([RedPoint objectAtIndex:sender.tag]);
        HSB hsb = MSRGB2HSB(_rgb);
        [wheelView setSaturation:hsb.saturation];
        [wheelView setHue:hsb.hue];
        wheelView.layer.borderColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1].CGColor;
    
        _SW.on = YES;
    

    } else{
         [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
    }

//    } else{
//         [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
//    }


}


- (void)green:(UIButton*)Green{
   

    if([_bleManager isConnected]){
        [self adjustColorBytevalue1:0 Value2:127 Value3:0 Value4:0];
         _Slider.value=0.5;
        
        
        isWhite = NO;
        
        
        
        GreenPoint =[NSArray arrayWithObject:[UIColor greenColor]];
         _rgb = MSRGBColorComponents([GreenPoint objectAtIndex:Green.tag]);
        
        HSB hsb = MSRGB2HSB(_rgb);
        [wheelView setSaturation:hsb.saturation];
        [wheelView setHue:hsb.hue];
        
        
        wheelView.layer.borderColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:1].CGColor;
        _SW.on = YES;
        
    } else{
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
    }
    

}


- (void)blue:(UIButton*)sender {
    
   
   
    
    if([_bleManager isConnected]){
         _Slider.value=0.5;
        [self adjustColorBytevalue1:0 Value2:0 Value3:127 Value4:0];
        
        
        isWhite = NO;
        
        //这段代码是点击红色跳转跳到取色盘红色的区域
        BluenPoint =[NSArray arrayWithObject:[UIColor blueColor]];
        _rgb = MSRGBColorComponents([BluenPoint objectAtIndex:sender.tag]);
        HSB hsb = MSRGB2HSB(_rgb);
        [wheelView setSaturation:hsb.saturation];
        [wheelView setHue:hsb.hue];
        wheelView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:1].CGColor;
        _SW.on = YES;
        
    } else{
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
    }
    

}


//白灯
- (void)white:(UIButton*)sender
{
    
  
    if([_bleManager isConnected])
    {
        [self adjustColorBytevalue1:0 Value2:0 Value3:0 Value4:127];
        _Slider.value=0.5;
        
        isWhite = YES;
        
        [wheelView setSaturation:0];
        
        wheelView.layer.borderColor = [UIColor colorWithRed:255  green:255  blue:255  alpha:1].CGColor;
        _SW.on = YES;
        
    }else
    {
         [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
    }
}









- (IBAction)slider:(UISlider *)sender {
    
    
    if (_SW.on) {
        [self write];
    }

    

    
   

}

#pragma mark - 滑杆值写入
- (void)write{
    
 
    if (_SW.on && !isWhite) {
        [self Touch];
    }
    
    if (_SW.on && isWhite) {
        [self slideMove];
    }
    
    
    
}

#pragma mark -  滑块滑动调用
-(void)slideMove{
    
    
    
    if([_SW isOn]){
        if (-[_oldTime timeIntervalSinceNow] > 0.08){
            
            _oldTime = [NSDate date];
            [self ms_colorDidChangeValue];
            
            
        }
        
    
    }
//    }else{
//        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
//        
//    }

    
}





#pragma  mark ==== 初始化视图View  ====
-(void)initColorPicker{

    int width=0;
    CGRect rect;

    
    
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        width=screenW*0.5;
        rect = CGRectMake((screenW-screenW*0.5)/2.0, 105, width, width);
             wheelView = [[MSColorWheelView alloc] initWithFrame:rect];

    }
    if ([UIScreen mainScreen].bounds.size.height == 667) {
        width = screenW*0.65;
        rect = CGRectMake((screenW-screenW*0.7)/1.74, 120, width, width);
        wheelView = [[MSColorWheelView alloc] initWithFrame:rect];
    }
    if ([UIScreen mainScreen].bounds.size.height == 736) {
        width = screenW*0.7;
        rect = CGRectMake((screenW-screenW*0.8)/1.5, 130, width, width);
        wheelView = [[MSColorWheelView alloc] initWithFrame:rect];
    }

    

   
    [wheelView addTarget:self action:@selector(Touch) forControlEvents:UIControlEventValueChanged];
    

    //设置取色盘圈
    wheelView.layer.borderWidth = 5;
    wheelView.layer.borderColor = [UIColor whiteColor].CGColor;
    wheelView.layer.cornerRadius = CGRectGetWidth(rect)/2;

    
    //取色盘背景
    UIView *myView = [UIView new];
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        
        width = screenW*0.53;
        myView = [[UIView alloc] initWithFrame:CGRectMake((screenW-screenW*0.5)/2.1-10, 95, width+20, width+20)];
    } else if ([UIScreen mainScreen].bounds.size.height == 667){
        width = screenW*0.7;
        
        myView = [[UIView alloc] initWithFrame:CGRectMake((screenW-screenW*0.72)/2.0-7, 100, width+20, width+20)];
    } else {
        
        width = screenW*0.75;
        
        myView = [[UIView alloc] initWithFrame:CGRectMake((screenW-screenW*0.8)/2-7, 110, width+20, width+20)];
    }
    
    UIImageView *igView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"色盘背景"]];
    if ([UIScreen mainScreen].bounds.size.height == 667) {
        igView.frame = CGRectMake(0, 0, width+20, width+20);
    } else if ([UIScreen mainScreen].bounds.size.height == 568){
        
        igView.frame = CGRectMake(0, 0, width+20, width+20);
    } else {
        
        igView.frame = CGRectMake(0, 0, width+20, width+20);
        
    }
    
    [myView addSubview:igView];
    
    [self.view addSubview:myView];
    
    [self.view addSubview:wheelView];

}



#pragma mark -  色盘点击
-(void)Touch{
    
    
    isWhite = NO;
    
    if([_SW isOn]){
        if (-[_oldTime timeIntervalSinceNow] > 0.08){
        
            _oldTime = [NSDate date];
            [self ms_colorDidChangeValue];
        
        
        }
        
    }
    
//    }else{
//        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
//        
//    }
}




#pragma mark 圆环变化
- (void)ms_colorDidChangeValue
{
   
    if([_bleManager isConnected]){
    

        
        HSB hsb = { wheelView.hue, 1.0f,1.0f, 1.0f};
        
        RGB rgb = MSHSB2RGB(hsb);
        
        
        CGFloat tempValue = _sliderValue.value;
        
     
        
        if (!isWhite) {
            [self adjustColorBytevalue1:rgb.red*0xff*tempValue Value2:rgb.green*0xff*tempValue Value3:rgb.blue*0xff*tempValue Value4:0];
            
            wheelView.layer.borderColor = [UIColor colorWithRed:rgb.red  green:rgb.green  blue:rgb.blue  alpha:1].CGColor;

        }
        
        
        
        if (isWhite) {
            [self adjustColorBytevalue1:0 Value2:0 Value3:0 Value4:0xff*tempValue];
            
            wheelView.layer.borderColor = [UIColor colorWithRed:255  green:255  blue:255  alpha:1].CGColor;
        }
        
    }
}
//
//
-(void)switchON
{
    [self.SW setOn:YES];

    //如果最后是灯关的则初始化彩灯
    if (_saveColorArr.count == 0 ) {
        [self adjustColorBytevalue1:127 Value2:127 Value3:127 Value4:0];
        _lightslider.value =0.5;
        
        
    }else
    {
        
        int r = [_saveColorArr[0] intValue];
        int g = [_saveColorArr[1] intValue];
        int b = [_saveColorArr[2] intValue];
        int w = [_saveColorArr[3] intValue];
        
        
        
        
        if (w) {
            isWhite = YES;
        }else
        {
            isWhite = NO;
        }
        
        
        
        RGB rgb = {r,g,b,1.0f};
        HSB hsb = MSRGB2HSB(rgb);
        
        //设置点击位置的数值
        wheelView.hue = hsb.hue;
        //设置点击的位置
        //        wheelView.saturation = 0.5;
        
        
        [self adjustColorBytevalue1:r Value2:g Value3:b Value4:w];
         _lightslider.value = colorSliderValue;
    }
    
    
    
   
    
    

    
}

#pragma mark - 关闭开关
-(void)switchOff{
  
    [self.SW setOn:NO];
    
    [self saveColorValue];
    [self adjustColorBytevalue1:0 Value2:0 Value3:0 Value4:0];
    
    
}

#pragma mark -  switch响应事件
-(void)Switch:(UISwitch*)sender{
    
    if([_bleManager isConnected]){
        //连接蓝牙开关
        if (sender.isOn) {
            
            [self switchON];
            
        }else {
            [self switchOff];
            
        }
        
    }else{
        
        [sender setOn:NO];
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
    }
}

#pragma mark - 增加开关
//显示开和关的label 以及UIswitch  slider 重新布局
-(void)initUI{
    CGFloat wframe = self.view.bounds.size.width;
    
    self.SW = [UISwitch new];
    [self.SW addTarget:self action:@selector(Switch:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.SW];
    
    [self.SW mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([UIScreen mainScreen].bounds.size.height == 667 ||[UIScreen mainScreen].bounds.size.height == 736) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(60);
            
            make.top.mas_equalTo(wheelView.mas_bottom).mas_offset(50);
            
            make.centerX.equalTo(wheelView.mas_centerX).mas_offset(wframe*0.06);
        }
        
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(60);
            make.top.mas_equalTo(wheelView.mas_bottom).mas_offset(30);
             make.centerX.equalTo(wheelView.mas_centerX).mas_offset(wframe*0.06);
            
        }
       
        
    }];
    
    self.offLabel = [UILabel new];
    self.offLabel.backgroundColor = [UIColor clearColor];
    self.offLabel.textColor = [UIColor whiteColor];
    self.offLabel.text = NSLocalizedString(@"OFF", nil);
    self.offLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.offLabel];
    [self.offLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        
        make.right.mas_equalTo(self.SW.mas_left).mas_offset(-5);
        make.centerY.equalTo(self.SW.mas_centerY).mas_offset(-15);
    }];
    
    self.onLabel = [UILabel new];
    self.onLabel.backgroundColor = [UIColor clearColor];
    self.onLabel.textColor = [UIColor whiteColor];
    self.onLabel.text = NSLocalizedString(@"ON", nil);
    self.onLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.onLabel];
    [self.onLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        
        make.left.mas_equalTo(self.SW.mas_right).mas_offset(-43);
        make.centerY.equalTo(self.SW.mas_centerY).mas_offset(-15);
    }];
        
}






#pragma mark -  读取本地音乐库
-(void)loadMediaItemsForMediaType:(MPMediaType)mediaType{
    
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    NSNumber *mediaTypeNumber= [NSNumber numberWithInteger:mediaType];
    
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:mediaTypeNumber forProperty:MPMediaItemPropertyMediaType];
    //根据条件查找到本地的音乐数据
    [query addFilterPredicate:predicate];
    
    
}



#pragma mark -  发送数据
-(void)adjustColorBytevalue1:(int)value1 Value2:(int)value2 Value3:(int)value3 Value4:(int)value4{
    
    
    red = value1;
    green = value2;
    blue = value3;
    white = value4;
    
    Byte bytes[] = {red,green,blue,white};
    
    NSData  * datas =[NSData dataWithBytes:bytes length:4];
    
    [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ledCharacteristic andValue:datas andResponseWriteType:CBCharacteristicWriteWithResponse];
    
    
}




#pragma mark -  保存所有值
-(void)saveColorValue
{
    if (red||green||blue||white) {
        //存入rgb的值
        [_saveColorArr removeAllObjects];
        [_saveColorArr addObject:@(red)];
        [_saveColorArr addObject:@(green)];
        [_saveColorArr addObject:@(blue)];
        [_saveColorArr addObject:@(white)];
        
        
        
        colorSliderValue = _lightslider.value;
    }
    
}















@end
