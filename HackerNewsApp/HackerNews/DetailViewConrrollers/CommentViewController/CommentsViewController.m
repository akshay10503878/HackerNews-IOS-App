//
//  CommentsViewController.m
//  HackerNews
//
//  Created by akshay bansal on 9/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "CommentsViewController.h"
#import "Comment.h"
#import "CommentViewCell.h"
#import "IAUtils.h"
#import "Constants.h"



@interface CommentsViewController ()<UITableViewDelegate,UITableViewDataSource,CommentsDownloaderDelegate>
{
    
    RLMResults *comments;
    NSMutableArray *kidsLeft;
    NSInteger commentsRemaningtoDownload;
    
}

@property(nonatomic,strong)CommentsDownloader *commentsDownloader;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /*--Dynamic cell heights--*/
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=140;

    
    /*loading commentsDownloaderObject*/
    if (self.commentsDownloader==nil) {
        self.commentsDownloader=[CommentsDownloader sharedInstance]
        ;
    }
    self.commentsDownloader.delegate=self;
    
    
    
    /*--loading data from realm--*/
    comments=[Comment objectsWhere:@"parent == %@",self.story.identifier];//self.story.comments;
    kidsLeft=[[NSMutableArray alloc] init];
    [kidsLeft setArray:[self.story.kids componentsSeparatedByString:@","]];
    
    /*--check if data already have in database--*/
    if ([comments count]>0) {
        for (Comment *comment in comments) {
            [kidsLeft removeObject:[NSString stringWithFormat:@"%@",comment.identifier]];
        }
    }
    else
    {
        [self loadNextComments];
    }
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleError:) name:Error object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Error object:nil];


}


-(void)loadNextComments{
    
    commentsRemaningtoDownload=[kidsLeft count] > 10 ? 10:[kidsLeft count];
    [self startActivityIndicator];
    
    for (int i=0; i<10 && i < [kidsLeft count]; i++) {
           [self.commentsDownloader downloadCommentforID:[[kidsLeft objectAtIndex:i] integerValue]];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(NSString*)convertTimeStanmpintoDateTime:(NSNumber *)unixTimeStamp{
    NSTimeInterval _interval=[unixTimeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd MMM,yyyy - hh:mm"];
    return  [formatter stringFromDate:date];
}



#pragma TableViewDelegates


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comments count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"CommentViewCell";
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[CommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    if ([tableView numberOfRowsInSection:0]-1==indexPath.row) {
    
        if ([kidsLeft count]>0) {

            [self loadNextComments];
        }
        
        
    }
    
    Comment *comment = [comments objectAtIndex:indexPath.row];
    cell.dateTime.text=[self convertTimeStanmpintoDateTime:comment.time];
    cell.userName.text=[NSString stringWithFormat:@". %@",comment.userName];
    cell.comment.attributedText=[[NSAttributedString alloc] initWithData:[comment.text dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];

     return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma commentsDownloaderCompleteDelegate
-(void)UpdatecommentUIforID:(NSString *)identifier
{
    [kidsLeft removeObject:identifier];
    @synchronized (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            commentsRemaningtoDownload--;
            if (commentsRemaningtoDownload==0) {
                [self stopActivityIndicator];
                [self.tableView reloadData];
            }
            
        });
    }
}



-(void)handleError:(NSNotification*)notification{
    
    if ([notification.name isEqualToString:@"Error"])
    {
        NSDictionary* userInfo = notification.userInfo;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopActivityIndicator];
            [self showAlert:userInfo[@"msg"] title:@"Alert"];
        });
    }
}


-(void)showAlert:(NSString*)errorMsg title:(NSString*)title{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        if ([kidsLeft count]>0) {
            [self loadNextComments];
        }
        
        
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
