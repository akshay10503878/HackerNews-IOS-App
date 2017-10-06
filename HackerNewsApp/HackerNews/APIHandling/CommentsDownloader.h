//
//  CommentsDownloader.h
//  HackerNews
//
//  Created by akshay bansal on 9/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CommentsDownloaderDelegate <NSObject>
- (void)UpdatecommentUIforID:(NSString*)identifier;

@end



@interface CommentsDownloader : NSObject
+(instancetype)sharedInstance;
-(void)downloadCommentforID:(NSInteger)identifier;
@property (nonatomic, weak) id <CommentsDownloaderDelegate> delegate;
@end


