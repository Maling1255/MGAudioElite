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
        AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
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
    
}

@end
