//
//  NACounter.h
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

#import <UIKit/UIKit.h>

@interface NACounter : UIControl {
    
    int currentReading;
    CGPoint leftCenterStart;
    CGPoint rightCenterStart;    
}

@property (nonatomic, readonly) int currentReading;

- (void) incrementCounter:(BOOL)animate;
- (void) decrementCounter:(BOOL)animate;
- (void) updateCounter:(int)newValue animate:(BOOL)animate;

@end
