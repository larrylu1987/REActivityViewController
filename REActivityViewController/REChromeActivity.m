//
//  REChromeActivity.m
//  Food(ness)
//
//  Created by Neil Kimmett on 04/06/2013.
//  Copyright (c) 2013 Marks & Spencer. All rights reserved.
//

#import "REChromeActivity.h"
#import "REActivityViewController.h"

@interface REChromeActivity () <UIAlertViewDelegate>

@end

@implementation REChromeActivity

- (id)init
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.Chrome.title", @"REActivityViewController", @"Open in Chrome")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Safari"]
                    actionBlock:nil];
    
    if (!self)
        return nil;
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]]) {
        __typeof(&*self) __weak weakSelf = self;
        self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
            
            NSString *title = NSLocalizedStringFromTable(@"activity.Chrome.dialog.appstore.title", @"REActivityViewController", @"Chrome in App Store");
            NSString *message = NSLocalizedStringFromTable(@"activity.Chrome.dialog.appstore.message", @"REActivityViewController", @"Would you like to be taken to the App Store to install Google Chrome?");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:weakSelf cancelButtonTitle:NSLocalizedStringFromTable(@"button.cancel", @"REActivityViewController", @"Cancel")
                                                      otherButtonTitles:NSLocalizedStringFromTable(@"dismiss", @"REActivityViewController", @"OK"), nil];
            [alertView show];
        };
    }
    else {
        __typeof(&*self) __weak weakSelf = self;
        self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
            [activityViewController dismissViewControllerAnimated:YES completion:nil];
            
            NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
            
            if ([[userInfo objectForKey:@"url"] isKindOfClass:[NSURL class]]) {
                NSURL *URL = [userInfo objectForKey:@"url"];
                NSString *scheme = URL.scheme;
                
                // Replace the URL Scheme with the Chrome equivalent.
                NSString *chromeScheme = nil;
                if ([scheme isEqualToString:@"http"]) {
                    chromeScheme = @"googlechrome";
                } else if ([scheme isEqualToString:@"https"]) {
                    chromeScheme = @"googlechromes";
                }
                
                // Proceed only if a valid Google Chrome URI Scheme is available.
                if (chromeScheme) {
                    NSString *absoluteString = [URL absoluteString];
                    NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
                    NSString *urlNoScheme =
                    [absoluteString substringFromIndex:rangeForScheme.location];
                    NSString *chromeURLString =
                    [chromeScheme stringByAppendingString:urlNoScheme];
                    NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
                    
                    // Open the URL with Chrome.
                    [[UIApplication sharedApplication] openURL:chromeURL];
                }
            }
        };
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    @"itms-apps://itunes.apple.com/us/app/chrome/id535886823"]];
    }
}

@end
