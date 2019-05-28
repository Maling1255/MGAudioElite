//
//  MGAudioPlayTool.m
//  MGAudioElite
//
//  Created by maling on 2019/5/27.
//  Copyright © 2019 maling. All rights reserved.
//

#import "MGAudioPlayTool.h"

@interface MGAudioPlayTool ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *musicePlayer;
@property (nonatomic, strong) NSMutableArray *groupMusicNameArray;
/** 存放暂停&播放的 */
@property (nonatomic, strong) NSMutableArray *playMusiceArray;

@end
@implementation MGAudioPlayTool

/** 存放创建的播放器 */
static NSMutableDictionary *_musicsPlayerDict;

+ (void)initialize {
    _musicsPlayerDict = [NSMutableDictionary dictionary];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}

+ (instancetype)sharedAudioPlayTool
{
    static MGAudioPlayTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)playMusiceWithGroup:(NSArray <NSString *> *)group
{
    [self.groupMusicNameArray removeAllObjects];
    
    if (!group.count) { return; }
    
    [self.groupMusicNameArray addObjectsFromArray:group];
    for (NSString *audioName in self.groupMusicNameArray) {
        [self playMusiceWithName:audioName];
    }
}

- (void)playMusiceWithName:(NSString *)musiceName
{
    if (!musiceName) {
        return;
    }
    AVAudioPlayer *musicePlayer = _musicsPlayerDict[musiceName];
    if (!musicePlayer) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:musiceName withExtension:@"mp3"];
        musicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        musicePlayer.numberOfLoops = -1;
        musicePlayer.volume = 0.1;
        musicePlayer.delegate = self;
        [musicePlayer prepareToPlay];
        self.musicePlayer = musicePlayer;
        _musicsPlayerDict[musiceName] = musicePlayer;
    }
    [musicePlayer play];
}

- (void)setupPlayerVolume:(CGFloat)volume
{
    for (NSString *musiceName in self.groupMusicNameArray) {
        [self setupPlayerVolume:volume musiceName:musiceName];
    }
}

- (void)setupPlayerVolume:(CGFloat)volume musiceName:(NSString *)musiceName
{
    if (!musiceName) { return; }
    AVAudioPlayer *musicePlayer = _musicsPlayerDict[musiceName];
    if (!musicePlayer) { return; }
    musicePlayer.volume = volume;
}

- (void)playMusiceForPauseState
{
    if (!self.playMusiceArray.count) { return; }
    for (NSString *musiceName in self.playMusiceArray) {
        [self playMusiceWithName:musiceName];
    }
}

- (void)pauseAllNowPlayingPlayer
{
    [self.playMusiceArray removeAllObjects];
    [_musicsPlayerDict enumerateKeysAndObjectsUsingBlock:^(NSString *_musiceName, AVAudioPlayer *audioPlayer, BOOL * _Nonnull stop) {
        if (audioPlayer.playing) {
            [audioPlayer pause];
            [self.playMusiceArray addObject:_musiceName];
        }
    }];
}

- (void)removePlayingMusicePlayer
{
    NSMutableArray <NSString *>*stopPlayers = [[NSMutableArray alloc] init];
    [_musicsPlayerDict enumerateKeysAndObjectsUsingBlock:^(NSString *_musiceName, AVAudioPlayer *audioPlayer, BOOL * _Nonnull stop) {
        if (audioPlayer.playing) {
            [audioPlayer stop];
            audioPlayer.currentTime = 0;
            audioPlayer = nil;
            [stopPlayers addObject:_musiceName];
        }
    }];
    if (!stopPlayers.count) { return; }
    [_musicsPlayerDict removeObjectsForKeys:stopPlayers];
}

- (void)removePlayingMusiceName:(NSString *)musiceName
{
    [_musicsPlayerDict enumerateKeysAndObjectsUsingBlock:^(NSString *_musiceName, AVAudioPlayer *audioPlayer, BOOL * _Nonnull stop) {
        if (audioPlayer.playing && [_musiceName isEqualToString:musiceName]) {
            [audioPlayer stop];
            audioPlayer.currentTime = 0;
            audioPlayer = nil;
        }
    }];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@">> %@", player.url);
}

- (NSMutableArray *)groupMusicNameArray
{
    if (!_groupMusicNameArray) {
        _groupMusicNameArray = [[NSMutableArray alloc] init];
    }
    return _groupMusicNameArray;
}

- (NSMutableArray *)playMusiceArray
{
    if (!_playMusiceArray) {
        _playMusiceArray = [[NSMutableArray alloc] init];
    }
    return _playMusiceArray;
}


@end
