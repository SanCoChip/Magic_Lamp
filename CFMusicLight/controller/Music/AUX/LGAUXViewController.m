//
//  LGAUXViewController.m
//  CFMusicLight
//
//  Created by 金港 on 16/7/9.
//
//

#import "LGAUXViewController.h"
//#import "LCTipView.h"
#import "SVProgressHUD.h"
@interface LGAUXViewController ()
@property (nonatomic,assign) BOOL isChecked;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *volumeTopLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jingyinBottomLayout;

@end

@implementation LGAUXViewController{

    NSTimer *timer;

}

-(void)initLayout{

    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.volumeTopLayout.constant = 57;
    }
    
    if ([UIScreen mainScreen].bounds.size.height == 667) {
        self.volumeTopLayout.constant = 75;
    }


    if ([UIScreen mainScreen].bounds.size.height == 736) {
        self.volumeTopLayout.constant = 90;
    }
}


#pragma  mark View视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];

    //设置标题和颜色
    
    self.navigationItem.title = NSLocalizedString(@"AUX模式", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    
    //Title居中
    NSArray *vcArr = [self.navigationController viewControllers];
    NSInteger index = [vcArr indexOfObject:self]-1;
    
    if (index >= 0) {
        UIViewController  *vc= [vcArr objectAtIndex:index];
        vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"hello" style:UIBarButtonItemStylePlain target:self action:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{

    if([_bleManager isConnected]){
        NSString  *startseach = [NSString stringWithFormat:@"AT#AUBW"]; //AT#AUBW
        
        [startseach dataUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [startseach dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",data);
        [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ctrlCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];

    }
          //[SVProgressHUD showErrorWithStatus:@"AUX正在初始化"];
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"AUX正在初始化", nil)];

}

-(void)dealloc {
//    if([_bleManager isConnected]){
//        NSString  *startseach = [NSString stringWithFormat:@"AT#BTBW"];
//        
//        [startseach dataUsingEncoding:NSUTF8StringEncoding];
//        NSData *data = [startseach dataUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"%@",data);
//        [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ctrlCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
//    }
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    

}

- (IBAction)VolumeBtn:(UIButton *)sender {
    if([_bleManager isConnected]){
    
    if (self.VolumeImage.selected) {
        int a = self.AUX_sliderVoume.value*15;
        Byte bytes[] = {a};
        
        //    [NSData dataWithBytes:bytes length:1];
        NSData *data = [NSData dataWithBytes:bytes length:1];
        [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.volumeCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
        
        self.VolumeImage.selected =NO;
        
    }else{
        self.VolumeImage.selected=YES;
        int b = 00;
        Byte byte[] ={b};
        NSData *data = [NSData dataWithBytes:byte length:1];
        
        
        [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.volumeCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
     }
    
    }else{
       [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
  }
}


- (IBAction)AUXSlider:(UISlider *)sender {
    
    
    [sender addTarget:self action:@selector(volume) forControlEvents:UIControlEventTouchUpInside];

}
-(void)volume{

    int a = self.AUX_sliderVoume.value*15;
    NSLog(@"%d",a);
    Byte bytes[] = {a};
    
    //    [NSData dataWithBytes:bytes length:1];
    NSData *data = [NSData dataWithBytes:bytes length:1];
    [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.volumeCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
}
@end
