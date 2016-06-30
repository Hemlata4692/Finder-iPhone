//
//  MessagesViewController.m
//  Finder_iPhoneApp
//
//  Created by Monika on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MessagesViewController.h"
#import "PersonalMessageViewController.h"
#import "MessagesViewCell.h"

@interface MessagesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;

@end

@implementation MessagesViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Messages";
    myDelegate.currentNavigationController=self.navigationController;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end

#pragma mark - Table view delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *simpleTableIdentifier = @"messagesCell";
    MessagesViewCell *messagesCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (messagesCell == nil)  {
        messagesCell = [[MessagesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [messagesCell.messageViewContainer addShadow:messagesCell.messageViewContainer color:[UIColor lightGrayColor]];
    [messagesCell.userImage setCornerRadius:messagesCell.userImage.frame.size.width/2];
    [messagesCell.messageCountLabel setCornerRadius:messagesCell.messageCountLabel.frame.size.width/2];
    return messagesCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalMessageViewController *msgView =[storyboard instantiateViewControllerWithIdentifier:@"PersonalMessageViewController"];
    [self.navigationController pushViewController:msgView animated:YES];
}
#pragma mark - end

@end
