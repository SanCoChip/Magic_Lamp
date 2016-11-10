//
//  LGSDPlayModel.h
//  CFMusicLight
//
//  Created by user on 16/7/15.
//
//

#import <Foundation/Foundation.h>

/**
 *  歌曲列表加载完成通知
 */
extern NSString *const MusicSongListLoadCompelete;
/**
 *  外设完成歌曲列表加载
 */
extern NSString *const MusicSongListPeripheralLoadCompelete;
//当前歌曲名加载完成通知
extern NSString *const MusicCurrentSongNameLoadCompelete;
//当前状态
extern NSString *const MusicCurrentStateNotification;

//当前点击的行数
extern NSString *const MusicCurrentCurrentIndexNotification;

typedef NS_ENUM(NSInteger,MusicCommand) {
    
    MusicCommandNext = 0,//下一首
    MusicCommandPrev,   //上一首
    MusicCommandPlayAndPause,//播放或暂停
    MusicCommandChangeMusicDevice, //切换歌曲播放源设备
    MusicCommandGetSongList,      //获取歌曲列表
    MusicCommandGetStat,    //查询状态
//    clearMusic    //清除歌曲列表
};

typedef NS_ENUM(NSInteger,MusicPlayMode) {
    
    MusicPlayModeAllPlay = 0, //全曲播放
    MusicPlayModeSinglePlay,   //单曲播放
    MusicPlayModeRandomPlay     //随机播放
};

@interface LGSDPlayModel : NSObject

/**
 *  歌曲列表
 */
@property (strong,nonatomic) NSMutableArray *songListArr;

/**
 *  当前歌曲名
 */
@property (strong,nonatomic) NSString *currentSongName;

//正在播放
@property (assign,nonatomic) BOOL isPlay;

//获取当前总时间
@property (assign,nonatomic)NSInteger  TotalTime;

//获取当前实时播放时间
@property (assign,nonatomic)NSInteger Realtime;

//当前点击的行
@property (assign,nonatomic)NSInteger CurrentIndex;

/**
 *  发送音乐控制命令
 *
 *  @param command 命令
 */
- (void)sendMusicCommandWithCommand:(MusicCommand)command;

/**
 *  设置歌曲播放顺序模式
 *
 *  @param mode 播放顺序模式
 */
- (void)setMusicPlayMode:(MusicPlayMode)mode;
/**
 *  设置当前播放歌曲
 *
 *  @param index 歌曲index
 */
- (void)setMusicPlaySongIndex:(NSInteger)index;



@end
