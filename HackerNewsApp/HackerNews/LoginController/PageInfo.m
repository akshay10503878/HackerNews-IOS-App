//
//  PageInfo.m
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "PageInfo.h"

@interface PageInfo()



@end

@implementation PageInfo

-(id)init
{
    return [self initWithTitle:@"default" imageName:@"default" message:@"default"];

}

-(id)initWithTitle:(NSString *)title imageName:(NSString *)imagename message:(NSString *)message{
    
    self = [super init];
    if (self) {
        self.title=title;
        self.message=message;
        self.imageName=imagename;
    }
    return self;
    

}
@end
