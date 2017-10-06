//
//  NSUserDefaults+Helper.h
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Helper)

-(void)setIsLoggedIn:(BOOL)value;
-(BOOL)isLoggedIn;

-(void)setUserEmail:(NSString*)value;
-(NSString*)getUserEmail;

-(void)setUserPassword:(NSString*)value;
-(NSString*)getUserPassword;



@end
