//
//  PageInfo.h
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageInfo : NSObject

@property (nonatomic,copy) NSString* title;
@property (nonatomic,copy) NSString* message;
@property (nonatomic,copy) NSString* imageName;


-(id)initWithTitle:(NSString *)title imageName:(NSString *)imagename message:(NSString *)message;

@end
