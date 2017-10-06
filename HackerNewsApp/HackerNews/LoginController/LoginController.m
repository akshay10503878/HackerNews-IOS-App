//
//  ViewController.m
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "LoginController.h"
#import "PageCell.h"
#import "PageInfo.h"
#import "LoginCell.h"
#import "MainNavigationController.h"
#import "NSUserDefaults+Helper.h"
#import "MainViewController.h"
#import "Constants.h"
@import Firebase;
@import GoogleSignIn;





@interface LoginController ()<UICollectionViewDelegate,UICollectionViewDataSource,LoginCellDelegate,GIDSignInUIDelegate>
{
    UICollectionView *cv ;
    NSArray<PageInfo *> *pages;
    UIPageControl *pageControl;
    UIButton *skipButton;
    UIButton *nextButton;
    NSLayoutConstraint *pageControlBottomAnchor;
    NSLayoutConstraint *nextButtonTopAnchor;
    NSLayoutConstraint *skipButtonTopAnchor;
}

//@property(nonatomic,strong)UIButton *skipbutton;

#define cellID  @"cellid"
#define LoginCellID  @"loginCellid"
#define RegisterCellId @"registerCellId"

@end

@implementation LoginController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*--To show the google signin webpage--*/
    [GIDSignIn sharedInstance].uiDelegate = self;

    
    /*---Setup pages-*/
    
    PageInfo *firstPage=[[PageInfo alloc] initWithTitle:@"Hacker News " imageName:@"page1" message:@"It is one of the most renowned source for the latest that’s happening in the world of hi-tech"];
    PageInfo *secondPage=[[PageInfo alloc] initWithTitle:@"The Hacker News" imageName:@"page2.png" message:@"It is a leading source of Information Security, latest Hacking News, Cyber Security, Network Security with in-depth technical knowledge"];
    
    PageInfo *thirdPage=[[PageInfo alloc] initWithTitle:@"News World" imageName:@"page3" message:@"One step Solution to know whats going on in hacking world"];
    pages=[[NSArray alloc] initWithObjects:firstPage,secondPage,thirdPage, nil];
    
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing=0;
    cv =[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    cv.translatesAutoresizingMaskIntoConstraints=false;
    cv.backgroundColor=[UIColor whiteColor];
    cv.translatesAutoresizingMaskIntoConstraints=false;
    cv.pagingEnabled=TRUE;
    cv.delegate=self;
    cv.dataSource=self;
    [cv registerClass:[PageCell class] forCellWithReuseIdentifier:cellID];
    [cv registerClass:[LoginCell class] forCellWithReuseIdentifier:LoginCellID];
    cv.showsHorizontalScrollIndicator=false;
    
    [self.view addSubview:cv];
    
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.numberOfPages=pages.count+1;
    pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:247.0/255.0 green:154.0/255.0 blue:27.0/255.0   alpha:1];
    pageControl.translatesAutoresizingMaskIntoConstraints=false;
    [self.view addSubview:pageControl];
    
    
    
    skipButton =  [UIButton buttonWithType:UIButtonTypeSystem];
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:154.0/255.0 blue:27.0/255.0   alpha:1] forState:UIControlStateNormal];
    skipButton.translatesAutoresizingMaskIntoConstraints=false;
    [skipButton addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
    
    
    nextButton =  [UIButton buttonWithType:UIButtonTypeSystem];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:154.0/255.0 blue:27.0/255.0   alpha:1] forState:UIControlStateNormal];
    nextButton.translatesAutoresizingMaskIntoConstraints=false;
    [nextButton addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    
    
    
    // Creating the same constraints using Layout Anchors
    [cv.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0.0].active=YES;
    [cv.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [cv.topAnchor constraintEqualToAnchor:self.view.topAnchor].active=YES;
    [cv.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active=YES;
    
    
    
    [pageControl.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0].active=YES;
    [pageControl.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0].active=YES;
    pageControlBottomAnchor=[pageControl.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0];
    pageControlBottomAnchor.active=YES;
    [pageControl.heightAnchor constraintEqualToConstant:30].active=YES;

    
    
    
    [skipButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0].active=YES;
    skipButtonTopAnchor= [skipButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:16];
    skipButtonTopAnchor.active=YES;
    [skipButton.widthAnchor constraintEqualToConstant:80].active=YES;
    [skipButton.heightAnchor constraintEqualToConstant:50].active=YES;
    
    [nextButton.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0].active=YES;
    nextButtonTopAnchor=[nextButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:16];
    nextButtonTopAnchor.active=YES;
    [nextButton.widthAnchor constraintEqualToConstant:80].active=YES;
    [nextButton.heightAnchor constraintEqualToConstant:50].active=YES;
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    /*--Add observers dor keyboard-*/
    [self observeKeyboardNotification];

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}



-(void)observeKeyboardNotification{


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];

}

-(void)keyboardShow{

    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
    
        self.view.frame=CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height);
    
    } completion:nil];

}

