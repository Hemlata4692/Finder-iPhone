//
//  ViewController.m
//  FinderApp
//
//  Created by Hema on 01/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"


@interface LoginViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSArray *textFieldArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *emailIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation LoginViewController
@synthesize logoImage,emailIcon,emailField,passwordIcon,passwordField,mainContainerView,textFieldContainerView,loginScrollView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //Adding textfield to array
    textFieldArray = @[emailField,passwordField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    [self addPadding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
#pragma mark - end
#pragma mark - Corner radius, border and textfield padding
-(void)addPadding
{
    [emailField addTextFieldPaddingWithoutImages:emailField];
    [passwordField addTextFieldPaddingWithoutImages:passwordField];
    [textFieldContainerView setCornerRadius:2.0f];
}
#pragma mark - end
#pragma mark - Keyboard controls delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    if (textField==emailField) {
        [loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (textField==passwordField)
    {
        [loginScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-(textField.frame.size.height-50)) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Email validation
- (BOOL)performValidationsForLogin
{
    if ([emailField isEmpty] || [passwordField isEmpty])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"All fields are required." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else
    {
        if ([emailField isValidEmail])
        {
            if (passwordField.text.length < 6)
            {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showWarning:self title:@"Alert" subTitle:@"Your password must be atleast 6 characters long." closeButtonTitle:@"Done" duration:0.0f];
                return NO;
            }
            else
            {
                return YES;
            }
        }
        else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter a valid email address." closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)signInButtonclicked:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];
    [loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if([self performValidationsForLogin])
    {
        [myDelegate showIndicator];
        [self performSelector:@selector(loginUser) withObject:nil afterDelay:.1];
    }
}

- (IBAction)forgotPasswordButtonClicked:(id)sender
{
    [self.keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end
#pragma mark - Webservice
-(void)loginUser
{
    [[Webservice sharedManager] userLogin:emailField.text password:passwordField.text success:^(id responseObject)
     {
         [myDelegate stopIndicator];
         [UserDefaultManager setValue:[responseObject objectForKey:@"userId"] key:@"userId"];
         [UserDefaultManager setValue:[responseObject objectForKey:@"userEmail"] key:@"userEmail"];
         [UserDefaultManager setValue:[responseObject objectForKey:@"userImage"] key:@"userImage"];
         [UserDefaultManager setValue:[responseObject objectForKey:@"userName"] key:@"userName"];
         [UserDefaultManager setValue:[responseObject objectForKey:@"unReadMessegaes"] key:@"unReadMessegaes"];
         
         
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         HomeViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
         [myDelegate.window setRootViewController:homeView];
         [myDelegate.window makeKeyAndVisible];

     } failure:^(NSError *error) {
         
     }] ;
}
@end
