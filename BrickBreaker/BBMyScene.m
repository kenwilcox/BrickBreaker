//
//  BBMyScene.m
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/20/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "BBMyScene.h"
#import "BBImages.h"
#import "BBImages+SpriteKit.h"
#import "BBBrick.h"
#import "BBMenu.h"

@interface BBMyScene()
@property (nonatomic) int lives;
@property (nonatomic) int currentLevel;
@end

@implementation BBMyScene
{
  SKSpriteNode *_paddle;
  SKLabelNode *_levelDisplay;
  CGPoint _touchLocation;
  CGFloat _ballSpeed;
  SKNode *_brickLayer;
  BOOL _ballReleased;
  BOOL _positionBall;
  NSArray *_hearts;
  BBMenu *_menu;
}

static const uint32_t kBallCategory = 0x1 << 0;
static const uint32_t kPaddleCategory = 0x1 << 1;
static NSString * const kKeyBall = @"ball";
static const int kFinalLevelNumber = 3;

- (id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    // Turn off gravity
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    // Set contact delgate
    self.physicsWorld.contactDelegate = self;
    
    // Setup edge
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, -128, size.width, size.height + 100)];
    
    // Add HUD bar
    SKSpriteNode *bar = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(size.width, 28)];
    bar.position = CGPointMake(0, size.height);
    bar.anchorPoint = CGPointMake(0, 1);
    [self addChild:bar];
    
    // Setup level display
    _levelDisplay = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
    _levelDisplay.fontColor = [SKColor whiteColor];
    _levelDisplay.fontSize = 15;
    _levelDisplay.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _levelDisplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _levelDisplay.position = CGPointMake(10, -10);
    [bar addChild:_levelDisplay];
    
    // Setup brick layer
    _brickLayer = [SKNode node];
    _brickLayer.position = CGPointMake(0, self.size.height -28);
    [self addChild:_brickLayer];
    
    // Setup hearts
    _hearts = @[[BBImages nodeFromImage:[BBImages imageOfHeartFull]],
                [BBImages nodeFromImage:[BBImages imageOfHeartFull]]];
    for (NSUInteger i = 0; i < _hearts.count; i++) {
      SKSpriteNode *heart = (SKSpriteNode*)_hearts[i];
      heart.size = CGSizeMake(26.0, 22.0);
      heart.position = CGPointMake(self.size.width - (16 + (29 * i)), self.size.height - 14);
      [self addChild:heart];
    }
    
    // Setup the paddle
    _paddle = [BBImages nodeFromImage:[BBImages imageOfPaddle]];
    _paddle.position = CGPointMake(self.size.width * 0.5, 90);
    _paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_paddle.size];
    _paddle.physicsBody.dynamic = NO;
    _paddle.physicsBody.categoryBitMask = kPaddleCategory;
    [self addChild:_paddle];
    
    // Setup menu
    _menu = [[BBMenu alloc] init];
    _menu.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    [self addChild:_menu];
    
    // Setup initial values
    _ballSpeed = 250.0;
    _ballReleased = NO;
    self.currentLevel = 1;
    self.lives = 2;
    
    [self loadLevelNumber:self.currentLevel];
    [self newBall];

  }
  return self;
}

#pragma mark Setters

- (void)setLives:(int)lives
{
  _lives = lives;
  for (NSUInteger i = 0; i < _hearts.count; i++) {
    SKSpriteNode *heart = (SKSpriteNode*)_hearts[i];
    if (lives > i) {
      heart.texture = [SKTexture textureWithImage:[BBImages imageOfHeartFull]];
    } else {
      heart.texture = [SKTexture textureWithImage:[BBImages imageOfHeartEmpty]];
    }
  }
}

- (void)setCurrentLevel:(int)currentLevel
{
  _currentLevel = currentLevel;
  _levelDisplay.text = [NSString stringWithFormat:@"LEVEL %d", currentLevel];
}

#pragma mark Game Methods

