//
//  MainNavigationController.m
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "MainNavigationController.h"
#import "LoginController.h"
#import "NSUserDefaults+Helper.h"
#import "MainViewController.h"
@import Firebase;

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];

    if([self isLoggedIn])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController *mainViewController = [sb instantiateViewControllerWithIdentifier:@"MainViewController"];
        mainViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        self.viewControllers=@[mainViewController];
    }
    else{
        [self performSelector:@selector(showLoginController) withObject:nil afterDelay:0.01];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isLoggedIn{

    FIRUser *prevUser = [FIRAuth auth].currentUser;
    
    if (prevUser != nil) {
        return YES;
    } else {
        //User Not logged in
        return NO;
    }
    
}

-(void)showLoginController{
    
    LoginController *loginCotroller=[[LoginController alloc] init];
    [self presentViewController:loginCotroller animated:YES completion:^{
    }];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
