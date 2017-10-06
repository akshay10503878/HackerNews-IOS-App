//
//  UITextField+CustomTextField.m
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//
#import "CustomTextField.h"

@implementation CustomTextField:UITextField 

-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    
    CGRect leftBounds = CGRectMake(bounds.origin.x+5, 10, 30, 30);
    return leftBounds;

}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{

    return CGRectInset(bounds, 40, 0);
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
  
    return CGRectInset(bounds, 45, 0);

}
@end
