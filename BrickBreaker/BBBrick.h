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
  Yellow = 4,
  Red = 5,
  Purple = 6,
} BrickType;

static const uint32_t kBrickCategory = 0x1 << 2;

@interface BBBrick : SKSpriteNode

@property (nonatomic) BrickType type;
@property (nonatomic) SKTexture* initialTexture;
@property (nonatomic) BOOL indestructible;
@property (nonatomic) BOOL spawnsExtraBall;
@property (nonatomic) BOOL expolding;
@property (nonatomic) CGPoint point;

- (instancetype)initWithType:(BrickType)type;
- (void)hit;

@end
