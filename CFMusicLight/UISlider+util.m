//
//  UISlider+util.m
//  CFMusicLight
//
//  Created by 先科讯 on 16/9/18.
//
//

#import "UISlider+util.h"

@implementation UISlider (util)
-(void)configer{

    UIColor *minmumTrackColor = [UIColor greenColor];
    UIColor *maxmumTrackColor = [UIColor whiteColor];

    UIColor *thumColor = [UIColor greenColor];
    
    self.minimumTrackTintColor = minmumTrackColor;
    self.maximumTrackTintColor = maxmumTrackColor;
    self.thumbTintColor = thumColor;

}
@end
