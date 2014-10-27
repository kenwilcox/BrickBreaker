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
      self.color = [UIColor purpleBrickColor];
      break;
    case Red:
      self.color = [UIColor redBrickColor];
      break;
    case Yellow:
      self.color = [UIColor yellowBrickColor];
      break;
    case Green:
      self.color = [UIColor greenBrickColor];
      break;
    case Blue:
      self.color = [UIColor blueBrickColor];
      break;
    case Gray:
      self.color = [UIColor grayBrickColor];
      break;
    default:
      self = nil;
      break;
  }
  
  if (self) {
    self.texture = [BBImages brickTextureOfColor:self.color];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = kBrickCategory;
    self.physicsBody.dynamic = NO;
    self.type = type;
    self.initialTexture = self.texture;
    self.indestructible = (type == Gray);
  }
  
  return self;
}

- (void)hit
{
  switch (self.type) {
    case Green:
      [self createExplosion];
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

- (void)createExplosion
{
//  NSString *path = [[NSBundle mainBundle] pathForResource:@"BrickExplosion" ofType:@"sks"];
//  SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//  explosion.particleTexture = self.texture;
  
  SKEmitterNode *explosion = [SKEmitterNode node];
  explosion.particleTexture = self.initialTexture;
  
  explosion.particleBirthRate = 100;
  explosion.numParticlesToEmit = 10;
  
  explosion.particleLifetime = 1;
  explosion.particleLifetimeRange = 0;
  
  explosion.position = CGPointMake(50, 25);
  explosion.emissionAngle = 89.954;
  explosion.emissionAngleRange = 360.39;
  
  explosion.particleSpeed = 100;
  explosion.particleSpeedRange = 50;
  
  explosion.xAcceleration = 0;
  explosion.yAcceleration = -1000;
  
  explosion.particleScale = 0.2;
  explosion.particleScaleRange = 0.2;
  explosion.particleScaleSpeed = -0.4;
  
  explosion.particleColorSequence = nil;
  explosion.particleColor = self.color;
  explosion.particleBlendMode = SKBlendModeAlpha;
  
  explosion.position = self.position;
  [self.parent addChild:explosion];
  
  SKAction *removeExplosion = [SKAction sequence:@[[SKAction waitForDuration:explosion.particleLifetime + explosion.particleLifetimeRange], [SKAction removeFromParent]]];
  [explosion runAction:removeExplosion];
}

@end
