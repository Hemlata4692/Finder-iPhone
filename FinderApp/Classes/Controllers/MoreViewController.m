//
//  MoreViewController.m
//  Finder_iPhoneApp
//
//  Created by Monika on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
@interface MoreViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>
{
    NSMutableArray *screenArray;
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

- (IBAction)saveButtonAction:(id)sender;

- (IBAction)cancelButtonAction:(id)sender;

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
    //  cell.containerView.layer.masksToBounds = NO;
    //    cell.containerView.layer.masksToBounds = NO;
    //    cell.containerView.layer.shadowOffset = CGSizeMake(0, 3.0);
    //    cell.containerView.layer.shadowRadius = 1.0;
    //    cell.containerView.layer.shadowOpacity = 0.5;
    
    if(indexPath.row == 5)
    {
        cell.rightArrowIcon.hidden=YES;
    }
    
    cell.screenNameLabel.text = [screenArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4)
    {
        changePwdContainerView.hidden = NO;
    }
}
#pragma mark - end

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
//    }];

}
#pragma mark - end

#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];

    if([[UIScreen mainScreen] bounds].size.height<=568)
    {
        if ((textField==passwordTextField) || (textField==confirmPasswordTextField))
        {
            self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[UIScreen mainScreen] bounds].size.height<=568)
    {
            if ((textField==passwordTextField) || (textField==confirmPasswordTextField))
        {
            self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height);
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
        if ((oldPasswordTextField.text.length < 6) || (passwordTextField.text.length < 6) || (confirmPasswordTextField.text.length < 6))
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
}

- (IBAction)cancelButtonAction:(id)sender
{
    changePwdContainerView.hidden = YES;
}
#pragma mark - end

@end
