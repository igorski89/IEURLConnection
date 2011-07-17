//
//  AppDelegate.m
//  IEURLConnection
//
//  Created by Igor Evsukov on 02.07.11.
//  Copyright 2011 Igor Evsukov. All rights reserved.
//

#import "AppDelegate.h"
//#import "IEURLConnection.h"
#import "NSURLConnection+BlocksKit.h"

@implementation AppDelegate

@synthesize window;
@synthesize imageView, progressView, downloadButton;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc {
    self.window = nil;
    self.imageView = nil;
    self.progressView = nil;
    self.downloadButton = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark actions handling
- (void)downloadImage:(id)sender {
    self.downloadButton.enabled = NO;
    self.progressView.progress = 0.0f;
    
    //NSURL *imageURL = [NSURL URLWithString:@"http://icanhascheezburger.files.wordpress.com/2011/07/7829987b-2f2e-4d0f-94c4-a3c5af9d9914.jpg"];
    //NSURL *imageURL = [NSURL URLWithString:@"http://www.nasa.gov/images/content/563448main_PIA12515_full.jpg"];
    //NSURL *imageURL = [NSURL URLWithString:@"http://freelargephotos.com/000597_l.jpg"];
    //NSURL *imageURL = [NSURL URLWithString:@"http://www.livejournal.ru/static/files/themes/20017_maru.jpg"];
    NSURL *imageURL = [NSURL URLWithString:@"http://icanhascheezburger.files.wordpress.com/2011/06/funny-pictures-nyan-cat-wannabe1.jpg"];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:imageURL] delegate:self];
    connection.didFailWithErrorHandler = ^(NSError *error) {
        [UIAlertView showAlertWithTitle:@"Download error" message:[error localizedDescription]];
        
        self.downloadButton.enabled = YES;
        self.progressView.progress = 0.0f;
    };
    connection.didFinishLoadingHandler = ^(NSURLResponse *response, NSData *responseData){
        self.imageView.image = [UIImage imageWithData:responseData];
        self.downloadButton.enabled = YES;
    };
    connection.downloadProgressHandler = ^(float progress){
        self.progressView.progress = progress;
    };
    
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}


@end
