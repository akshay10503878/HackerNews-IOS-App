//
//  ViewController.m
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "MainViewController.h"
#import "MainNavigationController.h"
#import "LoginController.h"
#import "NewsDownloader.h"
#import "Reachability.h"
#import "Story.h"
#import "HackerNewsCell.h"
#import "IAUtils.h"
#import "Constants.h"
#import "DetailViewController.h"
@import Firebase;

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,NewsDownloaderDelegate>{

    NewsDownloader *newsDownloader;
    RLMResults *stories;

}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation MainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationItem.title=@"Top Stories";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LastDownloadedTime]) {
         self.navigationItem.prompt = [IAUtils timePassedFromTimestamp:[[NSUserDefaults standardUserDefaults] objectForKey:LastDownloadedTime]];
    }
   
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:LogoutIcon] style:UIBarButtonItemStylePlain target:self action:@selector(handleSignOut)];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    UIBarButtonItem *righttButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:RefreshIcon] style:UIBarButtonItemStylePlain target:self action:@selector(HandleRefresh)];
    self.navigationItem.rightBarButtonItem=righttButton;
    

    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:242.0/255.0 green:153.0/255.0 blue:74.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;

    
    
    
    stories = [Story allObjects];
    stories=[stories sortedResultsUsingKeyPath:@"time" ascending:false];
    newsDownloader=[NewsDownloader sharedInstance];
    newsDownloader.delegate=self;
    if ([stories count]==0) {
        
        [self startActivityIndicator];
        [newsDownloader loadTopStories];
       
        
    }
    else
    {
        //update tableview
        
        
    }
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleError:) name:Error object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Error object:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma SignOut
-(void)handleSignOut{
    
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    
    LoginController *loginController=[[LoginController alloc] init];
    [self presentViewController:loginController animated:YES completion:nil];
    
    
}




#pragma ActivityIndicator
-(void) startActivityIndicator{
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
}

-(void) stopActivityIndicator{
    
    [self.activityIndicator stopAnimating];
    [self.overlayView removeFromSuperview];
    
    
}



#pragma AlertController

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



#pragma Reachability Delegate
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {

        [self showErorrwithMsg:@"oops internet wet out!!" withexit:0];
        
    }
    else if (status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        NSLog(@"Reachable");
    }
}



#pragma TableViewDelegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [stories count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *MyIdentifier = @"HackerNewsCell";
    HackerNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[HackerNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    if ([tableView numberOfRowsInSection:0]-1==indexPath.row) {
        if ([newsDownloader numberOfRemainingStories]) {
            [self startActivityIndicator];
            [newsDownloader fetchNextStories];
        }
    }
    Story *story = [stories objectAtIndex:indexPath.row];
    cell.score.text=[NSString stringWithFormat:@"%@",story.score];
    cell.title.text=story.title;
    cell.timeAgo.text=[IAUtils timePassedFromTimestamp:story.time];
    cell.commentCount.text=[NSString stringWithFormat:@"%@",story.commentsCount];
    cell.userName.text=story.userName;
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma NewsDownloaderCompleteDelegate
-(void)UpdateUI
{
    @synchronized (self) {
    dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.prompt = [IAUtils timePassedFromTimestamp:[[NSUserDefaults standardUserDefaults] objectForKey:LastDownloadedTime]];

        NSMutableArray *updadtedIndexPaths=[[NSMutableArray alloc] init];
        NSInteger newStoriesCount=[[Story allObjects] count] - [self.tableView numberOfRowsInSection:0];
        for (int i=0; i < newStoriesCount; i++) {
            [updadtedIndexPaths addObject:[NSIndexPath indexPathForItem:[self.tableView numberOfRowsInSection:0]+i inSection:0]];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:updadtedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [self stopActivityIndicator];
    
    });

    }
}


-(void)HandleRefresh{

    [self startActivityIndicator];
    if (!newsDownloader) {
        newsDownloader=[NewsDownloader sharedInstance];
        newsDownloader.delegate=self;
    }
    [newsDownloader loadTopStories];
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailViewControllerSegue"]) {
    Story *story = [stories objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        DetailViewController *des=[segue destinationViewController];
        des.story=story;
    }
}


-(void)handleError:(NSNotification*)notification{
    
    if ([notification.name isEqualToString:@"Error"])
    {
        NSDictionary* userInfo = notification.userInfo;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopActivityIndicator];
            [self showErorrwithMsg:userInfo[@"msg"] withexit:NO];
        });
    }
}







@end
