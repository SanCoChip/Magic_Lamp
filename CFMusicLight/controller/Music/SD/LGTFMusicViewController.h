//
//  LGTFMusicViewController.h
//  CFMusicLight
//
//  Created by 金港 on 16/7/19.
//
//

#import <UIKit/UIKit.h>
#import "LGSDPlayModel.h"

@interface LGTFMusicViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *TFTableView;

@property (nonatomic,strong) NSMutableArray *songListArr;

@property (nonatomic,weak) LGSDPlayModel *model;

@property (assign,nonatomic) NSInteger Indepath;



@end
