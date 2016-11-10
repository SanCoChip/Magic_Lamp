//
//  ButtonView.m
//  CFMusicLight
//
//  Created by 先科讯 on 16/9/5.
//
//

#import "ButtonView.h"
#import "Masonry.h"

#define wframe [UIScreen mainScreen].bounds.size.width

//5s  //edge距离边框的距离  space两个按钮之间的距离 Kwidth按钮    的宽度
#define edge 25
#define space 45
#define kwidth 34


//6
#define K6edge 25
#define K6space 61.5
#define k6width 35

//6p
#define K6pedge 25
#define K6pspace 68
#define k6pwidth 40


@implementation ButtonView

-(instancetype)init{

    if (self = [super init]) {
      
        [self redBtn];
        [self greenBtn];
        [self blueBtn];
        [self whiteBtn];
        
    }
    return self;
}

-(UIButton *)redBtn{

    if (!_redBtn) {
        _redBtn = [UIButton new];
        _redBtn.backgroundColor = [UIColor redColor];
        
        
        
        
        [self addSubview:_redBtn];
        [_redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([UIScreen mainScreen].bounds.size.height == 736) {
                _redBtn.layer.cornerRadius = k6pwidth/2;
                
                make.left.mas_equalTo(K6pedge);
                make.centerY.equalTo(self.mas_centerY);
                make.width.mas_equalTo(k6pwidth);
                make.height.mas_equalTo(k6pwidth);
            }
            
            if ([UIScreen mainScreen].bounds.size.height == 667) {
                _redBtn.layer.cornerRadius = k6width/2;
                
                make.left.mas_equalTo(K6edge);
                make.width.mas_equalTo(k6width);
                make.height.mas_equalTo(k6width);
                make.centerY.equalTo(self.mas_centerY);
            }
            
            
            if ([UIScreen mainScreen].bounds.size.height==568) {
                _redBtn.layer.cornerRadius = kwidth/2;
                 make.centerY.equalTo(self.mas_centerY);
                 make.left.mas_equalTo(edge);
                make.width.mas_equalTo(kwidth);
                make.height.mas_equalTo(kwidth);
                
            }
            
            
        }];
        
    }


    return _redBtn;
}

-(UIButton *)greenBtn{

    if (!_greenBtn) {
        _greenBtn = [UIButton new];
        _greenBtn.backgroundColor = [UIColor greenColor];
        // _greenBtn.layer.cornerRadius = wframe*0.085/2;
        [self addSubview:_greenBtn];
        [_greenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            
            if ( [UIScreen mainScreen].bounds.size.height == 736) {
                _greenBtn.layer.cornerRadius = k6pwidth/2;
                make.left.mas_equalTo(self.redBtn.mas_right).mas_offset(K6pspace);
                make.centerY.equalTo(self.mas_centerY);
                make.width.mas_equalTo(k6pwidth);
                make.height.mas_equalTo(k6pwidth);
            }
            
            if ([UIScreen mainScreen].bounds.size.height == 667) {
                 _greenBtn.layer.cornerRadius = k6width/2;
                make.left.mas_equalTo(self.redBtn.mas_right).mas_offset(K6space);
                make.width.mas_equalTo(k6width);
                make.height.mas_equalTo(k6width);
                make.centerY.equalTo(self.mas_centerY);
            }
            
            
            
            
            if ([UIScreen mainScreen].bounds.size.height==568) {
                 _greenBtn.layer.cornerRadius = kwidth/2;
                 make.centerY.equalTo(self.mas_centerY);
                make.left.mas_equalTo(self.redBtn.mas_right).mas_offset(space);
               
                make.width.mas_equalTo(kwidth);
                make.height.mas_equalTo(kwidth);
                
             
            }

        }];

        
    }

    return _greenBtn;

}

-(UIButton *)blueBtn{

    if (!_blueBtn) {
        _blueBtn = [UIButton new];
        _blueBtn.backgroundColor = [UIColor blueColor];
         _blueBtn.layer.cornerRadius = wframe*0.085/2;
        
        [self addSubview:_blueBtn];
        [_blueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            if ( [UIScreen mainScreen].bounds.size.height == 736) {
                 _blueBtn.layer.cornerRadius = k6pwidth/2;
                make.left.mas_equalTo(self.greenBtn.mas_right).mas_offset(K6pspace);
                make.centerY.equalTo(self.mas_centerY);
                make.width.mas_equalTo(k6pwidth);
                make.height.mas_equalTo(k6pwidth);
            }
            
            if ([UIScreen mainScreen].bounds.size.height == 667) {
                _blueBtn.layer.cornerRadius = k6width/2;
                
                make.left.mas_equalTo(self.greenBtn.mas_right).mas_offset(K6space);
                make.centerY.equalTo(self.mas_centerY);
                make.width.mas_equalTo(k6width);
                make.height.mas_equalTo(k6width);
            }
          
            
            if ([UIScreen mainScreen].bounds.size.height==568) {
                  _blueBtn.layer.cornerRadius = kwidth/2;
                 make.centerY.equalTo(self.mas_centerY);
                make.left.mas_equalTo(self.greenBtn.mas_right).mas_offset(space);
                make.width.mas_equalTo(kwidth);
                make.height.mas_equalTo(kwidth);
            }
            
        }];
        
        
    }
    
    return _blueBtn;


}

-(UIButton *)whiteBtn{
    if (!_whiteBtn) {
        _whiteBtn = [UIButton new];
        _whiteBtn.backgroundColor = [UIColor whiteColor];
                 [self addSubview:_whiteBtn];
        [_whiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if ( [UIScreen mainScreen].bounds.size.height == 736) {
                
                _whiteBtn.layer.cornerRadius = k6pwidth/2;

                make.left.mas_equalTo(self.blueBtn.mas_right).mas_offset(K6pspace);
                make.centerY.equalTo(self.mas_centerY);
                make.width.mas_equalTo(k6pwidth);
                make.height.mas_equalTo(k6pwidth);
            }
            
            if ([UIScreen mainScreen].bounds.size.height == 667 ) {
                 _whiteBtn.layer.cornerRadius = k6width/2;
                make.centerY.equalTo(self.mas_centerY);

                 make.left.mas_equalTo(self.blueBtn.mas_right).mas_offset(K6space);
                make.width.mas_equalTo(k6width);
                make.height.mas_equalTo(k6width);
            }
           
            
            if ([UIScreen mainScreen].bounds.size.height==568) {
                 _whiteBtn.layer.cornerRadius = kwidth/2;
                make.centerY.equalTo(self.mas_centerY);
                make.left.mas_equalTo(self.blueBtn.mas_right).mas_offset(space);
                make.width.mas_equalTo(kwidth);
                make.height.mas_equalTo(kwidth);
            }
            
        }];
        
        
    }
    
    return _whiteBtn;
    

}



@end
