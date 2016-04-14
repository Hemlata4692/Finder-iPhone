//
//  ViewController.m
//  FinderApp
//
//  Created by Hema on 01/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *emailIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@end

@implementation LoginViewController
@synthesize logoImage,emailIcon,emailField,passwordIcon,passwordField,mainContainerView,textFieldContainerView,loginScrollView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   emailField.text=@"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)signInButtonclicked:(id)sender
{
    [[Webservice sharedManager] userLogin:@"rohit.mittal@ranosys.com" password:@"c1h5yeZ9tx" conferenceId:@"1" success:^(id responseObject) {
      
    } failure:^(NSError *error) {
        
    }] ;

}

- (IBAction)forgotPasswordButtonClicked:(id)sender
{
}
#pragma mark - end
@end
