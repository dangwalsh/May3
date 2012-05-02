//
//  View.h
//  May3
//
//  Created by Daniel Walsh on 5/2/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@class May3ViewController;
@class BrickView;

@interface View: UIView {
    UILabel *label;
	UIView *paddle;
	UIView *ball;
	CGFloat dx, dy;	    
    NSUInteger counter;
    NSUInteger total;    
    BOOL bounced;
    NSMutableArray *array;
    SystemSoundID sid;	
}

- (void) move: (CADisplayLink *) displayLink;
- (void) place: (BrickView *) brickView atRow: (NSUInteger) row col: (NSUInteger) col;

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) NSUInteger n;
@property (nonatomic, assign) NSUInteger score;

@end
