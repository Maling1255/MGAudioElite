//
//  MGAudioPlayTool.h
//  MGAudioElite
//
//  Created by maling on 2019/5/27.
//  Copyright © 2019 maling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGAudioPlayTool : NSObject

+ (instancetype)sharedAudioPlayTool;

/**
 播放音频内容

 @param group 播放数组（需要播放的音频文件）
 */
- (void)playMusiceWithGroup:(NSArray <NSString *> *)group;
- (void)playMusiceWithName:(NSString *)musiceName;

/**
 设置播放音量

 @param volume 音量大小（0-1）
 @param musiceName 音频名字
 */
- (void)setupPlayerVolume:(CGFloat)volume musiceName:(NSString *)musiceName;
- (void)setupPlayerVolume:(CGFloat)volume;

- (void)playMusiceForPauseState;
- (void)pauseAllNowPlayingPlayer;
- (void)removePlayingMusicePlayer;
- (void)removePlayingMusiceName:(NSString *)musiceName;

@end

NS_ASSUME_NONNULL_END
