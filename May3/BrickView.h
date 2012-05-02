//
//  BrickView.h
//  May3
//
//  Created by Daniel Walsh on 5/2/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class View;

@interface BrickView : UIView {
    View *view;
    NSUInteger row;	//current position of this tile
	NSUInteger col;
}
- (id) initWithView: (View *) v row: (NSUInteger) r col: (NSUInteger) c;
@end
