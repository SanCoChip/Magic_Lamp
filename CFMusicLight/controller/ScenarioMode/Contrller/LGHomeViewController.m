//
//  LGHomeViewController.m
//  CFMusicLight
//
//  Created by 金港 on 16/6/16.
//
//

#import "LGHomeViewController.h"

#import "ContentCellModel.h"
#import "HomePageCollectionViewCell.h"
#import "MyCollectionLayout.h"
#import "LGSceneModel.h"
#import "SVProgressHUD.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH  [UIScreen mainScreen].bounds.size.height

//以iphone 6Puls 的屏幕宽度为参考，计算出任意屏幕的10像素
#define widhtFor10 10.0 * [UIScreen mainScreen].bounds.size.width / 414
#define heightFor10  10.0 * [UIScreen mainScreen].bounds.size.height / 736

//item的宽度和高度相等
#define itemW (ScreenW - widhtFor10 * 5) / 4

@interface LGHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray* dataSource;//模型类数据源
@property (nonatomic, strong) NSIndexPath* selectIndexPath;//被打开的cell的indexPath，但是不记录总开关的
@property (nonatomic, strong) NSIndexPath* mainSelectIndexPath;

@end



@implementation LGHomeViewController


bool flag = FALSE;

#pragma  mark ---懒加载---

- (UICollectionView *)collectionView {
    if(_collectionView == nil) {
        MyCollectionLayout* layout = [[MyCollectionLayout alloc] init];
        //item的列间距是10,航间距是20
        layout.minimumLineSpacing = widhtFor10;
        layout.minimumInteritemSpacing = heightFor10;
        layout.itemSize = CGSizeMake(itemW, itemW);
        //这里我是从导航下面开始算frame的
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,ScreenW , ScreenH) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //静止边缘弹跳，连重用都不用考虑了
        _collectionView.bounces = NO;
        //防止
        
        _collectionView.scrollEnabled =NO;
        _collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}

-(NSArray*)dataSource {
    if(_dataSource == nil) {
        _dataSource = [ContentCellModel cellDataSource];
    }
    return _dataSource;
}

