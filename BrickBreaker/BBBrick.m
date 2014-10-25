//
//  BBBrick.m
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "BBBrick.h"
#import "BBImages.h"
#import "BBImages+SpriteKit.h"

@implementation BBBrick
{
  UIColor *purpleBrickColor;
  UIColor *redBrickColor;
  UIColor *yellowBrickColor;
  UIColor *greenBrickColor;
  UIColor *blueBrickColor;
  UIColor *grayBrickColor;
}

- (instancetype)initWithType:(BrickType)type
{
  purpleBrickColor = [UIColor colorWithRed:0.435 green:0.263 blue:0.512 alpha:1];
  redBrickColor = [UIColor colorWithRed:0.924 green:0.118 blue:0.166 alpha:1];
  yellowBrickColor = [UIColor colorWithRed:0.995 green:0.764 blue:0.037 alpha:1];
  greenBrickColor = [UIColor colorWithRed:0.561 green:0.780 blue:0.149 alpha:1];
  blueBrickColor = [UIColor colorWithRed:0.244 green:0.694 blue:0.925 alpha:1];
  grayBrickColor = [UIColor colorWithRed:0.756 green:0.756 blue:0.756 alpha:1];
  
  switch (type) {
    case Purple:
      self = [super initWithTexture:[BBImages brickTextureOfColor:purpleBrickColor]];
      break;
    case Red:
      self = [super initWithTexture:[BBImages brickTextureOfColor:redBrickColor]];
      break;
    case Yellow:
      self = [super initWithTexture:[BBImages brickTextureOfColor:yellowBrickColor]];
      break;
    case Green:
      self = [super initWithTexture:[BBImages brickTextureOfColor:greenBrickColor]];
      break;
    case Blue:
      self = [super initWithTexture:[BBImages brickTextureOfColor:blueBrickColor]];
      break;
    case Gray:
      self = [super initWithTexture:[BBImages brickTextureOfColor:grayBrickColor]];
      break;
    default:
      self = nil;
      break;
  }
  
  if (self) {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = kBrickCategory;
    self.physicsBody.dynamic = NO;
    self.type = type;
  }
  
  return self;
}

-(void)hit
{
  switch (self.type) {
    case Green:
      [self runAction:[SKAction removeFromParent]];
      break;
    case Blue:
      self.texture = [BBImages brickTextureOfColor:greenBrickColor];
      self.type = Green;
      break;
    case Gray:
      break;
    default:
      [self runAction:[SKAction removeFromParent]];
      break;
  }
}

@end
