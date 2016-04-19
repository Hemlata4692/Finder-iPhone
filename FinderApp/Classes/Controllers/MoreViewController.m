//
//  MoreViewController.m
//  Finder_iPhoneApp
//
//  Created by Monika on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "UserService.h"

@interface MoreViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSMutableArray *moreOptionsArray;
    NSArray *textFieldArray;
}
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;

//Change password view
@property (weak, nonatomic) IBOutlet UIView *changePwdContainerView;
@property (weak, nonatomic) IBOutlet UIView *changePwdView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation MoreViewController
@synthesize changePwdContainerView,changePwdView,oldPasswordTextField,confirmPasswordTextField,passwordTextField;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"MORE";
    // Do any additional setup after loading the view.
    
    changePwdContainerView.hidden = YES;
    textFieldArray = @[oldPasswordTextField,passwordTextField,confirmPasswordTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    
    [self addPadding];
    [self setCornerRadius];
    [self addborder];

    screenArray = [NSMutableArray arrayWithObjects:@"MY PROFILE",@"PENDING APPOINTMENTS",@"PROXIMITY ALERTS",@"SETTINGS",@"CHANGE PASSWORD",@"LOGOUT", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end
#pragma mark - Corner radius, border and textfield padding
-(void) setCornerRadius
{
    [oldPasswordTextField setCornerRadius:2.0f];
    [passwordTextField setCornerRadius:2.0f];
    [confirmPasswordTextField setCornerRadius:2.0f];
}

-(void)addborder
{
    [oldPasswordTextField addBorder:oldPasswordTextField];
    [passwordTextField addBorder:passwordTextField];
    [confirmPasswordTextField addBorder:confirmPasswordTextField];
}
-(void)addPadding
{
    [oldPasswordTextField addTextFieldPaddingWithoutImages:oldPasswordTextField];
    [passwordTextField addTextFieldPaddingWithoutImages:passwordTextField];
    [confirmPasswordTextField addTextFieldPaddingWithoutImages:confirmPasswordTextField];
}
#pragma mark - end

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"moreCell";
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.containerView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    cell.containerView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    cell.containerView.layer.shadowOpacity = 1.0f;
    cell.containerView.layer.shadowRadius = 1.0f;
    
    if(indexPath.row == 5)
    {
        cell.rightArrowIcon.hidden=YES;
    }
    
    cell.screenNameLabel.text = [moreOptionsArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3) {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SettingsViewController *settingsView =[storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [self.navigationController pushViewController:settingsView animated:YES];
    }
    else if (indexPath.row == 4)
    {
        changePwdContainerView.hidden = NO;
    }
    else if (indexPath.row == 5)
    {
        [UserDefaultManager removeValue:@"userId"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        myDelegate.window.rootViewController = myDelegate.navigationController;
    }
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
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];

    if([[UIScreen mainScreen] bounds].size.height<568)
    {
        if ((textField==passwordTextField) || (textField==confirmPasswordTextField))
        {
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64, self.view.frame.size.width, self.view.frame.size.height);
                }];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[UIScreen mainScreen] bounds].size.height<568)
    {
            if ((textField==passwordTextField) || (textField==confirmPasswordTextField))
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Email validation
- (BOOL)performValidationsForChangePassword
{
    if ([oldPasswordTextField isEmpty] || [passwordTextField isEmpty] || [confirmPasswordTextField isEmpty])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"All fields are required." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else
    {
        if ([oldPasswordTextField.text isEqualToString:passwordTextField.text])
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Old password and new password are same. Please try a different one" closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
        
        //Password confirmation for new password entered
        else if (![passwordTextField.text isEqualToString:confirmPasswordTextField.text])
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Passwords do not match" closeButtonTitle:@"Done" duration:0.0f];
            
            return NO;
        }

       else if ((oldPasswordTextField.text.length < 6) || (passwordTextField.text.length < 6) || (confirmPasswordTextField.text.length < 6))
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
}
#pragma mark - end
#pragma mark - IBActions

- (IBAction)saveButtonAction:(id)sender
{
    if([self performValidationsForChangePassword])
    {
        [myDelegate showIndicator];
        [self performSelector:@selector(changePassword) withObject:nil afterDelay:.1];
    }
}
- (IBAction)cancelButtonAction:(id)sender
{
    changePwdContainerView.hidden = YES;
}
#pragma mark - end
#pragma mark - Webservice
-(void)changePassword
{
    [[UserService sharedManager] changePassword:oldPasswordTextField.text newPassword:confirmPasswordTextField.text success:^(id responseObject)
     {
         [myDelegate stopIndicator];
         SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
         [alert addButton:@"Ok" actionBlock:^(void)
          {
             changePwdContainerView.hidden = YES;
         }];
         [alert showWarning:nil title:@"Alert" subTitle:@"Your password has been changed successfully." closeButtonTitle:nil duration:0.0f];

     } failure:^(NSError *error) {
         
     }] ;

}
#pragma mark - end

@end
