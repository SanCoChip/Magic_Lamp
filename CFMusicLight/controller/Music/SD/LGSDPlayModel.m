//
//  LGSDPlayModel.m
//  CFMusicLight
//
//  Created by user on 16/7/15.
//
//

#import "LGSDPlayModel.h"
#import "JRBLESDK.h"
#import "BLE Tool.h"
#import "LGDeviceTableViewController.h"
NSString *const MusicSongListLoadCompelete = @"MusicSongListLoadCompelete";

NSString *const MusicSongListPeripheralLoadCompelete = @"MusicSongListPeripheralLoadCompelete";

NSString *const MusicCurrentSongNameLoadCompelete = @"MusicCurrentSongNameLoadCompelete";

NSString *const MusicCurrentStateNotification = @"MusicCurrentStateNotification";

NSString *const MusicCurrentTotaTimelNotification = @"MusicCurrentTotalNotification";

NSString *const MusicCurrentRealtimeNotification = @"MusicCurrentRealtimeNotification";

NSString *const MusicCurrentCurrentIndexNotification = @"MusicCurrentCurrentIndexNotification";

@interface LGSDPlayModel ()

@end

@implementation LGSDPlayModel
{
    NSMutableData *_songListNameData;
    NSMutableData *_currentSongNameData;
    NSInteger _stringCoding;
    NSLock *_songListLock;
    NSInteger _currentSongNameLength;
    NSInteger _currentSongCode;
}
#pragma mark - < 初始化及相关方法 >

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupContainer];
        
        [self setupNotification];
        
        [self setupLock];
    }
    return self;
}

#pragma mark == 加载数据容器 ==
- (void)setupContainer {
    
    self.songListArr = [NSMutableArray array];
}

#pragma mark == 加载通知 ==
- (void)setupNotification {
    /**
     *FFF3通知
     */
    
    CBCharacteristic *musicCharacteristic = [JRBLESDK getSDKToolInstance].ackCharacteristic;
    
    NSString *musicNotificationName = [NSString stringWithFormat:@"value.%@.%@",musicCharacteristic.service.UUID,musicCharacteristic.UUID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicNotification:) name:musicNotificationName object:nil];
    
    /**
     FFF7
     *  歌曲列表通知
     */
    //#warning songListCharacteristic
    CBCharacteristic *songListCharacteristic =[JRBLESDK getSDKToolInstance].musicCharacteristic;
    
    NSString *notificationName = [NSString stringWithFormat:@"value.%@.%@",songListCharacteristic.service.UUID,songListCharacteristic.UUID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSongListNotification:) name:notificationName object:nil];
}

