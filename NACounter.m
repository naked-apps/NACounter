//
//  NACounter.m
//  Version 0.1
//
//  Created by Paul Mason on 05/08/11.
//  Copyright 2011 Naked Apps. All rights reserved.
//  @paupino_masano
//
//  A note on redistribution:
//	I'm swell with modifications to this source code, but
//	if you re-publish after editing, please retain the above copyright notices!
//  Have fun :-)

#import "NACounter.h"

#define kTagCounterLeft 4720
#define kTagCounterRight 4721

#define kCounterDigitStartY 22.0
#define kCounterDigitDiff 23.0

@interface NACounter ()

@end

@implementation NACounter

@synthesize currentReading;

- (void) incrementCounter:(BOOL)animate {
    [self updateCounter:(currentReading + 1) animate:animate];
}

- (void) decrementCounter:(BOOL)animate {
    [self updateCounter:(currentReading - 1) animate:animate];
}

- (void) updateCounter:(int)newValue animate:(BOOL)animate {

    // Only do something if it is different
    if (newValue == currentReading)
        return;
    
    // Work out the left and right digit
    int leftDigit = (newValue / 10) % 10;
    int rightDigit = newValue % 10;
    
    // Now animate the left and right values into place
    UIImageView *left = (UIImageView*)[self viewWithTag:kTagCounterLeft];
    UIImageView *right = (UIImageView*)[self viewWithTag:kTagCounterRight];
    
    // Work out a new position
    CGRect leftFrame = left.frame;
    CGRect rightFrame = right.frame;
    CGPoint leftCenter = left.center;
    CGPoint rightCenter = right.center;
    leftFrame.origin.y = kCounterDigitStartY - (leftDigit + 1) * kCounterDigitDiff;
    rightFrame.origin.y = kCounterDigitStartY - (rightDigit + 1) * kCounterDigitDiff;
    leftCenter.y = leftCenterStart.y - (leftDigit + 1) * kCounterDigitDiff;
    rightCenter.y = rightCenterStart.y - (rightDigit + 1) * kCounterDigitDiff;
    
    // Work out which one changes
    BOOL leftChanged = NO;
    BOOL rightChanged = NO;
    if (leftFrame.origin.y != left.frame.origin.y)
        leftChanged = YES;
    if (rightFrame.origin.y != right.frame.origin.y)
        rightChanged = YES;
    
    // Animate and set
    if (leftChanged) {
        CABasicAnimation *leftAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        leftAnim.fromValue = [NSValue valueWithCGPoint:left.center];
        if (leftDigit == 0) {
            leftCenter.y = leftCenterStart.y - 11 * kCounterDigitDiff;
            leftAnim.toValue = [NSValue valueWithCGPoint:leftCenter];
        } else
            leftAnim.toValue = [NSValue valueWithCGPoint:leftCenter];
        leftAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        leftAnim.duration = 0.3;
        [left.layer addAnimation:leftAnim forKey:@"rollLeft"];
        left.frame = leftFrame;
    }
    if (rightChanged) {
        CABasicAnimation *rightAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        rightAnim.fromValue = [NSValue valueWithCGPoint:right.center];
        if (rightDigit == 0) {
            rightCenter.y = rightCenterStart.y - 11 * kCounterDigitDiff;
            rightAnim.toValue = [NSValue valueWithCGPoint:rightCenter];
        } else
            rightAnim.toValue = [NSValue valueWithCGPoint:rightCenter];
        rightAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rightAnim.duration = 0.3;
        [right.layer addAnimation:rightAnim forKey:@"rollRight"];
        right.frame = rightFrame;
    }
    currentReading = newValue;
}

#pragma mark - Init/Dealloc

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Load the background
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nacounter-bg.png"]]];
        [self setOpaque:NO];
        [self.layer setMasksToBounds:YES];
        
        // Load the counters
        UIView *counterCanvas = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 70.0)];
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, kCounterDigitStartY, 17.0, 299.0)];
        [leftImage setImage:[UIImage imageNamed:@"nacounter-numbers.png"]];
        leftCenterStart = leftImage.center;
        [leftImage setTag:kTagCounterLeft];
        [counterCanvas addSubview:leftImage];
        [leftImage release];
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(31.0, kCounterDigitStartY, 17.0, 299.0)];
        [rightImage setImage:[UIImage imageNamed:@"nacounter-numbers.png"]];
        rightCenterStart = rightImage.center;
        [rightImage setTag:kTagCounterRight];
        [counterCanvas addSubview:rightImage];
        [rightImage release];
        
        // Make sure the counter canvas is clipped
        UIImageView *mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nacounter-shadowmask.png"]];
        [counterCanvas.layer setMask:mask.layer];
        [counterCanvas.layer setMasksToBounds:YES];
        [self addSubview:counterCanvas];
        [counterCanvas release];
        [mask release];
        
        // Add a shadow over top
        UIImageView *shadowOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 70.0)];
        [shadowOverlay setImage:[UIImage imageNamed:@"nacounter-shadow.png"]];
        [self addSubview:shadowOverlay];
        [self bringSubviewToFront:shadowOverlay];
        [shadowOverlay release];
        
        // Set the current reading
        currentReading = 99;
    }
    
    return self;
}

@end
