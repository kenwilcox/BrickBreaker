//
//  BBBrick.m
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "BBBrick.h"
#import "Images.h"
#import "Images+SpriteKit.h"

@implementation BBBrick

- (instancetype)initWithType:(BrickType)type
{
  UIColor *purpleBrickColor = [UIColor colorWithRed:0.435 green:0.263 blue:0.512 alpha:1];
  UIColor *redBrickColor = [UIColor colorWithRed:0.924 green:0.118 blue:0.166 alpha:1];
  UIColor *yellowBrickColor = [UIColor colorWithRed:0.995 green:0.764 blue:0.037 alpha:1];
  UIColor *greenBrickColor = [UIColor colorWithRed:0.561 green:0.780 blue:0.149 alpha:1];
  UIColor *blueBrickColor = [UIColor colorWithRed:0.244 green:0.694 blue:0.925 alpha:1];
  UIColor *grayBrickColor = [UIColor colorWithRed:0.756 green:0.756 blue:0.756 alpha:1];
  
  switch (type) {
    case Purple:
      self = [super initWithTexture:[Images brickTextureOfColor:purpleBrickColor]];
      break;
    case Red:
      self = [super initWithTexture:[Images brickTextureOfColor:redBrickColor]];
      break;
    case Yellow:
      self = [super initWithTexture:[Images brickTextureOfColor:yellowBrickColor]];
      break;
    case Green:
      self = [super initWithTexture:[Images brickTextureOfColor:greenBrickColor]];
      break;
    case Blue:
      self = [super initWithTexture:[Images brickTextureOfColor:blueBrickColor]];
      break;
    case Gray:
      self = [super initWithTexture:[Images brickTextureOfColor:grayBrickColor]];
      break;
    default:
      self = nil;
      break;
  }
  
  if (self) {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = kBrickCategory;
    self.physicsBody.dynamic = NO;
  }
  
  return self;
}

@end