#pragma mark == 加载锁 ==
- (void)setupLock {
    
    _songListLock = [[NSLock alloc] init];
}
#pragma mark == 音乐通知 ==
- (void)musicNotification:(NSNotification *)note {
    
    CBCharacteristic *characteristic = note.userInfo[@"characteristic"];
    
    NSData *data = characteristic.value;
    
    Byte *bytes = (Byte *)data.bytes;
    
    NSData *first = [data subdataWithRange:NSMakeRange(0, 2)];
    
    NSString *firstStr = [[NSString alloc] initWithData:first encoding:NSUTF8StringEncoding];
    
    NSData *secondData = [data subdataWithRange:NSMakeRange(2, 2)];
    NSString *mySecondStr = [[NSString alloc] initWithData:secondData encoding:NSUTF8StringEncoding];
    
    
    [_songListLock lock];
    if ([firstStr isEqualToString:@"OP"]) {
        
        NSData *secondData = [data subdataWithRange:NSMakeRange(2, 2)];
        NSString *secondStr = [[NSString alloc] initWithData:secondData encoding:NSUTF8StringEncoding];
        NSLog(@"secondStr=%@",secondStr);
        NSInteger sdInteger = bytes[4];
#pragma mark - 当拔了SD的时候 让播放界面返回主界面
        if ([secondStr isEqualToString:@"MU"]) {
            NSLog(@"。。。。。进入SD模式");
            
            NSDictionary *dict = [NSDictionary dictionary];
            
            dict = @{@"model":@(sdInteger)};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"musicModel" object:nil userInfo:dict];
            
        } else {
            
#pragma mark - 新增加
            //当SD没有插入时 发送通知
            NSLog(@"mySecondStr=%@",mySecondStr);
            if ([mySecondStr isEqualToString:@"AU"]) {
                NSString *bstr = @"AU";
                NSLog(@"str=%@",bstr);
                
                NSDictionary *dict = [NSDictionary dictionary];
                
                //sdmodel
                dict = @{@"dismodel":bstr};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"dismusicModel" object:nil userInfo:dict];
                
            }
            
            
        }
        
    }
    else if ([firstStr isEqualToString:@"CS"]) {
        
        NSData *secondData = [data subdataWithRange:NSMakeRange(2, 2)];
        NSString *secondStr = [[NSString alloc] initWithData:secondData encoding:NSUTF8StringEncoding];
        
        if ([secondStr isEqualToString:@"MU"]) {
            
            
            NSInteger currentIndex = ( bytes[4] << 8 ) | bytes[5];
            
            NSInteger totalIndex = ( bytes[6] << 8 ) | bytes[7];
            
            NSInteger currentTime = ( bytes[8] << 8) | bytes[9];
            
            NSInteger totalTime = ( bytes[10] << 8 ) | bytes[11];
            
            BOOL isPlay = bytes[12];
            
            self.isPlay = isPlay;
            
            self.TotalTime = totalTime;
            
            self.Realtime = currentTime;
            
            self.CurrentIndex = currentIndex;
            
            
            
            //当前播放状态
            [[NSNotificationCenter defaultCenter] postNotificationName:MusicCurrentStateNotification object:nil];
            
            
            
        }
        else if ([secondStr isEqualToString:@"MN"]) {
            
            
            _currentSongNameLength = bytes[4];
            _currentSongCode = bytes[5];
            
            _currentSongNameData = [NSMutableData data];
            
            NSData *songNameData = [data subdataWithRange:NSMakeRange(6, data.length-6)];
            [_currentSongNameData appendData:songNameData];
            
            [self getCurrentSongName];
        }
        
        
    }
    else if ([firstStr isEqualToString:@"OT"]) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MusicSongListPeripheralLoadCompelete object:nil];
    }
    else {
        
        NSData *songNameData = [data subdataWithRange:NSMakeRange(1, data.length - 1)];
        [_currentSongNameData appendData:songNameData];
        
        [self getCurrentSongName];
    }
    
    [_songListLock unlock];
}

#pragma mark == 判断并当前歌曲 ==
- (void)getCurrentSongName  {
    
    if (_currentSongNameData) {
        
        if (_currentSongNameData.length >= _currentSongNameLength) {
            
            NSString *currentSongName;
            switch (_currentSongCode) {
                case 1:
                {
                    currentSongName = [[NSString alloc] initWithData:_currentSongNameData encoding:NSUTF16LittleEndianStringEncoding];
                }
                    break;
                case 2:
                {
                    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    
                    currentSongName=[[NSString alloc] initWithData:_currentSongNameData encoding:gbkEncoding];
                    
                }
                    break;
                default:
                    break;
            }
            
            self.currentSongName = currentSongName;
            [[NSNotificationCenter defaultCenter] postNotificationName:MusicCurrentSongNameLoadCompelete object:nil];
        }
    }else {
        
        return;
    }
}

#pragma mark == 获取歌曲列表数据 ==
- (void)getSongListNotification:(NSNotification *)note {
    
    CBCharacteristic *characteristic = note.userInfo[@"characteristic"];
    NSData *data = characteristic.value;
    
    Byte *bytes = (Byte *)data.bytes;
    
    if (data.length < 2) {
        return;
    }
    NSInteger index = bytes[1];
    
    [_songListLock lock];
    
    switch (index) {
        case 0:
        {
            [self loadSongName];
            
            _stringCoding = bytes[3];
            NSData *songNameData = [data subdataWithRange:NSMakeRange(4, data.length-4)];
            [_songListNameData appendData:songNameData];
            
        }
            break;
        case 0xFF:
        {
            [self loadSongName];
            [[NSNotificationCenter defaultCenter] postNotificationName:MusicSongListLoadCompelete object:nil];
            
        }
            break;
        default:
        {
            NSData *songNameData = [data subdataWithRange:NSMakeRange(2, data.length-2)];
            [_songListNameData appendData:songNameData];
        }
            break;
    }
    
    [_songListLock unlock];
    
}
#pragma mark == 初始化歌曲名 ==
- (void)loadSongName {
    
    if (_songListNameData) {
        
        
        NSString *songName;
        switch (_stringCoding) {
            case 1:
            {
                songName = [[NSString alloc] initWithData:_songListNameData encoding:NSUTF16LittleEndianStringEncoding];
            }
                break;
            case 2:
            {
                NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                
                songName=[[NSString alloc] initWithData:_songListNameData encoding:gbkEncoding];
            }
                break;
            default:
                return;
                break;
        }
        
        [self.songListArr addObject:songName];
    }
    
    _songListNameData = [NSMutableData data];
}

