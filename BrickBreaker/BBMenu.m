//
//  BBMenu.m
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/27/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "BBMenu.h"
#import "BBImages.h"
#import "BBImages+SpriteKit.h"

@implementation BBMenu
{
  SKSpriteNode *_menuPanel;
  SKSpriteNode *_playButton;
}

- (instancetype)init
{
  if (!(self = [super init]))
    return nil;
  
  if (self) {
    _menuPanel = [BBImages nodeFromImage:[BBImages imageOfMenuPanel]];
    _menuPanel.position = CGPointZero;
    _menuPanel.size = CGSizeMake(142, 68);
    [self addChild:_menuPanel];
    _playButton = [BBImages nodeFromImage:[BBImages imageOfButton]];
    _playButton.size = CGSizeMake(142, 36.5);
    _playButton.position = CGPointMake(0, -((_menuPanel.size.height * 0.5) + (_playButton.size.height * 0.5) + 10));
    [self addChild:_playButton];
  }
  return self;
}

- (void)show
{
  
}
- (void)hide
{
  
}

@end
