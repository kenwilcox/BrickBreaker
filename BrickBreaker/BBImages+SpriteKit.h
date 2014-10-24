//
//  Images+SpriteKit.h
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BBImages.h"

@interface Images (SpriteKitLoader)

+ (SKTexture*)brickTextureOfColor:(UIColor*)color;
+ (SKSpriteNode*)brickOfColor:(UIColor*)color;
+ (SKSpriteNode*)nodeFromImage:(UIImage*)image;

@end
