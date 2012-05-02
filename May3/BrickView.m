//
//  BrickView.m
//  May3
//
//  Created by Daniel Walsh on 5/2/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//


#import "BrickView.h"
#import "View.h"

@implementation BrickView

- (id) initWithView: (View *) v row: (NSUInteger) r col: (NSUInteger) c {
    CGFloat width = v.frame.size.width/v.n - v.margin;
    CGFloat height = width / 2;
    CGRect frame = CGRectMake(0,0, width, height);
    
    self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
        self.backgroundColor = [UIColor whiteColor];
		view = v;
		row = r;
		col = c;
		[view place: self atRow: row col: col];
        
	}
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
