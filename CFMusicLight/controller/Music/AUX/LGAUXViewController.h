//
//  LGAUXViewController.h
//  CFMusicLight
//
//  Created by 金港 on 16/7/9.
//
//

#import <UIKit/UIKit.h>
#import "LGFMBaseViewController.h"

@interface LGAUXViewController :LGFMBaseViewController
@property (strong, nonatomic) IBOutlet UIButton *VolumeImage;

- (IBAction)VolumeBtn:(UIButton *)sender;
@property (nonatomic,weak)NSString *str;
@property (nonatomic,assign) BOOL isYes;

- (IBAction)AUXSlider:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UISlider *AUX_sliderVoume;
@end
