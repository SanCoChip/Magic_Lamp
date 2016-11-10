//
//  LGSDPlayViewController.h
//  CFMusicLight
//
//  Created by 金港 on 16/7/4.
//
//

#import <UIKit/UIKit.h>
#import "LGFMBaseViewController.h"


@interface LGSDPlayViewController : LGFMBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *ImageVIew;//图片属性
@property (weak, nonatomic) IBOutlet UILabel *ArtistsName;//艺术家名
//Slider播放进度属性
@property (weak, nonatomic) IBOutlet UISlider *PlayProgress;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UILabel *Total_Time;//总时间

@property (weak, nonatomic) IBOutlet UILabel *Real_Time;//实时时间
//实时时间
@property (weak, nonatomic) IBOutlet UIButton *ModeImage;//模式图片
@property (weak, nonatomic) IBOutlet UISlider *ProgressVolumeSlider;//音量属性
@property (nonatomic,retain) NSTimer * time;//定时器

- (IBAction)Mode_BT:(UIButton *)sender;//模式按钮
- (IBAction)preOneAction:(UIButton *)sender;//上一曲
- (IBAction)playAction:(UIButton *)sender;//播放
- (IBAction)NextSong:(UIButton *)sender;//下一曲

- (IBAction)volumeSlider:(UISlider *)sender;//音量



@end
