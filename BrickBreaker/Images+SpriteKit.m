//
//  Images+SpriteKit.m
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "Images+SpriteKit.h"

@implementation Images (SpriteKitLoader)

+ (SKTexture*)brickTextureOfColor:(UIColor*)color
{
  return [SKTexture textureWithImage:[Images imageOfBrickWithBrickColor:color]];
}

+ (SKSpriteNode*)brickOfColor:(UIColor*)color
{
  UIImage *image = [Images imageOfBrickWithBrickColor:color];
  return [self nodeFromImage:image];
}

+ (SKSpriteNode*)nodeFromImage:(UIImage*)image
{
  // All the images are twice the size as I want. I'm not sure why yet...
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
  //  CGFloat scale = [[UIScreen mainScreen] scale];
  //  [node setScale:1 / scale];
  return node;
}

@end
