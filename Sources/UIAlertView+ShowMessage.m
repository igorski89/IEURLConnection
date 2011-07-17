//
//  UIAlertView+ShowMessage.m
//  
//
//  Created by Igor Evsukov on 16.11.10.
//  Copyright 2010 Igor Evsukov. All rights reserved.
//

#import "UIAlertView+ShowMessage.h"


@implementation UIAlertView(ShowMessage)

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alertView show];
}

@end
