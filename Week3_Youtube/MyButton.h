//
//  MyButton.h
//  Week3_Youtube
//
//  Created by Christopher J Di Luccia on 11/9/13.
//  Copyright (c) 2013 Christopher J Di Luccia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton
{
    NSURL *urlString;
}

@property (nonatomic, retain) NSURL *url;

@end
