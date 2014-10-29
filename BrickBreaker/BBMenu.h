//
//  BBMenu.h
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/27/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static NSString * const kKeyPlayButton = @"Play Button";

@interface BBMenu : SKNode

@property (nonatomic) int levelNumber;
-(void)hide;
-(void)show;

@end
