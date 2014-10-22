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
  CGFloat _ballSpeed;
  SKNode *_brickLayer;
}

static const uint32_t kBallCategory = 0x1 << 0;
static const uint32_t kPaddleCategory = 0x1 << 1;
static const uint32_t kBrickCategory = 0x1 << 2;

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
    
    // Setup brick layer
    _brickLayer = [SKNode node];
    _brickLayer.position = CGPointMake(0, self.size.height);
    [self addChild:_brickLayer];
    
    // Add some bricks
    UIColor *purpleBrickColor = [UIColor colorWithRed:0.435 green:0.263 blue:0.512 alpha:1];
//    UIColor *redBrickColor = [UIColor colorWithRed:0.924 green:0.118 blue:0.166 alpha:1];
//    UIColor *yellowBrickColor = [UIColor colorWithRed:0.995 green:0.764 blue:0.037 alpha:1];
//    UIColor *greenBrickColor = [UIColor colorWithRed:0.561 green:0.780 blue:0.149 alpha:1];
//    UIColor *blueBrickColor = [UIColor colorWithRed:0.244 green:0.694 blue:0.925 alpha:1];
//    UIColor *grayBrickColor = [UIColor colorWithRed:0.756 green:0.756 blue:0.756 alpha:1];
    
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 6; col++) {
        SKSpriteNode *brick = [self brickOfColor:purpleBrickColor];
        brick.position = CGPointMake(2 + (brick.size.width * 0.5) + ((brick.size.width + 3) * col)
                                     , -(2 + (brick.size.height * 0.5) + ((brick.size.height + 3) * row)));
        
        brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.size];
        brick.physicsBody.categoryBitMask = kBrickCategory;
        brick.physicsBody.dynamic = NO;
        
        [_brickLayer addChild:brick];
      }
    }
    
    // Turn off gravity
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    // Set contact delgate
    self.physicsWorld.contactDelegate = self;
    
    // Setup edge
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    // Setup initial values
    _ballSpeed = 250.0;
    
    [self createBallWithLocation:CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
                     andVelocity:CGVectorMake(40, 180)];
    
  }
  return self;
}

#pragma mark Generators

- (SKSpriteNode*)brickOfColor:(UIColor*)color {
  UIImage *image = [Images imageOfBrickWithBrickColor:color];
  return [self nodeFromImage:image];
}

- (SKSpriteNode*)nodeFromImage:(UIImage*)image {
  // All the images are twice the size as I want. I'm not sure why yet...
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
//  CGFloat scale = [[UIScreen mainScreen] scale];
//  [node setScale:1 / scale];
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
  ball.physicsBody.contactTestBitMask = kPaddleCategory | kBrickCategory;
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
  SKPhysicsBody *firstBody;
  SKPhysicsBody *secondBody;
  
  if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
    firstBody = contact.bodyB;
    secondBody = contact.bodyA;
  } else {
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
  }
  
  // Ball and Paddle
  if (firstBody.categoryBitMask == kBallCategory && secondBody.categoryBitMask == kPaddleCategory) {
    // Make sure the ball is above the paddle
    if (firstBody.node.position.y > secondBody.node.position.y) {
      // Get contact point in paddle coordinates
      CGPoint pointInPaddle = [secondBody.node convertPoint:contact.contactPoint fromNode:self];
      // Get contact position as a percentage of the paddle's width
      CGFloat x = (pointInPaddle.x + secondBody.node.frame.size.width * 0.5) / secondBody.node.frame.size.width;
      // Cap percentage and flip it
      CGFloat multiplier = 1.0 - fmaxf(fminf(x, 1.0),0.0);
      // Calculate angle based on ball position in paddle
      CGFloat angle = (M_PI_2 * multiplier) + M_PI_4;
      // Convert angle to vector
      CGVector direction = CGVectorMake(cosf(angle), sinf(angle));
      // Set ball's velocity based on direction and speed
      firstBody.velocity = CGVectorMake(direction.dx * _ballSpeed, direction.dy * _ballSpeed);
    }
  }
  
  // Ball and Brick
  if (firstBody.categoryBitMask == kBallCategory && secondBody.categoryBitMask == kBrickCategory) {
    [secondBody.node runAction:[SKAction removeFromParent]];
  }
  
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
  
}
@end
