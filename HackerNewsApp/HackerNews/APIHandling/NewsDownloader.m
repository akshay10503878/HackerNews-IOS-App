//
//  TextDownloader.m
//  Quzipedia
//
//  Created by akshay bansal on 1/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "NewsDownloader.h"
#import "Constants.h"
@import Firebase;
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "Story.h"
#import "Comment.h"

@interface NewsDownloader(){

    NSInteger storiesFetchLimit;
    NSInteger storiesDownloadedCheck;
    RLMResults *stories;
    

}

@property NSURLSession *session;
@property NSMutableArray *remainingStoriesToDownload;

@end

@implementation NewsDownloader
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
        self.remainingStoriesToDownload=[[NSMutableArray alloc] init];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RemainingStoriesToDownload"]) {
            [self.remainingStoriesToDownload setArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"RemainingStoriesToDownload"]];

        }
    }
    return self;

}


- (void)loadTopStories{
    
    /*-Empty the stories-*/
    [self.remainingStoriesToDownload removeAllObjects];
    
    /*--saving the last downloded time--*/
    NSDate *now = [NSDate date];
    NSNumber *EpochSeconds = [NSNumber numberWithInteger:[now timeIntervalSince1970]];
    [[NSUserDefaults standardUserDefaults] setObject:EpochSeconds forKey:LastDownloadedTime];
    
    /*--to keep track of downloaded stories--*/
    storiesFetchLimit=0;
    
    NSURL *topStoriesUrl=[NSURL URLWithString:@"https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:topStoriesUrl];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* userInfo ;
        
        if (!error && data!=nil)
        {
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSError *jsonError=nil;
                NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if (jsonError) {
                   
                    NSLog(@"Json Parsing Error");
                    userInfo = @{@"msg": @"Json Parsing Error"};
                    [[NSNotificationCenter defaultCenter] postNotificationName:Error object:nil userInfo:userInfo];
                }
                else {
                    [self.remainingStoriesToDownload setArray:jsonResponse];
                    
                    for (int i=0; i< [jsonResponse count]; i++) {
                        RLMResults<Story *> *fetchedStories = [Story objectsWhere:[NSString stringWithFormat:@"identifier == %@",[jsonResponse objectAtIndex:i]]];
                        if ([fetchedStories count]>0)
                        {   //Already present
                            [self.remainingStoriesToDownload removeObject:[jsonResponse objectAtIndex:i]];
                      
                        }
                    }
                    
                    [self fetchNextStories];
                    
                }
            }
            else
            {
                NSLog(@"Response Error");
                userInfo = @{@"msg": @"Response Error"};
                [[NSNotificationCenter defaultCenter] postNotificationName:Error object:nil userInfo:userInfo];
            }
        }
        else
        {
            NSLog(@"error : %@",@[error.localizedDescription]);
            userInfo = @{@"msg":error.localizedDescription};
            [[NSNotificationCenter defaultCenter] postNotificationName:Error object:nil userInfo:userInfo];
        }
    }] ;
    
    [postDataTask resume];

}





- (void)getStoryDataForId:(NSNumber *) Id {
    
    
    NSURL *topStoriesUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@.json?print=pretty",Id]];
    
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
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];

                    NSLog(@"%@",jsonResponse);
                    
                    Story *story = [[Story alloc] init];
                    if ([[jsonResponse allKeys] containsObject:@"id"]) {
                        story.identifier=[jsonResponse objectForKey:@"id"];
                    }
                    
                    if ([[jsonResponse allKeys] containsObject:@"by"]) {
                        story.userName=[jsonResponse objectForKey:@"by"];
                    }
                    
                    if ([[jsonResponse allKeys] containsObject:@"kids"]) {
                        story.kids=[[jsonResponse objectForKey:@"kids"] componentsJoinedByString:@","];
                    }
                    if ([[jsonResponse allKeys] containsObject:@"descendants"]) {
                        story.commentsCount=[jsonResponse objectForKey:@"descendants"];
                    }
                    if ([[jsonResponse allKeys] containsObject:@"score"]) {
                        story.score=[jsonResponse objectForKey:@"score"];
                    }
                    if ([[jsonResponse allKeys] containsObject:@"time"]) {
                        story.time=[jsonResponse objectForKey:@"time"];
                    }
                    if ([[jsonResponse allKeys] containsObject:@"title"]) {
                        story.title=[jsonResponse objectForKey:@"title"];
                    }
                    if ([[jsonResponse allKeys] containsObject:@"url"]) {
                        story.url=[jsonResponse objectForKey:@"url"];
                    }
                   
                    /*
                    if ([[jsonResponse allKeys] containsObject:@"kids"]) {
                        NSArray *comments= [jsonResponse objectForKey:@"kids"];
                        for (NSNumber *com in comments) {
                            
                            Comment *comment=[[Comment alloc] init];
                            comment.identifier= com;
                            [story.comments addObject:comment];
                        }
                        
                    }
                    */
                    [realm addObject:story];
                    [realm commitWriteTransaction];
                    [self storyDownloadcompleteForIdendifier:[jsonResponse objectForKey:@"id"]];

                }
            }
            else
            {
                storiesDownloadedCheck ++;
                NSLog(@"Response Error");
                userInfo = @{@"msg": @"Response Error"};
                [[NSNotificationCenter defaultCenter] postNotificationName:Error object:nil userInfo:userInfo];
            }
        }
        else
        {
            storiesDownloadedCheck ++;
            NSLog(@"error : %@",@[error.localizedDescription]);
            userInfo = @{@"msg":error.localizedDescription};
            [[NSNotificationCenter defaultCenter] postNotificationName:Error object:nil userInfo:userInfo];
        }
    }] ;
    
    [postDataTask resume];

    
    
}


-(void)fetchNextStories{

    storiesFetchLimit= [self.remainingStoriesToDownload count]>20 ?20:[self.remainingStoriesToDownload count];
    if (storiesFetchLimit==0) {
        [self.delegate UpdateUI];
    }
    else
    {
        storiesDownloadedCheck=0;
        for (int i=0; i<storiesFetchLimit; i++) {
            [self getStoryDataForId:[self.remainingStoriesToDownload objectAtIndex:i]];
        }
    }
    

}


-(void)storyDownloadcompleteForIdendifier:(NSNumber *)idendifier {

    storiesDownloadedCheck++;
    [self.remainingStoriesToDownload removeObject:idendifier];
    [[NSUserDefaults standardUserDefaults] setObject:self.remainingStoriesToDownload forKey:@"RemainingStoriesToDownload"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(storiesDownloadedCheck==storiesFetchLimit)
    {
        [self.delegate UpdateUI];
    }

}

-(BOOL)numberOfRemainingStories{

    return [self.remainingStoriesToDownload count]>0?true:false;
}


@end
