//
//  Images+SpriteKit.m
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "BBImages+SpriteKit.h"

@implementation BBImages (SpriteKitLoader)

+ (SKTexture*)brickTextureOfColor:(UIColor*)color
{
  return [SKTexture textureWithImage:[BBImages imageOfBrickWithBrickColor:color]];
}

+ (SKSpriteNode*)brickOfColor:(UIColor*)color
{
  UIImage *image = [BBImages imageOfBrickWithBrickColor:color];
  return [self nodeFromImage:image];
}

+ (SKSpriteNode*)nodeFromImage:(UIImage*)image
{
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
  return node;
}

@end
