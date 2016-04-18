//
//  ForgotPasswordViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@end

@implementation ForgotPasswordViewController
@synthesize emailField,textFieldContainerView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"FORGOT PASSWORD";
    [self addPadding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end
#pragma mark - Corner radius, border and textfield padding
-(void)addPadding
{
    [emailField addTextFieldPaddingWithoutImages:emailField];
    [textFieldContainerView setCornerRadius:2.0f];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Email validation
- (BOOL)performValidationsForForgotPassword
{
    if ([emailField isEmpty])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter your email address." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else
    {
    if (![emailField isValidEmail])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter a valid email address." closeButtonTitle:@"Done" duration:0.0f];
            return NO;
    }
    else
    {
        return YES;
    }
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)submitButtonAction:(id)sender
{
    [emailField resignFirstResponder];
    if([self performValidationsForForgotPassword])
    {
        [myDelegate showIndicator];
        [self performSelector:@selector(forgotPassword) withObject:nil afterDelay:.1];
    }

}
#pragma mark - end
#pragma mark - Webservice
-(void)forgotPassword
{
    [[Webservice sharedManager] forgotPassword:emailField.text success:^(id responseObject)
     {
         [myDelegate stopIndicator];
         SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
         [alert showSuccess:@"Success" subTitle:[responseObject objectForKey:@"message"] closeButtonTitle:@"OK" duration:0.0f];
        
     } failure:^(NSError *error) {
         
     }] ;
}

@end
