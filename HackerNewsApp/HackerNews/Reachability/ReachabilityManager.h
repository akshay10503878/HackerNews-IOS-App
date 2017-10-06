//
//  ReachabilityManager.h
//  HackerNews
//
//  Created by akshay bansal on 9/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

+ (ReachabilityManager *)sharedManager;
+ (BOOL)isReachable;
@end
