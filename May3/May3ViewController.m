//
//  May3ViewController.m
//  May3
//
//  Created by Daniel Walsh on 5/2/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "May3ViewController.h"
#import "View.h"

@implementation May3ViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
	self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
	if (self) {
		// Custom initialization
        self.navigationItem.title = @"Fakeout";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                  target: nil
                                                  action: NULL
                                                  ];
    }
    return self;
}

- (void) didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
    
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) loadView
{
	CGRect frame = [UIScreen mainScreen].applicationFrame;
	self.view = [[View alloc] initWithFrame: frame];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSLog(@"bundle.bundlePath == \"%@\"", bundle.bundlePath);	
    
    NSString *filename = [bundle pathForResource: @"beep" ofType: @"mp3"];
    NSLog(@"filename == \"%@\"", filename);
    
    NSURL *url = [NSURL fileURLWithPath: filename isDirectory: NO];
    NSLog(@"url == \"%@\"", url);
    
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sid);
    if (error != kAudioServicesNoError) {
        NSLog(@"AudioServicesCreateSystemSoundID error == %ld", error);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(beep:) 
                                                 name:@"beep" 
                                               object:nil];
}
- (void) beep: (NSNotification *) notification {
    
    AudioServicesPlaySystemSound(sid);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    displayLink = [CADisplayLink displayLinkWithTarget: self.view
                                              selector: @selector(move:)
                   ];
    
	//Call move: every time the display is refreshed.
	displayLink.frameInterval = 1;
    
	NSRunLoop *loop = [NSRunLoop currentRunLoop];
	[displayLink addToRunLoop: loop forMode: NSDefaultRunLoopMode];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) dealloc {
	NSRunLoop *loop = [NSRunLoop currentRunLoop];
	[displayLink removeFromRunLoop: loop forMode: NSDefaultRunLoopMode];
}

@end
