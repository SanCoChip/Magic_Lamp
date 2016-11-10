//
//  HomePageCollectionViewCell.m
//  LiYang
//
//  Created by SuHui on 16/5/17.
//  Copyright © 2016年 lexiangquan. All rights reserved.
//

#import "HomePageCollectionViewCell.h"


@interface HomePageCollectionViewCell ()


@end

@implementation HomePageCollectionViewCell



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.isYes = NO;
        self.backgroundColor = [UIColor whiteColor];
//        NSLog(@"%lf,%lf",frame.size.width,frame.size.height);
        
        self.ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 8, frame.size.height / 6, frame.size.width / 1.3, frame.size.height / 1.3)];
        
        //    self.ImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.ImageView];
        //这里要让label居中
        self.ShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/220, frame.size.height * 2 / 2.1, frame.size.width, frame.size.height / 3)];
        self.ShowLabel.textAlignment = NSTextAlignmentCenter;
        self.ShowLabel.textColor = [UIColor blackColor];
        self.ShowLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.ShowLabel];
        
            
        
        
    }
    return self;
}
    // Initialization code







@end