#pragma mark ---View生命周期---
- (void)viewDidLoad {
    
    imageLabel = [[NSMutableArray alloc]init];
    
    
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    //注册cell并同时调用懒加载
    [self.collectionView registerClass:[HomePageCollectionViewCell class] forCellWithReuseIdentifier:@"homePageCell"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶背景"]forBarMetrics:UIBarMetricsDefault];
    
    //页面背景颜色
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    
    //标题颜色和字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

#pragma mark ---collectionView代理---
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homePageCell" forIndexPath:indexPath];
    ContentCellModel* model = self.dataSource[indexPath.row];
    //防重用，先将属性初始化
    cell.isYes = NO;
    
    cell.ShowLabel.text = model.title;//（如果文字也要变化的话就把文字放到下面这两个判断中）
    
    cell.ShowLabel.font = [UIFont systemFontOfSize:17];
    //判断主开关是否有被打开过，有的话就改变状态
    if(self.mainSelectIndexPath != nil && indexPath.row == self.mainSelectIndexPath.row){
        cell.isYes = YES;
     
        cell.ShowLabel.textColor = [UIColor greenColor];
    }
    //判断其他开关之前是否有被打开过，有的话就改变状态
    if (self.selectIndexPath != nil && indexPath.row == self.selectIndexPath.row) {
        cell.isYes = YES;
        
    }
    
    
    //加这样一个判断后，每次点击后就刷新表格没有问题的（所有的cell图片的显示全部是按照isYes状态来看的）
    if (cell.isYes == YES) {
        cell.ImageView.image = model.openImage;
        cell.ShowLabel.textColor = [UIColor  colorWithRed:157/255.0f green:216/255.0f blue:98/255.0f alpha:1];
        
    }else{
        cell.ImageView.image = model.onImage;
        
//        cell.ImageView.backgroundColor =[UIColor redColor];
        
        cell.ShowLabel.textColor = [UIColor whiteColor];
    }
    
    cell.layer.cornerRadius =10;
    cell.backgroundColor =[UIColor clearColor];
  
    
    return (UICollectionViewCell*)cell;
    
    
    
    
    
}


/*思路：前提在第三问中，因为重用，从队列中取出的cell全部要进行防重用设置，将cell的isYes属性设置为NO
 
 1.总开关被打开时会有mainSelectIndexPath = indexPath，在点击打开时刷新控件、在第三问时判断mainSelectIndexPath是否为空，不为空则代表总开关被打开了，总开关的的cell的isYes要置为YES
 2.总开关被关闭时会mainSelectIndexPath = nil，并将selectIndexPath = nil;
 3.当总开关打开状态时，点击其他开关重新让selectIndexPath = indePath
 */
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    HomePageCollectionViewCell* cell = (HomePageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    HomePageCollectionViewCell* mainCell = (HomePageCollectionViewCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //如果总开关是关闭着的状态，则直接打开总开关
    
    if([_bleManager isConnected]){
        
    if (indexPath.row == 0 && mainCell.isYes == NO) {
        self.mainSelectIndexPath = indexPath;
        [collectionView reloadData];
//        NSLog(@"开");
        [self adjustbyte:1];
        return YES;
        
    }
        
}else{
           [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Bluetooth not connected", nil)];
    }
    
    
    
    
    
    if (mainCell.isYes == YES) {//如果总开关打开着，点击有效
        
        if (indexPath.row == 0) {//如果是总开关则关闭总开关，改变总开关状态，刷新控件,清除之前的mainSelectIndexPath
            if([_bleManager isConnected])
            self.mainSelectIndexPath = nil;
            self.selectIndexPath =nil;
            [collectionView reloadData];
            NSLog(@"关");
            [self adjustbyte:0];
            
            
                return YES;
            
            
        }else{//点击的不是总开关，判断当前点击的开关(因为总开关是开着的点击有效)，如果是关着的就打开(清除原来的选中状态如果有的话,并记录indexPath选中状态)，如果是打开着的就关闭。
            if (cell.isYes == YES) {
                //开着的，就关闭
              
                switch (_selectIndexPath.row) {
                    case 1:
                        [self adjustbyte:0];
                         self.selectIndexPath = nil;
                        break;
                    case 2:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 3:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 4:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 5:
                        [self adjustbyte:0];
                         self.selectIndexPath = nil;
                        break;
                    case 6:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 7:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 8:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 9:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 10:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 11:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 12:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 13:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 14:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 15:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 16:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 17:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 18:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;
                    case 19:
                        [self adjustbyte:0];
                        self.selectIndexPath = nil;
                        break;

                    default:
                        break;
                }
                
                
            }else{
                //关闭的就打开
                self.selectIndexPath = indexPath;
                
                switch (_selectIndexPath.row) {
                    case 1:
                        [self adjustbyte:2];
                        break;
                    case 2:
                         [self adjustbyte:3];
                        break;
                    case 3:
                        [self adjustbyte:4];
                        break;
                    case 4:
                        [self adjustbyte:5];
                        break;
                    case 5:
                        [self adjustbyte:6];
                        break;
                    case 6:
                        [self adjustbyte:7];
                        break;
                    case 7:
                        [self adjustbyte:8];
                        break;
                    case 8:
                        [self adjustbyte:9];
                        break;
                    case 9:
                        [self adjustbyte:10];
                        break;
                    case 10:
                        [self adjustbyte:11];
                        break;
                    case 11:
                        [self adjustbyte:12];
                        break;
                    case 12:
                        [self adjustbyte:13];
                        break;
                    case 13:
                        [self adjustbyte:14];
                        break;
                    case 14:
                        [self adjustbyte:15];
                        break;
                    case 15:
                        [self adjustbyte:16];
                        break;
                    case 16:
                        [self adjustbyte:17];
                        break;
                    case 17:
                        [self adjustbyte:18];
                        break;
                    case 18:
                        [self adjustbyte:19];
                        break;
                    case 19:
                        [self adjustbyte:20];
                        break;
                    default:
                        break;
                }
            }
            
            
            [collectionView reloadData];
            return YES; 
        }
        
    }else{
        //总开关关着点击无效
        return NO;
    }
    
}

//-(void)adjustColor:(NSString*)Value{
//    if(Value){
//    
//    }
//     NSString *str = [NSString stringWithFormat:@""];
//    
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [_bleManager.bleTool  writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ledCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
// 
//}

- (void)adjustbyte:(Byte)value1
{
    //声明一个字符串
    NSString *str = [NSString stringWithFormat:@"BLMD"];
    //转成Data
    [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //声明一个Byte
    Byte bytee [] = {value1};
    //转成Data
    NSData *data =[NSData dataWithBytes:bytee length:1];
    
    //声明一个可变Data
    NSMutableData *mutableData = [NSMutableData alloc];
    //两个Data合并
    [mutableData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [mutableData appendData: data];
    
    [_bleManager.bleTool writeValueWithCharacteristic:_bleManager.peripheral andCharacteristic:_bleManager.ledCharacteristic andValue:mutableData andResponseWriteType:CBCharacteristicWriteWithResponse];
//    NSLog(@"value1:%d,value2:%d,value3:%d,value4:%d",value1,value2,valuevalue1e4);
    //     wheelView.layer.borderColor = [UIColor colorWithRed:value1    green:value2 blue:value3 alpha:1].CGColor;
    
}






@end
