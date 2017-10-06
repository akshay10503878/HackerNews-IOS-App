//
//  PageCell.m
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "PageCell.h"


@interface PageCell()
{
    UIImageView *imageView;
    UITextView *textView;
    UIView *lineSeperator;
}
@end

@implementation PageCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupViews];
    }
    
    return self;

}

-(void)setupViews{

    self.backgroundColor=[UIColor whiteColor];
    
    imageView=[[UIImageView alloc] init];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds=YES;
    imageView.translatesAutoresizingMaskIntoConstraints=false;
    [self addSubview:imageView];
    
    textView=[[UITextView alloc] initWithFrame:CGRectZero];
    [textView setText:@"Sample Text"];
    [textView setEditable:false];
    textView.translatesAutoresizingMaskIntoConstraints=false;
    textView.clipsToBounds=YES;
    textView.contentInset=UIEdgeInsetsMake(24, 0, 0, 0);
    [self addSubview:textView];
    
    
    lineSeperator=[[UIView alloc]initWithFrame:CGRectZero];
    lineSeperator.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    lineSeperator.translatesAutoresizingMaskIntoConstraints=false;
    [self addSubview:lineSeperator];
    
    
    
    [imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0.0].active=YES;
    [imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0.0].active=YES;
    [imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:40.0].active=YES;
    [imageView.bottomAnchor constraintEqualToAnchor:lineSeperator.topAnchor constant:0.0].active=YES;
    
    
    [lineSeperator.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0.0].active=YES;
    [lineSeperator.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0.0];
    [lineSeperator.bottomAnchor constraintEqualToAnchor:textView.topAnchor constant:0].active=YES;
    [lineSeperator.heightAnchor constraintEqualToConstant:1.0].active=YES;
    

    [textView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-16].active=YES;
    [textView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16].active=YES;
    [textView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0].active=YES;
    [textView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.3].active=YES;
  
    
}

-(void)setPage:(PageInfo *)page
{
//    if ([[UIDevice currentDevice].orientation]) {
//        
//    }
    [imageView setImage:[UIImage imageNamed:page.imageName]];
    
    UIColor *color=[UIColor colorWithWhite:0.2 alpha:1];
    NSMutableAttributedString *attributedText=[[NSMutableAttributedString alloc] initWithString:page.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium],NSForegroundColorAttributeName:color}];
    
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@",page.message] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:color}]];
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment=NSTextAlignmentCenter;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedText.string.length)];
    
    textView.attributedText=attributedText;

    //[NSString stringWithFormat:@"%@\n\n%@", page.title, page.message];
}

@end
