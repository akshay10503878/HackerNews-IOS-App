//
//  LoginCell.h
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginCellDelegate

-(void)finishLoggingIn;

@end



@interface LoginCell : UICollectionViewCell

@property (nonatomic,weak)id<LoginCellDelegate> delegate;

@end
