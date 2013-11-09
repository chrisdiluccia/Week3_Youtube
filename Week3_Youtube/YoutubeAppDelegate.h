//
//  YoutubeAppDelegate.h
//  Week3_Youtube
//
//  Created by Christopher J Di Luccia on 11/6/13.
//  Copyright (c) 2013 Christopher J Di Luccia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIScrollViewViewController;

@interface YoutubeAppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    UIScrollViewViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIScrollViewViewController *viewController;

@end
