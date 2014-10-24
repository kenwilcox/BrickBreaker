//
//  BBImages.h
//  BrickBreaker
//
//  Created by Kenneth Wilcox on 10/24/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface BBImages : NSObject

// iOS Controls Customization Outlets
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* paddleTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* ballTargets;
@property(strong, nonatomic) IBOutletCollection(NSObject) NSArray* brickTargets;

// Colors
+ (UIColor*)ballBottomColor;
+ (UIColor*)lightColor;
+ (UIColor*)bottomColor;
+ (UIColor*)edgeColor;
+ (UIColor*)ballBorderColor;
+ (UIColor*)ballGlowColor;
+ (UIColor*)ballReflectionColor;
+ (UIColor*)topColor;
+ (UIColor*)darkColor;

// Drawing Methods
+ (void)drawPaddle;
+ (void)drawBall;
+ (void)drawBrickWithBrickColor: (UIColor*)brickColor;

// Generated Images
+ (UIImage*)imageOfPaddle;
+ (UIImage*)imageOfBall;
+ (UIImage*)imageOfBrickWithBrickColor: (UIColor*)brickColor;

@end
