//
//  DetailViewController.m
//  HackerNews
//
//  Created by akshay bansal on 9/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    UIViewController *currentViewController;
    UIViewController *firstViewController;
    UIViewController *secondViewController;


}
@property (strong, nonatomic) IBOutlet UILabel *storytile;
@property (strong, nonatomic) IBOutlet UILabel *url;
@property (strong, nonatomic) IBOutlet UILabel *timeAgo;

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIView *containerView;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*--Setup Details--*/
    self.storytile.text=self.story.title?self.story.title:@"Title";
    self.url.text=self.story.url?self.story.url:@"URL";
    self.timeAgo.text=[self convertTimeStanmpintoDateTime:self.story.time];
    self.userName.text=self.story.userName?[NSString stringWithFormat:@". %@",self.story.userName]:@"User Name";
    
    
    /*--HIDE THE NAVIGATION CONTROLLER--*/
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    
    UIViewController *vc = [self viewControllerForSegmentIndex:self.segmentControl.selectedSegmentIndex];
    [vc setValue:self.story forKey:@"story"];
    [self addChildViewController:vc];
    vc.view.frame = self.containerView.bounds;
    [self.containerView addSubview:vc.view];
    currentViewController = vc;
    
    [self.segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];

    
    
}


- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    UIViewController *vc = [self viewControllerForSegmentIndex:sender.selectedSegmentIndex];
    [self addChildViewController:vc];
    [self transitionFromViewController:currentViewController toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [currentViewController.view removeFromSuperview];
        vc.view.frame = self.containerView.bounds;
        [self.containerView addSubview:vc.view];
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
        [currentViewController removeFromParentViewController];
        currentViewController = vc;
    }];
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 0:
            if (firstViewController==nil) {
                firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsViewController"];
                [firstViewController setValue:self.story forKey:@"story"];
            }
            
            vc=firstViewController;
            break;
        case 1:
            if (secondViewController==nil) {
                secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
                [secondViewController setValue:self.story forKey:@"story"];

                
            }
            vc=secondViewController;
            break;
    }
    return vc;
}


-(NSString*)convertTimeStanmpintoDateTime:(NSNumber *)unixTimeStamp{
    NSTimeInterval _interval=[unixTimeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd MMM,yyyy"];
    return  [formatter stringFromDate:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButton:(id)sender {
    /*--UNHIDE THE NAVIGATION CONTROLLER--*/
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
