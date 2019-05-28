//
//  ViewController.m
//  MGAudioElite
//
//  Created by maling on 2019/5/27.
//  Copyright © 2019 maling. All rights reserved.
//

#import "ViewController.h"
#import "MGAudioPlayTool.h"
#import "MGAudioTypeOption.h"
@interface ViewController ()


@property (nonatomic, strong) NSMutableArray *musiceNameArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _musiceNameArray = [NSMutableArray array];
//    [[MGAudioPlayTool sharedAudioPlayTool] playMusiceWithGroup:@[@"audio_1", @"audio_2"]];
    [self.view sendSubviewToBack:self.contentView];
}
- (IBAction)setProgressValue:(UISlider *)sender {
    
    NSLog(@"value: %f", sender.value);
    
    [[MGAudioPlayTool sharedAudioPlayTool] setupPlayerVolume:sender.value musiceName:MGAuidoTypeSoundOfTheWind];
}
- (IBAction)setProgressValue2:(UISlider *)sender {
    
    NSLog(@"value2: %f", sender.value);
    
    [[MGAudioPlayTool sharedAudioPlayTool] setupPlayerVolume:sender.value musiceName:MGAuidoTypeFantasy];
}
- (IBAction)clickPlayMusiceBtn:(id)sender {

    NSLog(@"继续播放");
    
    [[MGAudioPlayTool sharedAudioPlayTool] playMusiceForPauseState];
}
- (IBAction)clickStopMusiceBtn:(id)sender {
    
    NSLog(@"暂停播放");
    
    [[MGAudioPlayTool sharedAudioPlayTool] pauseAllNowPlayingPlayer];
}

- (IBAction)addPlayer:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    NSString *name = nil;
    if (sender.tag == 0) {
        name = MGAuidoTypeSoundOfTheWind;
        if(sender.selected) {
            [_musiceNameArray addObject:name];
        } else {
            [_musiceNameArray removeObject:name];
        }
        
    } else if (sender.tag == 1) {
        name = MGAuidoTypeFantasy;
        if(sender.selected) {
            [_musiceNameArray addObject:name];
        } else {
            [_musiceNameArray removeObject:name];
        }
        
    } else if (sender.tag == 2) {
        name = MGAuidoTypeDiSonorant;
        if(sender.selected) {
            [_musiceNameArray addObject:name];
        } else {
            [_musiceNameArray removeObject:name];
        }
        
    } else if (sender.tag == 3) {
        name =MGAuidoType321;
        if(sender.selected) {
            [_musiceNameArray addObject:name];
        } else {
            [_musiceNameArray removeObject:name];
        }
    }
    
    [[MGAudioPlayTool sharedAudioPlayTool] playMusiceWithGroup:_musiceNameArray];
 
    if (!sender.selected) {
        [[MGAudioPlayTool sharedAudioPlayTool] removePlayingMusiceName:name];
    }
}


- (IBAction)clickPattern1:(id)sender {
    
    [self setVideoView];
    [self.view sendSubviewToBack:self.contentView];
}

- (IBAction)clickPattern2:(id)sender {
    
    [self setImageBackgroundView];
    [self.view sendSubviewToBack:self.contentView];
}



@end
