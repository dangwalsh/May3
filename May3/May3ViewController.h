//
//  May3ViewController.h
//  May3
//
//  Created by Daniel Walsh on 5/2/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>	//for CADisplayLink
#import <AudioToolbox/AudioToolbox.h>

@interface May3ViewController : UIViewController {
    CADisplayLink *displayLink;
    SystemSoundID sid;
}

- (void) beep: (NSNotification *) notification;

@end
