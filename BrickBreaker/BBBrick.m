//
//  BBBrick.m
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "BBBrick.h"
#import "BBBrickColor.h"
#import "BBImages.h"
#import "BBImages+SpriteKit.h"

@implementation BBBrick
{
}

- (instancetype)initWithType:(BrickType)type
{
  // http://blog.wilshipley.com/2005/07/code-insults-mark-i.html
  if (![super initWithTexture:[BBImages brickTextureOfColor:[UIColor grayBrickColor]]])
    return nil;
  
  switch (type) {
    case Purple:
      self.texture = [BBImages brickTextureOfColor:[UIColor purpleBrickColor]];
      break;
    case Red:
      self.texture = [BBImages brickTextureOfColor:[UIColor redBrickColor]];
      break;
    case Yellow:
      self.texture = [BBImages brickTextureOfColor:[UIColor yellowBrickColor]];
      break;
    case Green:
      self.texture = [BBImages brickTextureOfColor:[UIColor greenBrickColor]];
      break;
    case Blue:
      self.texture = [BBImages brickTextureOfColor:[UIColor blueBrickColor]];
      break;
    case Gray:
      // Not necessary - already done
      //self.texture = [BBImages brickTextureOfColor:[UIColor grayBrickColor]];
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
      self.texture = [BBImages brickTextureOfColor:[UIColor greenBrickColor]];
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
