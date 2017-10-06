//
//  Comment.h
//  HackerNews
//
//  Created by akshay bansal on 9/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Realm;


@interface Comment : RLMObject

@property NSString *userName; 
@property NSNumber<RLMInt> *identifier;
@property NSNumber<RLMInt> *parent;
@property NSString *kids;
@property NSString *text;
@property NSNumber<RLMInt> *time;
@property NSString *type;

@end
