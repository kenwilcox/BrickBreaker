//
//  BBBrick.h
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/23/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
  Green = 1,
  Blue = 2,
  Gray = 3,
  Purple = 4,
  Red = 5,
  Yellow = 6,
} BrickType;

static const uint32_t kBrickCategory = 0x1 << 2;

@interface BBBrick : SKSpriteNode

@property (nonatomic) BrickType type;
@property (nonatomic) BOOL indestructible;

- (instancetype)initWithType:(BrickType)type;
- (void)hit;

@end
