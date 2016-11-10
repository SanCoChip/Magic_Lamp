//
//  UIImageView+RotateImgV.h
//  RotateImgV
//
//  Created by Ashen on 15/11/10.
//  Copyright © 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RotateImgV)
- (void)rotate360DegreeWithImageView:(CGFloat)speed;
//- (void)rotate360DegreeWithImageView;
- (void)stopRotate;



-(void)rotateDegreeWithImage:(CGRect)frame;
-(void)stopRotateWithImage;

@end
