//
//  BBMyScene.m
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/20/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "BBMyScene.h"
#import "Images.h"

@implementation BBMyScene
{
  SKSpriteNode *_paddle;
  CGPoint _touchLocation;
}

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    // Setup the paddle
    UIImage* theImage = [Images imageOfPaddle];
    _paddle = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:theImage]];
    _paddle.size = CGSizeMake(_paddle.size.width * 0.5, _paddle.size.height * 0.5);
    _paddle.position = CGPointMake(self.size.width * 0.5, 90);
    [self addChild:_paddle];
    
  }
  return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  /* Called when a touch begins */
  for (UITouch *touch in touches) {
    _touchLocation = [touch locationInNode:self];
  }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    // Calculate how far touch has moved on x axis
    CGFloat xMovement = [touch locationInNode:self].x - _touchLocation.x;
    // Move paddle distance of touch
    _paddle.position = CGPointMake(_paddle.position.x + xMovement, _paddle.position.y);
    
    CGFloat paddleMinX = -_paddle.size.width * 0.25;
    CGFloat paddleMaxX = self.size.width + (_paddle.size.width * 0.25);
    // Cap paddle's position so it remains on screen
    if (_paddle.position.x < paddleMinX) {
      _paddle.position = CGPointMake(paddleMinX, _paddle.position.y);
    }
    if (_paddle.position.x > paddleMaxX) {
      _paddle.position = CGPointMake(paddleMaxX, _paddle.position.y);
    }
    
    _touchLocation = [touch locationInNode:self];
  }
}

-(void)update:(CFTimeInterval)currentTime {
  /* Called before each frame is rendered */
}

@end
