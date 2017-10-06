//
//  IAUtils.h
//  HackerNews
//
//  Created by akshay bansal on 9/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAUtils: NSObject

+ (NSString *)timePassedFromTimestamp:(NSNumber *)timestamp;
+ (NSString *)replaceSpecialCharactersInString:(NSString *)string;

@end
