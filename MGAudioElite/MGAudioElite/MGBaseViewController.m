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



@end

/**
 
 遗留问题：
 进入后台 视频会暂停播放， 进入到前台需要继续播放
 
 
 //耳机插入和拔掉通知
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
 
 //耳机插入、拔出事件
 - (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
 NSDictionary *interuptionDict = notification.userInfo;
 
 NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
 
 switch (routeChangeReason) {
 
 case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
 
 break;
 
 case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
 {
 //判断为耳机接口
 AVAudioSessionRouteDescription *previousRoute =interuptionDict[AVAudioSessionRouteChangePreviousRouteKey];
 
 AVAudioSessionPortDescription *previousOutput =previousRoute.outputs[0];
 NSString *portType =previousOutput.portType;
 
 if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
 // 拔掉耳机继续播放
 if (self.playing) {
 
 [self.player play];
 }
 }
 
 }
 break;
 
 case AVAudioSessionRouteChangeReasonCategoryChange:
 // called at start - also when other audio wants to play
 
 break;
 }
 }
 
 
 作者：卢三
 链接：https://juejin.im/post/5a445aa16fb9a0452846c900
 来源：掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 
 //中断的通知
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
 //中断事件
 - (void)handleInterruption:(NSNotification *)notification{
 
 NSDictionary *info = notification.userInfo;
 //一个中断状态类型
 AVAudioSessionInterruptionType type =[info[AVAudioSessionInterruptionTypeKey] integerValue];
 
 //判断开始中断还是中断已经结束
 if (type == AVAudioSessionInterruptionTypeBegan) {
 //停止播放
 [self.player pause];
 
 }else {
 //如果中断结束会附带一个KEY值，表明是否应该恢复音频
 AVAudioSessionInterruptionOptions options =[info[AVAudioSessionInterruptionOptionKey] integerValue];
 if (options == AVAudioSessionInterruptionOptionShouldResume) {
 //恢复播放
 [self.player play];
 }
 
 }
 
 }
 
 
 作者：卢三
 链接：https://juejin.im/post/5a445aa16fb9a0452846c900
 来源：掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 
 */

@implementation MGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_contentView];

    [self setVideoView];
}

- (void)setImageBackgroundView
{
    for (UIView *subview in _contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    bgImageView.frame = _contentView.bounds;
    bgImageView.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:bgImageView];
}

- (void)setVideoView
{
    for (UIView *subview in _contentView.subviews) {
        [subview removeFromSuperview];
    }
    MGVideoBackView *videoView = [[MGVideoBackView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:videoView];
   
}

@end

@interface MGVideoBackView ()

@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;

@end
@implementation MGVideoBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor cyanColor];
        //本地视频路径
        NSString* localFilePath=[[NSBundle mainBundle]pathForResource:@"video_2" ofType:@"mp4"];
        NSURL *localVideoUrl = [NSURL fileURLWithPath:localFilePath];
        
        UIImage *image = [self firstFrameWithVideoURL:localVideoUrl size:self.bounds.size];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:localVideoUrl];
        self.currentPlayerItem = playerItem;
        self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        self.player.muted = YES;
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        avLayer.videoGravity = AVLayerVideoGravityResize;
        avLayer.frame = self.bounds;
        [self.layer addSublayer:avLayer];
        [self.player play];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [imageView removeFromSuperview];
        });
    }
    return self;
}

- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

- (void)moviePlayDidEnd:(NSNotification*)notification
{
    AVPlayerItem*item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc: %s", __func__);
}

@end
