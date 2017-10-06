//
//  CommentsDownloader.m
//  HackerNews
//
//  Created by akshay bansal on 9/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "CommentsDownloader.h"
#import "Constants.h"
#import "Story.h"
#import "Comment.h"

@interface CommentsDownloader()
@property NSURLSession *session;
@end

@implementation CommentsDownloader


+(instancetype)sharedInstance{
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(instancetype)init
{
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
    }
    return self;
    
}


-(void)downloadCommentforID:(NSInteger)identifier{
    
    NSURL *topStoriesUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%ld.json?print=pretty",(long)identifier]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:topStoriesUrl];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    request.timeoutInterval=40;
    NSURLSessionDataTask *postDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* userInfo ;
        
        if (!error && data!=nil)
        {
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSError *jsonError=nil;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if (jsonError) {
                    
                    NSLog(@"Json Parsing Error");
                    userInfo = @{@"msg": @"Json Parsing Error"};
                    [[NSNotificationCenter defaultCenter] postNotificationName:Error object:nil userInfo:userInfo];
                }
                else {
                    
                    Story *story = [[Story objectsWhere:@"identifier == %@",[jsonResponse objectForKey:@"parent"]] firstObject];
                    Comment *comment=[[Comment alloc] init];
                    
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    
                    
                    if ([[jsonResponse allKeys] containsObject:@"id"]) {
                        comment.identifier=[jsonResponse objectForKey:@"id"];
                    }
                    
                    if ([[jsonResponse allKeys] containsObject:@"by"]) {
                        comment.userName=[jsonResponse objectForKey:@"by"];
                    }
                    
                    if ([[jsonResponse allKeys] containsObject:@"kids"]) {
                        comment.kids=[[jsonResponse objectForKey:@"kids"] componentsJoinedByString:@","];
                    }
                    
                    if ([[jsonResponse allKeys] containsObject:@"time"]) {
                        comment.time=[jsonResponse objectForKey:@"time"];
                    }
                    if ([[jsonResponse allKeys] containsObject:@"text"]) {
                        comment.text=[jsonResponse objectForKey:@"text"];
                    }
                    if ([[jsonResponse allKeys] containsObject:@"parent"]) {
                        comment.parent=[jsonResponse objectForKey:@"parent"];
                    }
                    if ([[jsonResponse allKeys] containsObject:@"type"]) {
                        comment.type=[jsonResponse objectForKey:@"type"];
                    }
                    
                    [realm transactionWithBlock:^{
                        [story.comments addObject:comment];
                    }];
                    [self.delegate UpdatecommentUIforID:[NSString stringWithFormat:@"%@",[jsonResponse objectForKey:@"id"]]];
                
                    
                    
                    
                }
            }
            else
            {
                [self.delegate UpdatecommentUIforID:@""];
                NSLog(@"Response Error");
                userInfo = @{@"msg": @"Response Error"};
                [[NSNotificationCenter defaultCenter] postNotificationName:Error object:nil userInfo:userInfo];
            }
        }
        else
        {
            [self.delegate UpdatecommentUIforID:@""];
            NSLog(@"error : %@",@[error.localizedDescription]);
            userInfo = @{@"msg":error.localizedDescription};
            [[NSNotificationCenter defaultCenter] postNotificationName:Error object:nil userInfo:userInfo];
        }
    }] ;
    
    [postDataTask resume];
    
    
}





@end