- (void)loadLevelNumber:(int)levelNumber
{
  [self loadLevel:[@(levelNumber) stringValue]];
}

- (void)loadLevel:(NSString *)levelName
{
  [_brickLayer removeAllChildren];
  
  NSURL *filePath = [[NSBundle mainBundle] URLForResource:levelName withExtension:@"json"];
  if (filePath) {
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:[filePath path]];
    NSError *error;
    NSMutableArray *level = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (!error) {
      int row = 0;
      int col = 0;
      // Maybe this should be for and not for in, limit rows and columns...
      for (NSArray *rowBricks in level) {
        col = 0;
        for (NSNumber *brickType in rowBricks) {
          if ([brickType intValue] > 0) {
            BBBrick *brick = [[BBBrick alloc] initWithType:(BrickType)[brickType intValue]];
            if (brick) {
              brick.position = CGPointMake(2 + (brick.size.width * 0.5) + ((brick.size.width + 3) * col)
                                           , -(2 + (brick.size.height * 0.5) + ((brick.size.height + 3) * row)));
              [_brickLayer addChild:brick];
            }
          }
          col++;
        }
        row++;
      }
    } else {
      NSLog(@"JSONObjectWithData error: %@", error);
    }
  } else {
    self.currentLevel = 1;
  }
}

- (BOOL)isLevelComplete
{
  // Look for remaining bricks that are not indestructible
  for (SKNode *node in _brickLayer.children) {
    if ([node isKindOfClass:[BBBrick class]]) {
      if (!((BBBrick*)node).indestructible) {
        return NO;
      }
    }
  }
  // Couldn't find any non-indestructible bricks
  return YES;
}

#pragma mark Generators

- (void)newBall
{
  [self enumerateChildNodesWithName:kKeyBall usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  
  // Create positioning ball
  SKSpriteNode *ball = [BBImages nodeFromImage:[BBImages imageOfBall]];
  ball.position = CGPointMake(0, _paddle.size.height);
  [_paddle addChild:ball];
  _ballReleased = NO;
  _paddle.position = CGPointMake(self.size.width * 0.5, _paddle.position.y);
}

- (SKSpriteNode*)createBallWithLocation:(CGPoint)position andVelocity:(CGVector)velocity
{
  SKSpriteNode *ball = [BBImages nodeFromImage:[BBImages imageOfBall]];
  ball.name = kKeyBall;
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (_positionBall) {
    _positionBall = NO;
    _ballReleased = YES;
    [_paddle removeAllChildren];
    [self createBallWithLocation:CGPointMake(_paddle.position.x, _paddle.position.y + _paddle.size.height) andVelocity:CGVectorMake(0, _ballSpeed)];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches) {
    if (!_ballReleased) {
      _positionBall = YES;
    }
    _touchLocation = [touch locationInNode:self];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
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

- (void)update:(CFTimeInterval)currentTime
{
  /* Called before each frame is rendered */
  if ([self isLevelComplete]) {
    self.currentLevel++;
    if (self.currentLevel > kFinalLevelNumber) {
      self.currentLevel = 1;
      self.lives = 2;
    }
    [self loadLevelNumber:self.currentLevel];
    [self newBall];
  }
  else if (_ballReleased && !_positionBall && ![self childNodeWithName:kKeyBall]) {
    // Lost all balls
    self.lives--;
    if (self.lives < 0) {
      self.lives = 2;
      self.currentLevel = 1;
      [self loadLevelNumber:self.currentLevel];
    }
    [self newBall];
  }
}

#pragma mark SKScene overrides

-(void)didSimulatePhysics
{
  [self enumerateChildNodesWithName:kKeyBall usingBlock:^(SKNode *node, BOOL *stop) {
    if (node.frame.origin.y + node.frame.size.height < 0) {
      // Lost ball
      [node removeFromParent];
    }
  }];
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
    if ([secondBody.node respondsToSelector:@selector(hit)]) {
      [secondBody.node performSelector:@selector(hit)];
    }
  }
  
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
  
}
@end
