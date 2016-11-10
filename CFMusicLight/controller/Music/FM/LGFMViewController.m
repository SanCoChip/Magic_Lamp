//
//  LGFMViewController.m
//  CFMusicLight
//
//  Created by 金港 on 16/6/3.
//
//

#import "LGFMViewController.h"
#import "SVProgressHUD.h"
static NSString*str= @"0875";

static NSString *str1= @"1080";

@interface LGFMViewController (){

    NSTimer *timer;//定时器

    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playBottomLayout;





@end

@implementation LGFMViewController
@synthesize  faderSlider = _faderSlider;

-(void)initLayout{

    if ([UIScreen mainScreen].bounds.size.height == 568) {
         self.playBottomLayout.constant = 15;
    }
    
    if ([UIScreen mainScreen].bounds.size.height == 667) {
        self.playBottomLayout.constant = 35;
    }

    if ([UIScreen mainScreen].bounds.size.height == 736) {
        self.playBottomLayout.constant = 50;
    }

}


#pragma  mark 滑块初始化
- (void)faderSliderInit {
    
  
     self.labelText.text = [NSString stringWithFormat:@"%.1f",_faderSlider.value];
    //Init Fader slider UI, set listener method and Transform it to vertical
//    [_faderSlider addTarget:self action:@selector(faderSliderAction:) forControlEvents:UIControlEventValueChanged];
    _faderSlider.backgroundColor = [UIColor clearColor];
    UIImage *stetchTrack = [[UIImage imageNamed:@"进度条.png"]
                            stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    [_faderSlider setThumbImage: [UIImage imageNamed:@"SL"] forState:UIControlStateNormal];
    [_faderSlider setMinimumTrackImage:stetchTrack forState:UIControlStateNormal];
    [_faderSlider setMaximumTrackImage:stetchTrack forState:UIControlStateNormal];
    _faderSlider.minimumValue = 87.5;
    _faderSlider.maximumValue = 108.5;
    //    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    //    _faderSlider.transform = trans;
    //    [self .faderSlider addTarget:self action:@selector(interval:) forControlEvents:UIControlEventTouchUpOutside];
    [self.faderSlider addTarget:self action:@selector(faderSliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.faderSlider addTarget:self action:@selector(faderSlider:) forControlEvents:UIControlEventValueChanged];
    
}
#pragma mark 滑块设置
- (void)faderSliderAction:(UISlider*)sender
{
    NSLog(@"%f",sender.value);
       if([_bleManager isConnected]){
           
           //强制转换
           int a= sender.value*10;
           
           NSString *senderVale = [NSString stringWithFormat:@"%04d",a];
           NSLog(@"%@",senderVale);
           
           //字符串转UtF-8
           [senderVale dataUsingEncoding:NSUTF8StringEncoding];
//           转data
           NSData *data = [senderVale dataUsingEncoding:NSUTF8StringEncoding];

        
//        self.labelText.text= [NSString stringWithFormat:@"%.1f",sender.value];
        self.labelText.text = [NSString stringWithFormat:@"%.1f",_faderSlider.value];
//
      
        [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.fmCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
    }else{
       
 
        //[SVProgressHUD showErrorWithStatus:@"请连接蓝牙设备"];
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请连接蓝牙设备", nil)];
        
    }


}

-(void)faderSlider:(UISlider*)sender{
    


self.labelText.text = [NSString stringWithFormat:@"%.1f",_faderSlider.value];

}
#pragma mark VIewe 视图生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self faderSliderInit];
    
    [self initLayout];
    
    //设置标题和颜色
    
    self.navigationItem.title = NSLocalizedString(@"FM收音机模式", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //居中
    NSArray *vcArr = [self.navigationController viewControllers];
    NSInteger index = [vcArr indexOfObject:self]-1;
    
    if (index >= 0) {
        UIViewController  *vc= [vcArr objectAtIndex:index];
        vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    }

    
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
       if([_bleManager isConnected]){
        
    NSString  *startseach = [NSString stringWithFormat:@"AT#FMBW"]; //AT#FMBW
           //[SVProgressHUD showErrorWithStatus:@"FM正在初始化"];
           [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"FM正在初始化", nil)];
    [startseach dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [startseach dataUsingEncoding:NSUTF8StringEncoding];
        
    [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ctrlCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
        
    }
    
    
    //[SVProgressHUD setMinimumDismissTimeInterval:3];
}


-(void)dealloc {
   
    
    [SVProgressHUD dismiss];
}

- (IBAction)FM_Left:(id)sender {
    
    
//    if([_bleManager isConnected]){
//        
//        self.faderSlider.value = self.faderSlider.value-0.1;
//        
//        
//        float a  = _faderSlider.value;
//        
//        self.labelText.text = [NSString stringWithFormat:@"%.1f",a];
//        
//        [self.labelText.text dataUsingEncoding:NSUTF8StringEncoding];
//        NSData *data = [self.labelText.text dataUsingEncoding:NSUTF8StringEncoding];
//        [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.fmCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
//        
//        
//    }else{
//        
//        [SVProgressHUD showErrorWithStatus:@"请连接蓝牙设备"];
//    }
//    
    [sender addTarget:self action:@selector(LeftBtn) forControlEvents:UIControlEventTouchUpInside];
   
}
-(void)LeftBtn{

//    _faderSlider.maximumValue =108.5;
//    _faderSlider.minimumValue=87.5;
    
    
        if([_bleManager isConnected]){
    
            self.faderSlider.value = self.faderSlider.value-0.1;
    
            float a  = _faderSlider.value;
    
            
            self.labelText.text = [NSString stringWithFormat:@"%.1f",a];
            //转成字符创
             NSString * sendstr = [NSString stringWithFormat:@"%@",self.labelText.text];
            //
            //转int
            int b  = sendstr .intValue*10;
            //转成四位
            NSString *sendData = [NSString stringWithFormat:@"%04d",b];
            //转UTF-8
            [sendData dataUsingEncoding:NSUTF8StringEncoding];

            NSData *data = [sendData dataUsingEncoding:NSUTF8StringEncoding];
            [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.fmCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
    
    
        }else{
    
            //[SVProgressHUD showErrorWithStatus:@"请连接蓝牙设备"];
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请连接蓝牙设备", nil)];
        }
    

}


- (IBAction)FM_Right:(id)sender {
    
    [sender addTarget:self action:@selector(RightBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)FM_play:(UIButton *)sender {
    
   
    
}
#pragma  mark 滑杆声音
 
- (IBAction)FM_Slidervolume:(UISlider *)sender {

      [sender addTarget:self action:@selector(volume) forControlEvents:UIControlEventTouchUpInside];
   
}

-(void)volume{

    int a = self.SliderVolume.value*15;
    NSLog(@"%d",a);
    Byte bytes[] = {a};
    
    //    [NSData dataWithBytes:bytes length:1];
    NSData *data = [NSData dataWithBytes:bytes length:1];
    [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.volumeCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
}
-(void)RightBtn{

    if([_bleManager isConnected]){
        
        self.faderSlider.value = self.faderSlider.value+0.1;
        //
//        NSString *BTlable = ;
        
        float a  = _faderSlider.value;
        
        self.labelText.text = [NSString stringWithFormat:@"%.1f",a];
        
        NSString * sendstr = [NSString stringWithFormat:@"%@",self.labelText.text];
        //转int
        int b  = sendstr .intValue*10;
        //转成四位
        NSString *sendData = [NSString stringWithFormat:@"%04d",b];
        //
        [sendData dataUsingEncoding:NSUTF8StringEncoding];
    
        
        NSData *data = [sendData dataUsingEncoding:NSUTF8StringEncoding];
        
        [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.fmCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
        
    }else{
        
       // [SVProgressHUD showErrorWithStatus:@"请连接蓝牙设备"];
        
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请连接蓝牙设备", nil)];
    }


}
@end