#pragma mark - < 控制指令 >
#pragma mark == 音乐模式指令 ==
- (void)sendMusicCommandWithCommand:(MusicCommand)command {
    
    
   
    
    
    NSString *commandStr;
    
    switch (command) {
        case MusicCommandNext:
        {
            commandStr = @"AT#MDBW";
        }
            break;
        case MusicCommandPrev:
        {
            commandStr = @"AT#MEBW";
        }
            break;
        case MusicCommandPlayAndPause:
        {
            commandStr = @"AT#MABW";
            
            
        }
            break;
        case MusicCommandChangeMusicDevice:
        {
            commandStr = @"AT#SUBW";
            
        }
            break;
        case MusicCommandGetSongList:
        {
            commandStr = @"AT#SLBW";
            [_songListArr removeAllObjects];
        }
            break;
        case MusicCommandGetStat:
        {
            commandStr = @"AT#CSBW";
            
        }
            break;
            //        case clearMusic:
            //        {
            //
            //        [_songListArr removeAllObjects];
            //        }
            //            break;
            
    }
    
    NSData *data = [commandStr dataUsingEncoding:NSUTF8StringEncoding];
    
    CBPeripheral *currentPeripheral = [JRBLESDK getSDKToolInstance].peripheral;
    /**
     *  FFF1的特征 专门用来写指令
     */
    //#warning setCharacteristic
    CBCharacteristic *musicCharacteristic = [JRBLESDK getSDKToolInstance].ctrlCharacteristic;
    
    [[BLE_Tool sharedTool] writeValueWithCharacteristic:currentPeripheral andCharacteristic:musicCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
}

#pragma mark == 歌曲播放顺序设置 ==
- (void)setMusicPlayMode:(MusicPlayMode)mode {
    
    NSString *commandStr;
    
    switch (mode) {
        case MusicPlayModeAllPlay:
        {
            commandStr = @"AT#LOAL";
        }
            break;
        case MusicPlayModeRandomPlay:
        {
            commandStr = @"AT#LORA";
        }
            break;
        case MusicPlayModeSinglePlay:
        {
            commandStr = @"AT#LOSI";
        }
            break;
    }
    
    NSData *data = [commandStr dataUsingEncoding:NSUTF8StringEncoding];
    
    CBPeripheral *currentPeripheral = [JRBLESDK getSDKToolInstance].peripheral;
    /**
     *  FFF1的特征 专门用来写指令
     */
    //#warning setCharacteristici
    CBCharacteristic *musicCharacteristic = [JRBLESDK getSDKToolInstance].ctrlCharacteristic;
    
    [[BLE_Tool sharedTool] writeValueWithCharacteristic:currentPeripheral andCharacteristic:musicCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
}

#pragma mark == 设置当前播放歌曲 ==
- (void)setMusicPlaySongIndex:(NSInteger)index {
    
    Byte byte[2] = {( index >> 8 ) & 0xFF,index & 0xFF};
    NSData *data = [NSData dataWithBytes:byte length:2];
    
    CBPeripheral *currentPeripheral = [JRBLESDK getSDKToolInstance].peripheral;
    /**
     *  FFF7的特征 专用来设置当前歌曲播放
     */
    //#warning setCharacteristic
    CBCharacteristic *songIndexCharacteristic = [JRBLESDK getSDKToolInstance].musicCharacteristic;
    
    [[BLE_Tool sharedTool] writeValueWithCharacteristic:currentPeripheral andCharacteristic:songIndexCharacteristic andValue:data andResponseWriteType:CBCharacteristicWriteWithResponse];
}



@end
