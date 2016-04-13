//
//  ViewController.m
//  FinderApp
//
//  Created by Hema on 01/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"
#import "UIImage+FontAwesome.h"

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
@synthesize logoImage,emailIcon,passwordIcon;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a ni
    emailIcon.image=[UIImage imageWithIcon:@"fa-envelope" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    passwordIcon.image=[UIImage imageWithIcon:@"fa-lock" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:12];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonclicked:(id)sender {
    [[Webservice sharedManager] userLogin:@"rohit.mittal@ranosys.com" password:@"c1h5yeZ9tx" conferenceId:@"1" success:^(id responseObject) {
      
    } failure:^(NSError *error) {
        
    }] ;

}
- (IBAction)forgotPasswordButtonClicked:(id)sender {
}
@end
