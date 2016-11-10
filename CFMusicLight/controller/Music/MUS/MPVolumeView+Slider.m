//
//  MPVolumeView+Slider.m
//  CFMusicLight
//
//  Created by 先科讯 on 16/9/18.
//
//

#import "MPVolumeView+Slider.h"
#import "UISlider+util.h"
@implementation MPVolumeView (Slider)

//mpVolumeView 中的UISlider
-(void)mpVolumeViewOfSlider{
    for (id view in self.subviews) {
        if ([view isKindOfClass:[UISlider class]]) {
            UISlider *slider = (UISlider*)view;
            [slider configer];
        }
    }
    
    
}


@end
