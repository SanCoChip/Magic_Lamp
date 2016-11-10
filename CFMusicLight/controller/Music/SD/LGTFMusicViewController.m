//
//  LGTFMusicViewController.m
//  CFMusicLight
//
//  Created by 金港 on 16/7/19.
//
//

#import "LGTFMusicViewController.h"
#import "LGSDPlayModel.h"
#import "UIView+MJExtension.h"
#import "MJRefresh.h"
//static const CGFloat MJDuration = 2.0;

@interface LGTFMusicViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableViewCell *cell1;
@end

@implementation LGTFMusicViewController{

    UITableViewCell *_selectedCell;

    UITableViewCell *_oldSelectCell;
}



-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear: animated];



}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏的标题 字体大小和颜色
    self.title = NSLocalizedString(@"MusicList", nil);
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //页面背景颜色
    
    self.view.backgroundColor = [UIColor colorWithRed:18/255.0 green:165/255.0 blue:165/255.0 alpha:1.0f];
    
    self.TFTableView.backgroundColor = [UIColor colorWithRed:18/255.0 green:166/255.0 blue:166/255.0 alpha:1.0f];
//    self.TFTableView.backgroundColor = [UIColor clearColor];
    
    self.TFTableView.separatorColor = [UIColor whiteColor];

   
    
  
    
    self.TFTableView.delegate = self;
    self.TFTableView.dataSource = self;
    
    [self.TFTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    //初始化选中行数
    [self.TFTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.model.CurrentIndex-1 inSection:0]  animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    
    
    NSLog(            @"%ld",(long)self.model.CurrentIndex);


}






-(void) MusicCurrentCurrentIndexNotification:(NSNotificationCenter*)note{

    
    
    [self.TFTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.model.CurrentIndex-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//     NSLog(@"!!!!!!!!!!!!!!!%lu",self.songListArr.count);
    
    return self.model.songListArr.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    
    //cell选中时的的背景颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.8 green:1 blue:0.8 alpha:1];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.textLabel.text = self.model.songListArr[indexPath.row];
    
    
    
//     cell1=self.model.songListArr[indexPath.row];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    [self.model setMusicPlaySongIndex:indexPath.row + 1];
    
    
    
    _oldSelectCell.textLabel.textColor = [UIColor whiteColor];
    
    
    
    _selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    _selectedCell.textLabel.textColor=[UIColor colorWithRed:0.8 green:1 blue:0.8 alpha:1];
    
    
    _oldSelectCell = _selectedCell;
    
    
}







-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{


    return 0.01;

}

























@end
