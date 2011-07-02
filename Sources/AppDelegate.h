//
//  IEURLConnectionAppDelegate.h
//  IEURLConnection
//
//  Created by Igor Evsukov on 02.07.11.
//  Copyright 2011 Igor Evsukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    
    UIImageView *imageView;
    UIProgressView *progressView;
    UIButton *downloadButton;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;

- (void)downloadImage:(id)sender;

@end

