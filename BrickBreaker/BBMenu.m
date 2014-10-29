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
  SKLabelNode *_panelText;
  SKLabelNode *_buttonText;
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
    
    _panelText = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    _panelText.text = @"LEVEL 1";
    _panelText.fontColor = [SKColor grayColor];
    _panelText.fontSize = 15;
    _panelText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [_menuPanel addChild:_panelText];
    
    _playButton = [BBImages nodeFromImage:[BBImages imageOfButton]];
    _playButton.size = CGSizeMake(142, 36.5);
    _playButton.position = CGPointMake(0, -((_menuPanel.size.height * 0.5) + (_playButton.size.height * 0.5) + 10));
    [self addChild:_playButton];
    
    _buttonText = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    _buttonText.text = @"PLAY";
    _buttonText.position = CGPointMake(0, 2);
    _buttonText.fontColor = [SKColor grayColor];
    _buttonText.fontSize = 15;
    _buttonText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [_playButton addChild:_buttonText];
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
