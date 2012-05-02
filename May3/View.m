//
//  View.m
//  May3
//
//  Created by Daniel Walsh on 5/2/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "View.h"
#import "May3ViewController.h"
#import "BrickView.h"

@implementation View

@synthesize margin;
@synthesize n;
@synthesize score;

- (id) initWithFrame: (CGRect) frame
{
	self = [super initWithFrame: frame];
	if (self) {
		// Initialization code
		self.backgroundColor = [UIColor blueColor];
        
        margin = 3;
        n = 9;
        score = 0;
        
        CGRect b = self.bounds;
        NSUInteger xNum = n-1;
        NSUInteger yNum = n-1;
        
        array = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <= xNum; ++i){
            for (int j = 0; j <= yNum; ++j){
                [array addObject:
                 [[BrickView alloc] initWithView: self row: j col: i]];
            }
        }
        
        BrickView *brickView = [array objectAtIndex:1];
        CGSize brickSize = brickView.frame.size;
        CGSize viewSize = self.bounds.size;
        CGFloat half = (n - 1) / 2;
        
        self.bounds = CGRectMake(
                                 half * (brickSize.width  + margin) - viewSize.width  / 2,
                                 -(2 * brickSize.height),
                                 viewSize.width,
                                 viewSize.height
                                 );
        
        for (BrickView *brickView in array) {
            [self addSubview: brickView];
        }
        
		//Create the paddle.
        CGFloat pWidth = viewSize.width / 4;
        
		frame = CGRectMake(
                           (viewSize.width - pWidth) / 2 - pWidth/4, 
                           viewSize.height - viewSize.height / 4, 
                           pWidth, 
                           pWidth/4
                           );
        
		paddle = [[UIView alloc] initWithFrame: frame];
		paddle.backgroundColor = [UIColor whiteColor];
		[self addSubview: paddle];
        
		//Create the ball in the upper left corner of this View.
		frame = CGRectMake(0, 320, 15, 15);
		ball = [[UIView alloc] initWithFrame: frame];
		ball.backgroundColor = [UIColor whiteColor];
		[self addSubview: ball];
        
		//Ball initially moves to lower right.
		dx = -2;
		dy = -2;
        
        NSString *text = [NSString stringWithFormat: @"Score: %u", self.score];
        UIFont *font = [UIFont systemFontOfSize: [UIFont buttonFontSize]];
        CGSize sizeLabel = [text sizeWithFont: font];
        
        CGRect f = CGRectMake(
                              b.origin.x - brickSize.width / 2,
                              b.origin.y - brickSize.width,
                              sizeLabel.width + 30,
                              sizeLabel.height
                              );
        
        label = [[UILabel alloc] initWithFrame: f];
        label.font = font;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = text;
        
        [self addSubview: label];
        
	}
	return self;
}

- (void) place: (BrickView *) brickView atRow: (NSUInteger) row col: (NSUInteger) col;
{
	CGSize size = brickView.bounds.size;
    
	brickView.center = CGPointMake(
                                   col * (size.width  + margin),
                                   row * (size.height + margin)
                                   );
    [self setNeedsDisplay];
}

//Change the ball's direction of motion,
//if necessary to avoid an impending collision.

- (void) bounce {	
	//Where the ball would be if its horizontal motion were allowed
	//to continue for one more move.
	CGRect horizontal = ball.frame;
	horizontal.origin.x += dx;
	
	//Where the ball would be if its vertical motion were allowed
	//to continue for one more move.
	CGRect vertical = ball.frame;
	vertical.origin.y += dy;
    
    CGRect diagonal = ball.frame;
	diagonal.origin.y += dy;
    diagonal.origin.x += dx;
    
    bounced = NO;
	
	//Ball must remain inside self.bounds.
    
    if (!CGRectEqualToRect(horizontal, CGRectIntersection(horizontal, self.bounds))) {
        //Ball will bounce off left or right edge of View.
        dx = -dx;
    }
    
    if (!CGRectEqualToRect(vertical, CGRectIntersection(vertical, self.bounds))) {
        //Ball will bounce off top or bottom edge of View.
        dy = -dy;
    }
	
	//If the ball is not currently intersecting the paddle,
	if (!CGRectIntersectsRect(ball.frame, paddle.frame)) {
		
		//but if the ball will intersect the paddle on the next move,
		if (CGRectIntersectsRect(horizontal, paddle.frame)) {
			dx = -dx;
            [self hit];
		}
		
		if (CGRectIntersectsRect(vertical, paddle.frame)) {
			dy = -dy;
            [self hit];
		} 
        
        if (CGRectIntersectsRect(diagonal, paddle.frame) && bounced == NO) {
			dy = -dy;
            dx = -dx;
            [self hit];
		} 
        
        counter = 0;
        total = array.count;
        
        while (counter < total) {
            
            BrickView *brick = [array objectAtIndex: counter];
            if (CGRectIntersectsRect( horizontal, brick.frame) && bounced == NO) {
                dx = -dx;
                [self hit: brick];
            }
            if (CGRectIntersectsRect(vertical, brick.frame) && bounced == NO) {
                dy = -dy;
                [self hit: brick];
            }
            if (CGRectIntersectsRect(diagonal, brick.frame) && bounced == NO) {
                dy = -dy;
                dx = -dx;
                [self hit: brick];
            }
            
            ++counter;
            
        }
        
	} 
    bounced = NO;
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event {
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView: self];
	CGFloat x = p.x;
	
	//Don't let the paddle move off the bottom or top of the View.
	CGFloat half = paddle.bounds.size.height / 2;
	x = MIN(x, self.bounds.size.width - half); //don't let y get too big
	x = MAX(x, half);                         //don't let y get too small
	
	paddle.center = CGPointMake(x, paddle.center.y);
	[self bounce];
}

- (void) move: (CADisplayLink *) displayLink {
	//NSLog(@"%.15g", displayLink.timestamp);	//15 significant digits
	
	ball.center = CGPointMake(ball.center.x + dx, ball.center.y + dy);
	[self bounce];
}

- (void) hit: (BrickView *) brick {
    bounced = YES;
    brick.hidden = YES;
    --total;
    [array removeObject: brick];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beep" 
                                                        object:nil];
    self.score += 10;
    label.text = [NSString stringWithFormat: @"Score: %u", self.score];
}

-(void) hit {
    bounced = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beep" 
                                                        object:nil];   
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void) drawRect: (CGRect) rect
 {
 // Drawing code
 }
 */

@end
