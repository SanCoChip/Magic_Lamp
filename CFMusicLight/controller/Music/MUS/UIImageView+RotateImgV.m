//
//  UIImageView+RotateImgV.m
//  RotateImgV
//
//  Created by Ashen on 15/11/10.
//  Copyright © 2015年 Ashen. All rights reserved.
//

#import "UIImageView+RotateImgV.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (RotateImgV)

- (void)rotate360DegreeWithImageView :(CGFloat)speed {
    
    
    
    CABasicAnimation *rotationAnimation = (CABasicAnimation *)[self.layer animationForKey:@"rotationAnimation"];
    
    CFTimeInterval pause = self.layer.timeOffset;
    self.layer.speed = 1.0f;
    self.layer.timeOffset = 0.0f;
    self.layer.beginTime = 0.0f;
    CFTimeInterval timeSincePauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pause;
    self.layer.beginTime = timeSincePauseTime;
    
    if (rotationAnimation) {
        
    }
    else {
        
        rotationAnimation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 10/speed;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        
        //不允许动画从渲染树中删除，否则程序中断会被删除
        rotationAnimation.removedOnCompletion = NO;
        //当动画结束后,layer会一直保持着动画最后的状态
        rotationAnimation.fillMode = kCAFillModeBackwards;
        
        
        
        [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    
    //    CABasicAnimation * rotationAnimation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    //    rotationAnimation.duration = 2;
    //    rotationAnimation.cumulative = YES;
    //    rotationAnimation.repeatCount = 100000;
    //    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
- (void)stopRotate {
    
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0f;
    self.layer.timeOffset = pauseTime;
    
    //    [self.layer removeAllAnimations];
}




-(void)rotateDegreeWithImage:(CGRect)frame{

//        [self.layer setAnchorPoint:CGPointMake(0.5, -1)];
    
//        self.transform
//        CABasicAnimation * rotationAnimation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI / 4 ];
//        rotationAnimation.duration = 2;
//        rotationAnimation.cumulative = YES;
//        rotationAnimation.repeatCount = 1;
//    
//        [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    
    
    CGAffineTransform  transform;
    
    
//    self.layer.anchorPoint = CGPointMake(0.2, 0.12);
    
    

    //设置旋转度数
    transform = CGAffineTransformRotate(self.transform,M_PI/6);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:1];
    //添加代理
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [self setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
    
    
    
    
    
    
    
    
    
    
    
    
//    CGMutablePathRef path = CGPathCreateMutable();
//    
//    CGPathAddArc(path, NULL, 0, 0, 1, 0, M_PI/4, 0);
//    
//    CAKeyframeAnimation * animation = [CAKeyframeAnimationanimationWithKeyPath:@"position"];
//    
//    animation.path = path;
//    
//    CGPathRelease(path);
//    
//    animation.duration = 3;
//    
//    animation.repeatCount = 500;
//    
//    animation.autoreverses = NO;
//    
//    animation.rotationMode =kCAAnimationRotateAuto;
//    
//    animation.fillMode =kCAFillModeForwards;
//    
//    [layer addAnimation:animation forKey:nil];
//    
//    [view.layer addAnimation:animation2 forKey:nil];

    
}



-(void)stopRotateWithImage{

    CGAffineTransform  transform;
    
    
    
    //设置旋转度数
    transform = CGAffineTransformRotate(self.transform,- M_PI/6);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:1];
    //添加代理
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [self setTransform:transform];
    //关闭动画
    [UIView commitAnimations];






}








@end
