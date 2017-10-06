//
//  WebViewViewController.m
//  HackerNews
//
//  Created by akshay bansal on 9/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebViewWithURL:self.story.url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWebViewWithURL:(NSString*)url{

    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];

}




@end
