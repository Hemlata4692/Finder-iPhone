//
//  WebViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 21/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    NSURL *url;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation WebViewController
@synthesize webView;
@synthesize linkedInLink;
@synthesize navigationTitle;
@synthesize activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [activityIndicator startAnimating];
    self.navigationItem.title=navigationTitle;
    if ([linkedInLink isEqualToString:@""] || linkedInLink==nil)
    {
        [activityIndicator stopAnimating];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Invalid Url." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag=1;
            [alert show];
        });
    }

    else if ([navigationTitle isEqualToString:@"LinkedIn"]) {
        NSArray* words = [linkedInLink componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* linkedInString = [words componentsJoinedByString:@""];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.linkedin.com/in/%@",linkedInString]];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webView loadRequest:requestObj];
    }
}
//https://www.linkedin.com/in/hemlata-khajanchi-4617b99a
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==1 && buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
   // activityIndicator.hidden=YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSString *errorMsg;
    if (error==nil) {
        [activityIndicator stopAnimating];
        activityIndicator.hidden=YES;
        errorMsg=@"Request time out.";
    }
    else
    {
        [activityIndicator stopAnimating];
        activityIndicator.hidden=YES;
        errorMsg=error.localizedDescription;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:errorMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         alert.tag=1;
        [alert show];
    });
}
#pragma mark - end

@end
