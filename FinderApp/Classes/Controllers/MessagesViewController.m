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
#import "MessageService.h"
#import "MessagesDataModel.h"

@interface MessagesViewController ()
{
    NSMutableArray *messagesDataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation MessagesViewController
@synthesize messagesTableView;
@synthesize noRecordLabel;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Messages";
    myDelegate.currentNavigationController=self.navigationController;
    messagesDataArray=[[NSMutableArray alloc]init];
    noRecordLabel.hidden=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
     [myDelegate removeBadgeIconLastTab];
    [myDelegate showIndicator];
    [self performSelector:@selector(getDifferentMessages) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
-(void)getDifferentMessages {
    [[MessageService sharedManager] getDifferentMessage:^(id dataArray) {
        [myDelegate stopIndicator];
        messagesDataArray=[dataArray mutableCopy];
        if (messagesDataArray==nil) {
            noRecordLabel.hidden=NO;
            noRecordLabel.text=@"No new message.";
            messagesTableView.hidden=YES;
        }
        else {
            messagesTableView.hidden=NO;
            noRecordLabel.hidden=YES;
            [messagesTableView reloadData];
        }
        [messagesTableView reloadData];
    }
                                        failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end

#pragma mark - Table view delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messagesDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *simpleTableIdentifier = @"messagesCell";
    MessagesViewCell *messagesCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (messagesCell == nil)  {
        messagesCell = [[MessagesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [messagesCell.messageViewContainer addShadow:messagesCell.messageViewContainer color:[UIColor lightGrayColor]];
    MessagesDataModel *data=[messagesDataArray objectAtIndex:indexPath.row];
    [messagesCell displayMessageData:data indexPath:(int)indexPath.row rectSize:messagesCell.frame.size];
    return messagesCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalMessageViewController *msgView =[storyboard instantiateViewControllerWithIdentifier:@"PersonalMessageViewController"];
    msgView.otherUserId=[[messagesDataArray objectAtIndex:indexPath.row] otherUserId];
    msgView.otherUserName=[[messagesDataArray objectAtIndex:indexPath.row] userName];
    [self.navigationController pushViewController:msgView animated:YES];
}
#pragma mark - end

@end
