//
//  Story.h
//  HackerNews
//
//  Created by akshay bansal on 9/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
@import Realm;




RLM_ARRAY_TYPE(Comment)



@interface Story : RLMObject

@property NSString *userName; //by
@property NSNumber<RLMInt> *commentsCount; //descendants
@property NSNumber<RLMInt> *identifier;
@property NSNumber<RLMInt> *score; //total polls
@property NSNumber<RLMDouble> *time;
@property NSString *kids;
@property NSString *title;  
@property NSString *url;

@property RLMArray<Comment *><Comment> *comments;

@end

