//
//  LightViewController.h
//  CFMusicLight
//
//  Created by cfans on 5/4/16.
//  Copyright © 2016 cfans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LightViewController : BaseViewController

;
- (IBAction)red:(UIButton *)sender;
- (IBAction)green:(UIButton*)sender;
- (IBAction)blue:(UIButton*)sender;
- (IBAction)white:(UIButton*)sender;
- (IBAction)slider:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *sliderValue;
//- (IBAction)Switch:(id)sender;
//@property (weak, nonatomic) IBOutlet UISwitch *SW;

@property (nonatomic, strong)  UISwitch *SW;
@end
