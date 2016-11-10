//
//  LGMusicViewController.m
//  CFMusicLight
//
//  Created by 金港 on 16/5/18.
//
//

#import "LGMusicViewController.h"
#import "LGMusicPlayViewController.h"
#import "UILabel+Extension.h"

#import "LGMusicPlayViewController.h"
#import "LGMusicViewController.h"
#import "LGAUXViewController.h"
#import "LGSDPlayViewController.h"

@interface LGMusicViewController ()
@property (weak, nonatomic) IBOutlet UILabel *BLE_connection;
@property (weak, nonatomic) IBOutlet UILabel *Radio;
@property (weak, nonatomic) IBOutlet UILabel *TFcard;
@property (weak, nonatomic) IBOutlet UILabel *AUXModel;
//按钮
@property (weak, nonatomic) IBOutlet UIButton *blueBtn;

@property (weak, nonatomic) IBOutlet UIButton *radioBtn;

@property (weak, nonatomic) IBOutlet UIButton *tfcardBtn;
@property (weak, nonatomic) IBOutlet UIButton *auodioBtn;

//label
@property (weak, nonatomic) IBOutlet UILabel *blueMusicLabel;

@property (weak, nonatomic) IBOutlet UILabel *radioLabel;
@property (weak, nonatomic) IBOutlet UILabel *TFlabel;

@property (weak, nonatomic) IBOutlet UILabel *AUXLabel;

//屏幕适配

//本地音乐
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueWidthLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueHightLayout;

//Radio
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *radioWidthLayout;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *radioHightLayout;

//TF
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFWidthLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFHightLayout;

//AUX
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AUxWidthLayout;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AUXHightLayout;

//左右距离屏幕


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueLeadingLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *radioTrailingLayout;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SDleadingLayout;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AUXTrailingLayout;



@end

@implementation LGMusicViewController
//适配
-(void)initLayout{

    if ([UIScreen mainScreen].bounds.size.height == 736) {
        self.blueWidthLayout.constant = 150;
        self.blueHightLayout.constant = 175;
        
        self.radioWidthLayout.constant = 150;
        self.radioHightLayout.constant = 175;
        
        self.TFWidthLayout.constant = 150;
        self.TFHightLayout.constant = 175;
        
        self.AUxWidthLayout.constant = 150;
        self.AUXHightLayout.constant = 175;
        
        //距离整个屏幕的View
        self.blueLeadingLayout.constant = 10;
        self.radioTrailingLayout.constant = 10;
        self.SDleadingLayout.constant = 10;
        self.AUXTrailingLayout.constant = 10;
        
    }
    
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        
        self.blueWidthLayout.constant = 100;
        self.blueHightLayout.constant = 130;
        
        self.radioWidthLayout.constant = 100;
        self.radioHightLayout.constant = 130;
        
        self.TFWidthLayout.constant = 100;
        self.TFHightLayout.constant = 130;
        
        self.AUxWidthLayout.constant = 100;
        self.AUXHightLayout.constant = 130;
        
    }
    
    
    
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
    
    [self create];
    
    [self.BLE_connection adjustFontSizeWithSize:18];
    [self.Radio adjustFontSizeWithSize:18];
    [self.AUXModel adjustFontSizeWithSize:18];
    [self.TFcard adjustFontSizeWithSize:18];
    
    
    //四个按钮名称
    self.blueMusicLabel.text = NSLocalizedString(@"MusicBlue", nil);
    self.radioLabel.text = NSLocalizedString(@"MusicRadio", nil);
    self.TFlabel.text = NSLocalizedString(@"TFCard", nil);
    self.AUXLabel.text = NSLocalizedString(@"AUXModel", nil);
    
}
-(void)create{
    
    self.navigationController.tabBarItem.image =[[UIImage imageNamed:@"Musical-note-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.title = NSLocalizedString(@"ChoosePlayModes", nil);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"图层"]forBarMetrics:UIBarMetricsDefault];
    
    //    设置 导航栏按钮颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    //    //隐藏tarItem字体
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];

    
   
    
    //标题颜色和字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    tap.numberOfTapsRequired=1;
    
    [tap addTarget:self action:@selector(clickTap:)];
    [self.BLE_connection addGestureRecognizer:tap];
    
}

-(void)clickTap:(UITapGestureRecognizer*)tap{

    NSLog(@"......");


}

- (IBAction)clickBlueBtn:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    

    LGMusicPlayViewController *musicVC = [story instantiateViewControllerWithIdentifier:@"MusicVC"];
    [self.navigationController pushViewController:musicVC animated:YES];
    
    
}


- (IBAction)clickRadioBtn:(id)sender {
     UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LGFMBaseViewController *FMVC = [story instantiateViewControllerWithIdentifier:@"FMVC"];
    [self.navigationController pushViewController:FMVC animated:YES];
    
    
}

//sd卡
- (IBAction)clickTFBtn:(id)sender {
     UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LGSDPlayViewController *SDVC = [story instantiateViewControllerWithIdentifier:@"SDVC"];
    [self.navigationController pushViewController:SDVC animated:YES];
    
    
}

- (IBAction)clickAudioBtn:(id)sender {
    
     UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LGAUXViewController *audioVC = [story instantiateViewControllerWithIdentifier:@"AUXVC"];
    
    [self.navigationController pushViewController:audioVC animated:YES];
}



@end
