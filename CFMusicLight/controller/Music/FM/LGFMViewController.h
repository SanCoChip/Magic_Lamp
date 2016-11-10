//
//  LGFMViewController.h
//  CFMusicLight
//
//  Created by 金港 on 16/6/3.
//
//

#import <UIKit/UIKit.h>
#import "LGFMBaseViewController.h"
@interface LGFMViewController :LGFMBaseViewController
@property (retain, nonatomic) IBOutlet UISlider *faderSlider;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (strong, nonatomic) IBOutlet UIButton *Playlable;
@property (strong, nonatomic) IBOutlet UISlider *SliderVolume;


- (IBAction)FM_Left:(id)sender;

- (IBAction)FM_Right:(id)sender;
- (IBAction)FM_play:(UIButton *)sender;
- (IBAction)FM_Slidervolume:(UISlider *)sender;

@end
