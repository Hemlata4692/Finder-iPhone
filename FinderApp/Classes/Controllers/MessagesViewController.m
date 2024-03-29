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


@interface MessagesViewController () {
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

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if ([myDelegate.alertType isEqualToString:@"9"]) {
        myDelegate.alertType=@"";
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PersonalMessageViewController *msgView =[storyboard instantiateViewControllerWithIdentifier:@"PersonalMessageViewController"];
        msgView.otherUserId=myDelegate.otherUserID;
        msgView.otherUserName=myDelegate.otherUserName;
        [self.navigationController pushViewController:msgView animated:YES];
        return;
    }

    [UserDefaultManager setValue:nil key:@"unReadMessegaes"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDifferentMessages) name:@"GetMessageDetails" object:nil];
    [myDelegate showIndicator];
    [self performSelector:@selector(getDifferentMessages) withObject:nil afterDelay:.1];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    myDelegate.myView=@"MessagesViewController";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    myDelegate.myView=@"other";
}
#pragma mark - end

#pragma mark - Webservice
- (void)getDifferentMessages {
    [[MessageService sharedManager] getDifferentMessage:^(id dataArray) {
        [myDelegate stopIndicator];
        messagesDataArray=[dataArray mutableCopy];
        if (messagesDataArray==nil) {
            [myDelegate removeBadgeIconLastTab];
            noRecordLabel.hidden=NO;
            noRecordLabel.text=@"No new message.";
            messagesTableView.hidden=YES;
        }
        else {
            messagesTableView.hidden=NO;
            noRecordLabel.hidden=YES;
        }
        [messagesTableView reloadData];
    }
                                                failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end

#pragma mark - Table view delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messagesDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL flag=false;
    for (int i=0; i<messagesDataArray.count; i++) {
        if (i!=indexPath.row && [[[messagesDataArray objectAtIndex:i] messageCount] intValue]!=0) {
            flag=true;
            break;
        }
    }
    if (!flag) {
        [myDelegate removeBadgeIconLastTab];
    }
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalMessageViewController *msgView =[storyboard instantiateViewControllerWithIdentifier:@"PersonalMessageViewController"];
    msgView.otherUserId=[[messagesDataArray objectAtIndex:indexPath.row] otherUserId];
    msgView.otherUserName=[[messagesDataArray objectAtIndex:indexPath.row] userName];
    [self.navigationController pushViewController:msgView animated:YES];
}
#pragma mark - end

@end
