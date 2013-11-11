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
        titleLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size: 14];
        titleLabel.numberOfLines = 0;
        [titleLabel sizeToFit];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [title objectForKey:@"$t"];
        //////title code END//////
        
        //////THIS IS BROKEN STILL author code START//////
        NSArray * author = [e objectForKey:@"author"];
        NSDictionary * name = [author objectAtIndex:0];
        UILabel * authorLabel;//label to hold video titles;
        authorLabel = [[UILabel alloc]init];
        authorLabel.font = [UIFont fontWithName: @"Helvetica" size: 14];
        authorLabel.numberOfLines = 0;
        [authorLabel sizeToFit];
        authorLabel.textAlignment = NSTextAlignmentLeft;
        authorLabel.text = [NSString stringWithFormat:@"Author: %@", [name objectForKey:@"$t"]];
        //////author code END//////
        
        //////View count code START//////
        NSDictionary * viewCount = [e objectForKey:@"yt$statistics"];
        UILabel * viewCountLabel;//label to hold view counts;
        viewCountLabel = [[UILabel alloc]init];
        viewCountLabel.font = [UIFont fontWithName: @"Helvetica" size: 14];
        viewCountLabel.numberOfLines = 0;
        [viewCountLabel sizeToFit];
        viewCountLabel.textAlignment = NSTextAlignmentLeft;
        viewCountLabel.text = [NSString stringWithFormat:@"View Count: %d", [viewCount objectForKey:@"viewCount"]];
        //////View count code END//////
        
        /////thumbnail image code START///////////
        NSDictionary * mediaGroup = [e objectForKey:@"media$group"];
        NSArray * mediaThumbnail = [mediaGroup objectForKey:@"media$thumbnail"];
        NSDictionary * thumb = [mediaThumbnail objectAtIndex:0];
        UIImageView *thumbImage;
        thumbImage =
        [[UIImageView alloc]initWithImage:
         [UIImage imageWithData:
          [NSData dataWithContentsOfURL:
           [NSURL URLWithString:(NSString *) [thumb objectForKey:@"url"]]]]];
        /////thumbnail image code END///////////////////
        
        /////video description code START///////////////
        NSDictionary * mediaDescription = [mediaGroup objectForKey:@"media$description"];
        UILabel * descriptionLabel;//label to hold video description
        descriptionLabel = [[UILabel alloc]init];
        descriptionLabel.font = [UIFont fontWithName: @"Helvetica" size: 12];
        descriptionLabel.numberOfLines = 5;
        [descriptionLabel sizeToFit];
        descriptionLabel.textAlignment = NSTextAlignmentLeft;
        descriptionLabel.text = [NSString stringWithFormat:@"Description: %@", [mediaDescription objectForKey:@"$t"]];
        
        /////video description code END/////////////////
        
        /////Video URL code START///////////
        NSArray * mediaContent = [mediaGroup objectForKey:@"media$content"];
        NSDictionary * dictionaryContainingURL = [mediaContent objectAtIndex:0];
        MyButton *urlButton = [MyButton buttonWithType:UIButtonTypeRoundedRect];
        urlButton.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.3, self.view.frame.size.height * 0.1);
        [urlButton.titleLabel setTextColor:[UIColor blackColor]];
        [urlButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [urlButton setTitle:@"Watch Video" forState:UIControlStateNormal];
        urlButton.hidden = NO;
        [urlButton addTarget:self
                      action:@selector(buttonAction:)
            forControlEvents:UIControlEventTouchUpInside];
        urlButton.url = [NSURL URLWithString:(NSString *) [dictionaryContainingURL objectForKey:@"url"]];
        /////Video URL code END///////////////////
        
        CGFloat yOrigin = entryCount * self.view.frame.size.width;
        UIView *awesomeView = [[UIView alloc] initWithFrame:
                               CGRectMake(yOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [scroll addSubview:awesomeView];
        
        titleLabel.frame = CGRectMake(0, 0, self.view.frame.size.width*.8, 100);
        titleLabel.center = CGPointMake(yOrigin + self.view.frame.size.width/2, 50);
        
        thumbImage.frame =
        CGRectMake(yOrigin + self.view.frame.size.width*.05, self.view.frame.size.height*.15, self.view.frame.size.width * 0.9, self.view.frame.size.height * 0.5);
        thumbImage.contentMode = UIViewContentModeScaleAspectFit;
        
        authorLabel.frame = CGRectMake(0, 0, self.view.frame.size.width*.8, 100);
        authorLabel.center = CGPointMake(yOrigin + self.view.frame.size.width/2, self.view.frame.size.height*.65);
        
        viewCountLabel.frame = CGRectMake(0, 0, self.view.frame.size.width*.8, 100);
        viewCountLabel.center = CGPointMake(yOrigin + self.view.frame.size.width/2, self.view.frame.size.height*.7);
        
        descriptionLabel.frame = CGRectMake(0, 0, self.view.frame.size.width*.95, 100);
        descriptionLabel.center = CGPointMake(yOrigin + self.view.frame.size.width/2, self.view.frame.size.height*.8);
        
        urlButton.center = CGPointMake(yOrigin + self.view.frame.size.width/2, self.view.frame.size.height*.9);

        [scroll addSubview:titleLabel];
        [scroll addSubview:thumbImage];
        [scroll addSubview:authorLabel];
        [scroll addSubview:viewCountLabel];
        [scroll addSubview:descriptionLabel];
        [scroll addSubview:urlButton];
    
        ////////////////////////////finally increment the count
        entryCount++;
    }
    
     scroll.contentSize = CGSizeMake(self.view.frame.size.width * entry.count, self.view.frame.size.height);
     [self.view addSubview:scroll];
}
-(void) buttonAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[(MyButton *)sender url]];
    NSLog(@"URL from button: %@", [(MyButton *)sender url]);
}
    
@end
