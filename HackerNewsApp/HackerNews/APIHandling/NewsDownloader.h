//
//  TextDownloader.h
//  Quzipedia
//
//  Created by akshay bansal on 1/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NewsDownloaderDelegate <NSObject>
- (void)UpdateUI;



@end


@interface NewsDownloader : NSObject
+(instancetype)sharedInstance;
- (void)loadTopStories;
-(void)fetchNextStories;
-(BOOL)numberOfRemainingStories;

@property (nonatomic, weak) id <NewsDownloaderDelegate> delegate;
@end


