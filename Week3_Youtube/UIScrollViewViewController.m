//
//  UIScrollViewViewController.m
//  Week3_Youtube
//
//  Created by Christopher J Di Luccia on 11/6/13.
//  Copyright (c) 2013 Christopher J Di Luccia. All rights reserved.
//

#define SCREEN_WIDTH self.view.frame.size.width
#define SCREEN_HEIGHT self.view.frame.size.height

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
//#define kLatestKivaLoansURL [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"] //2

#define kYouTubeMostPop [NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/standardfeeds/most_popular?v=2&alt=json"]

#import "UIScrollViewViewController.h"

@implementation UIScrollViewViewController

-(void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //////////////////////////////////////
    dispatch_async(kBgQueue, ^{
        
        NSData * data = [NSData dataWithContentsOfURL:kYouTubeMostPop];
        
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    
    int entryCount = 0;//use this value to track the entry count as we loop through it below
    
    //first lets allocate our scroll view
    UIScrollView *scroll = [[UIScrollView alloc]
                            initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    // Snaps to a page
    scroll.pagingEnabled = YES;
    
    
    //now let's parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSDictionary * feed = [json objectForKey:@"feed"];
    
    // Print each item in NSDictionary feed
/*    for (NSString *s in feed) {
        NSLog(@"feed: %@", s );
    }
    
    NSLog(@"\n" );  // Extra space
  */
    NSArray * entry = [feed objectForKey:@"entry"];
    
    ////////////////////////////////////////
    // Loop app entry nodes
    ////////////////////////////////////////
    
    for (NSDictionary *e in entry)
    {
        //////title code START//////
        NSDictionary * title = [e objectForKey:@"title"];
        UILabel * titleLabel;//label to hold video titles;
        titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size: 16];
        titleLabel.numberOfLines = 0;
        [titleLabel sizeToFit];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [title objectForKey:@"$t"];
        //////title code END//////
        
        //////author code START//////
        NSArray * author = [e objectForKey:@"author"];
        NSDictionary * name = [author objectAtIndex:0];
        UILabel * authorLabel;//label to hold video titles;
        authorLabel = [[UILabel alloc]init];
        authorLabel.font = [UIFont fontWithName: @"Helvetica" size: 12];
        authorLabel.numberOfLines = 0;
        [authorLabel sizeToFit];
        authorLabel.textAlignment = NSTextAlignmentCenter;
        authorLabel.text = [name objectForKey:@"$t"];
         NSLog(@"authorLabel is: %@", [name objectForKey:@"$t"]);
        //////author code END//////
        
        /////thumbnail image code START///////////
        NSDictionary * media = [e objectForKey:@"media$group"];
        NSArray * thumbArray = [media objectForKey:@"media$thumbnail"];
        
        NSDictionary * thumb = [thumbArray objectAtIndex:0];
        UIImageView *thumbImage;
        thumbImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[thumb objectForKey:@"url"]]];
        /////thumbnail image code END///////////////////
        
        CGFloat yOrigin = entryCount * self.view.frame.size.width;
        UIView *awesomeView = [[UIView alloc] initWithFrame:
                               CGRectMake(yOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [scroll addSubview:awesomeView];
        
        titleLabel.frame = CGRectMake(yOrigin + self.view.frame.size.width/2, 0, self.view.frame.size.width*.8, 100);
        titleLabel.center = CGPointMake(yOrigin + self.view.frame.size.width/2, 50);
        
        authorLabel.frame = CGRectMake(yOrigin + self.view.frame.size.width/2, 0, self.view.frame.size.width*.8, 100);
        authorLabel.center = CGPointMake(yOrigin + self.view.frame.size.width/2, self.view.frame.size.height-50);
        
        thumbImage.frame =
        CGRectMake(yOrigin + self.view.frame.size.width/2, self.view.frame.size.height/2, self.view.frame.size.width * 0.9, self.view.frame.size.height * 0.5);
        thumbImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [scroll addSubview:titleLabel];
        [scroll addSubview:authorLabel];
        [scroll addSubview:thumbImage];
    
        ////////////////////////////finally increment the count
        entryCount++;
    }
    
     scroll.contentSize = CGSizeMake(self.view.frame.size.width * entry.count, self.view.frame.size.height);
     [self.view addSubview:scroll];
}


@end
