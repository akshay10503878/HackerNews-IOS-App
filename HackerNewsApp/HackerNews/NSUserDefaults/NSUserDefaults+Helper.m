//
//  NSUserDefaults+Helper.m
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "NSUserDefaults+Helper.h"


#define isLoggedInKey  @"isLoggedIn"
#define userEmail      @"userEmail"
#define userPassword   @"userPassword"



@implementation NSUserDefaults (Helper)


-(void)setUserEmail:(NSString*)value{

    [self setObject:value forKey:userEmail];
    [self synchronize];
}

-(NSString*)getUserEmail{
    
    return [self stringForKey:userEmail];
    
}

-(void)setUserPassword:(NSString*)value{
    
    [self setObject:value forKey:userPassword];
    [self synchronize];
}

-(NSString*)getUserPassword{
    
    return [self stringForKey:userPassword];
    
}



-(void)setIsLoggedIn:(BOOL)value{
    
    [self setBool:value forKey:isLoggedInKey];
    [self synchronize];
}

-(BOOL)isLoggedIn{

    return [self boolForKey:isLoggedInKey];
}
@end