-(void)keyboardHide{
    
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:nil];
    
}


-(void)moveControlConstraintsOffScreen{
    
    pageControlBottomAnchor.constant=40;
    nextButtonTopAnchor.constant=-40;
    skipButtonTopAnchor.constant=-40;
    
}




-(void)nextPage{
    
    if (pageControl.currentPage == pages.count) {
        return;
    }

    
    if (pageControl.currentPage==pages.count-1) {
        
        [self moveControlConstraintsOffScreen];
        
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:nil];

    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:pageControl.currentPage+1 inSection:0];

                            
    [cv scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    pageControl.currentPage+=1;
}


-(void)skip{
    
    pageControl.currentPage=pages.count-1;
    [self nextPage];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];

}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    pageControl.currentPage=targetContentOffset->x/self.view.frame.size.width;
    
    if (pageControl.currentPage==pages.count) {
        [self moveControlConstraintsOffScreen];
    }
    else
    {
        pageControlBottomAnchor.constant=0;
        nextButtonTopAnchor.constant=16;
        skipButtonTopAnchor.constant=16;
    
    }
    
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
    
        [self.view layoutIfNeeded];
        
    } completion:nil];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return pages.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == pages.count) {
        
        LoginCell *loginCell=(LoginCell *)[collectionView dequeueReusableCellWithReuseIdentifier:LoginCellID forIndexPath:indexPath];
        loginCell.delegate=self;
        return loginCell;
    }

    PageCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    ;
    
    
    PageInfo *page=[pages objectAtIndex:indexPath.row];
    cell.page=page;

    return cell;
}

-(void)finishLoggingIn{
    
    dispatch_async(dispatch_get_main_queue(),^{
        MainNavigationController *mainNavigationController=(MainNavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController *mainViewController = [sb instantiateViewControllerWithIdentifier:@"MainViewController"];
        mainViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        mainNavigationController.viewControllers=@[mainViewController];
        [[NSUserDefaults standardUserDefaults] setIsLoggedIn:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    
    });
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [cv.collectionViewLayout invalidateLayout];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:pageControl.currentPage inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [cv scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [cv reloadItemsAtIndexPaths:@[indexPath]];
        
    });
    

}




-(void)showErorrwithMsg:(NSString*)msg withexit:(BOOL)flag{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        // Ok action example
        if (flag) {
            exit(0);
        }
    }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



#pragma google_UI_Delegates
// If implemented, this method will be invoked when sign in needs to display a view controller.
// The view controller should be displayed modally (via UIViewController's |presentViewController|
// method, and not pushed unto a navigation controller's stack.
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    
    [self presentViewController:viewController animated:YES completion:nil];
    
    
}

// If implemented, this method will be invoked when sign in needs to dismiss a view controller.
// Typically, this should be implemented by calling |dismissViewController| on the passed
// view controller.
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





@end
