//
//  ReachabilityManager.m
//  HackerNews
//
//  Created by akshay bansal on 9/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "ReachabilityManager.h"

@interface ReachabilityManager ()

@property Reachability *reachability;

@end

@implementation ReachabilityManager

+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - Memory Management
- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark - Class Methods
+ (BOOL)isReachable {
    return [[[ReachabilityManager sharedManager] reachability] isReachable];
}

#pragma mark -  Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        _reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Start Monitoring
        [_reachability startNotifier];
    }
    
    return self;
}


@end
