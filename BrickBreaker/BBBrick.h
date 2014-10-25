//
//  BBBrick.h
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
  Purple = 1,
  Red = 2,
  Yellow = 3,
  Green = 4,
  Blue = 5,
  Gray = 6,
} BrickType;

static const uint32_t kBrickCategory = 0x1 << 2;

@interface BBBrick : SKSpriteNode

@property (nonatomic) BrickType type;

- (instancetype)initWithType:(BrickType)type;
- (void)hit;

@end
