//
//  BBMyScene.m
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/20/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "BBMyScene.h"
#import "Images.h"

@implementation BBMyScene
{
  SKSpriteNode *_paddle;
  CGPoint _touchLocation;
}

static const uint32_t kBallCategory = 0x1 << 0;
static const uint32_t kPaddleCategory = 0x1 << 1;

- (id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    // Setup the paddle
    _paddle = [self nodeFromImage:[Images imageOfPaddle]];
    _paddle.position = CGPointMake(self.size.width * 0.5, 90);
    _paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_paddle.size];
    _paddle.physicsBody.dynamic = NO;
    _paddle.physicsBody.categoryBitMask = kPaddleCategory;
    [self addChild:_paddle];
    
    // Turn off gravity
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    // Set contact delgate
    self.physicsWorld.contactDelegate = self;
    
    // Setup edge
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    [self createBallWithLocation:CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
                     andVelocity:CGVectorMake(40, 180)];
    
  }
  return self;
}

#pragma mark Generators

- (SKSpriteNode*)nodeFromImage:(UIImage*)image {
  // All the images are twice the size as I want. I'm not sure why yet...
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
  CGFloat scale = [[UIScreen mainScreen] scale];
  [node setScale:1 / scale];
  return node;
}

- (SKSpriteNode*)createBallWithLocation:(CGPoint)position andVelocity:(CGVector)velocity
{
  SKSpriteNode *ball = [self nodeFromImage:[Images imageOfBall]];
  ball.name = @"ball";
  ball.position = position;
  ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width * 0.5];
  ball.physicsBody.friction = 0.0;
  ball.physicsBody.linearDamping = 0.0;
  ball.physicsBody.restitution = 1.0;
  ball.physicsBody.velocity = velocity;
  ball.physicsBody.categoryBitMask = kBallCategory;
  ball.physicsBody.contactTestBitMask = kPaddleCategory;
  [self addChild:ball];
  return ball;
}

#pragma mark SKNode Receivers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  /* Called when a touch begins */
  for (UITouch *touch in touches) {
    _touchLocation = [touch locationInNode:self];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    // Calculate how far touch has moved on x axis
    CGFloat xMovement = [touch locationInNode:self].x - _touchLocation.x;
    // Move paddle distance of touch
    _paddle.position = CGPointMake(_paddle.position.x + xMovement, _paddle.position.y);
    
    CGFloat paddleMinX = -_paddle.size.width * 0.25;
    CGFloat paddleMaxX = self.size.width + (_paddle.size.width * 0.25);
    // Cap paddle's position so it remains on screen
    if (_paddle.position.x < paddleMinX) {
      _paddle.position = CGPointMake(paddleMinX, _paddle.position.y);
    }
    if (_paddle.position.x > paddleMaxX) {
      _paddle.position = CGPointMake(paddleMaxX, _paddle.position.y);
    }
    
    _touchLocation = [touch locationInNode:self];
  }
}

- (void)update:(CFTimeInterval)currentTime {
  /* Called before each frame is rendered */
}

#pragma mark SKPhysicsContactDelegates

- (void)didBeginContact:(SKPhysicsContact *)contact
{
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
  
}
@end
