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
#import "SettingsViewController.h"
#import "PendingAppointmentViewController.h"
#import "ProximityAlertsViewController.h"
#import "ConferenceListViewController.h"
#import "HomeViewController.h"

@interface MoreViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSMutableArray *moreOptionsArray, *moreImagesArray;
    NSArray *textFieldArray;
}

@property (weak, nonatomic) IBOutlet UITableView *moreTableView;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

//Change password view
@property (weak, nonatomic) IBOutlet UIView *changePwdContainerView;
@property (weak, nonatomic) IBOutlet UIView *changePasswordView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation MoreViewController
@synthesize changePwdContainerView,changePasswordView,oldPasswordTextField,confirmPasswordTextField,passwordTextField,keyboardControls;

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"More";
    changePwdContainerView.hidden = YES;
    textFieldArray = @[oldPasswordTextField,passwordTextField,confirmPasswordTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldArray]];
    [self.keyboardControls setDelegate:self];
    moreOptionsArray = [NSMutableArray arrayWithObjects:@"My Profile",@"Pending Appointments",@"Requested Appointments",@"Conference",@"Settings",@"Change Password",@"Switch Conference",@"Logout", nil];
    moreImagesArray= [NSMutableArray arrayWithObjects:@"my_profile.png",@"pending_appointment.png",@"requested_appointment.png",@"conference_icon.png",@"setting.png",@"change_password.png",@"switch_conference.png",@"logout.png", nil];
}

- (void)didReceiveMemoryWarningn {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end

#pragma mark - Table view delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return moreOptionsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"moreCell";
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell.containerView addShadow:cell.containerView color:[UIColor lightGrayColor]];
    cell.screenNameLabel.text = [moreOptionsArray objectAtIndex:indexPath.row];
    cell.iconImageView.image=[UIImage imageNamed:[moreImagesArray objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        //        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        PendingAppointmentViewController *settingsView =[storyboard instantiateViewControllerWithIdentifier:@"PendingAppointmentViewController"];
        //         settingsView.screenName=@"Pending Appointments";
        //        [self.navigationController pushViewController:settingsView animated:YES];
    }
    else if (indexPath.row==2) {
        //        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        PendingAppointmentViewController *settingsView =[storyboard instantiateViewControllerWithIdentifier:@"PendingAppointmentViewController"];
        //        settingsView.screenName=@"Requested Appointments";
        //        [self.navigationController pushViewController:settingsView animated:YES];
    }
    else if (indexPath.row==3) {
                UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HomeViewController *settingsView =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                [self.navigationController pushViewController:settingsView animated:YES];
    }
    else if (indexPath.row==4) {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SettingsViewController *settingsView =[storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [self.navigationController pushViewController:settingsView animated:YES];
    }
    else if (indexPath.row == 5) {
        changePwdContainerView.hidden = NO;
        oldPasswordTextField.text=@"";
        passwordTextField.text=@"";
        confirmPasswordTextField.text=@"";
    }
    else if (indexPath.row == 6) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ConferenceListViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"ConferenceListViewController"];
        [myDelegate.window setRootViewController:homeView];
        [myDelegate.window makeKeyAndVisible];
    }
    else if (indexPath.row == 7) {
        [myDelegate showIndicator];
        [self performSelector:@selector(logout) withObject:nil afterDelay:.1];
        //  [UserDefaultManager removeValue:@"switchStatusDict"];
    }
}

#pragma mark - end
#pragma mark - Keyboard controls delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    UIView *view;
    view = field.superview.superview.superview;
}
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboard {
    [keyboard.activeField resignFirstResponder];
}

#pragma mark - end
#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    
    if([[UIScreen mainScreen] bounds].size.height<568) {
        if (textField==oldPasswordTextField) {
            [UIView animateWithDuration:0.3 animations:^{
                changePasswordView.frame=CGRectMake(changePasswordView.frame.origin.x, changePasswordView.frame.origin.y-10, changePasswordView.frame.size.width, changePasswordView.frame.size.height);
            }];
            
        }
        if (textField==passwordTextField) {
            [UIView animateWithDuration:0.3 animations:^{
                changePasswordView.frame=CGRectMake(changePasswordView.frame.origin.x, changePasswordView.frame.origin.y-64, changePasswordView.frame.size.width, changePasswordView.frame.size.height);
            }];
        }
        else if (textField==confirmPasswordTextField) {
            [UIView animateWithDuration:0.3 animations:^{
                changePasswordView.frame=CGRectMake(changePasswordView.frame.origin.x, changePasswordView.frame.origin.y-130, changePasswordView.frame.size.width, changePasswordView.frame.size.height);
            }];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        changePasswordView.frame=CGRectMake(changePasswordView.frame.origin.x, 64, changePasswordView.frame.size.width, changePasswordView.frame.size.height);
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Email validation
- (BOOL)performValidationsForChangePassword {
    if ([oldPasswordTextField isEmpty] || [passwordTextField isEmpty] || [confirmPasswordTextField isEmpty]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:self title:@"Alert" subTitle:@"All fields are required." closeButtonTitle:@"Done" duration:0.0f];
        return NO;
    }
    else {
        if (![passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"Passwords do not match." closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
        else if ([oldPasswordTextField.text isEqualToString:passwordTextField.text]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"Your current and new passwords cannot be same." closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
        else if ((oldPasswordTextField.text.length < 6) || (passwordTextField.text.length < 6) || (confirmPasswordTextField.text.length < 6)) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:self title:@"Alert" subTitle:@"Your password must be atleast 6 characters long." closeButtonTitle:@"Done" duration:0.0f];
            return NO;
        }
        else {
            return YES;
        }
    }
}
#pragma mark - end
#pragma mark - IBActions

- (IBAction)saveButtonAction:(id)sender {
    [keyboardControls.activeField resignFirstResponder];
    if([self performValidationsForChangePassword]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(changePassword) withObject:nil afterDelay:.1];
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    [keyboardControls.activeField resignFirstResponder];
    changePwdContainerView.hidden = YES;
}
#pragma mark - end

#pragma mark - Webservice
-(void)changePassword {
    [[UserService sharedManager] changePassword:oldPasswordTextField.text newPassword:confirmPasswordTextField.text success:^(id responseObject) {
        [myDelegate stopIndicator];
        changePwdContainerView.hidden=YES;
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"Ok" actionBlock:^(void)
         {
             changePwdContainerView.hidden = YES;
         }];
        [alert showSuccess:nil title:@"Success" subTitle:@"Your password has been changed successfully." closeButtonTitle:nil duration:0.0f];
        
    } failure:^(NSError *error)
     {
         
     }] ;
    
}

-(void)logout {
    [[UserService sharedManager] logoutUser:^(id responseObject)
     {
         [myDelegate unregisterDeviceForNotification];
         [myDelegate stopIndicator];
         [myDelegate.locationManager stopUpdatingLocation];
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
         myDelegate.window.rootViewController = myDelegate.navigationController;
         [UserDefaultManager removeValue:@"userId"];
         [UserDefaultManager removeValue:@"accessToken"];
         [UserDefaultManager removeValue:@"userEmail"];
         [UserDefaultManager removeValue:@"userName"];
         [UserDefaultManager removeValue:@"userImage"];
         [UserDefaultManager removeValue:@"conferenceId"];
     } failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end

@end
