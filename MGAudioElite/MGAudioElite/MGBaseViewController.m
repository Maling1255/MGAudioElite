//
//  MGBaseViewController.m
//  MGAudioElite
//
//  Created by maling on 2019/5/27.
//  Copyright © 2019 maling. All rights reserved.
//

#import "MGBaseViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface MGBaseViewController ()

@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;

@end

@implementation MGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_contentView];
    
    //本地视频路径
    NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"video_2" ofType:@"mp4"];
    NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:localVideoUrl];
    self.currentPlayerItem = playerItem;
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    self.player.muted = YES;
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    avLayer.frame = self.view.bounds;
    [_contentView.layer addSublayer:avLayer];
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)moviePlayDidEnd:(NSNotification*)notification
{
    AVPlayerItem*item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
