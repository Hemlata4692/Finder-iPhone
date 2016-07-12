//
//  PersonalMessageViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PersonalMessageViewController.h"
#import "PersonalMessageViewCell.h"
#import "MessageService.h"
#import "MessagesDataModel.h"
#import "MessageHistoryDataModel.h"
#import "UIPlaceHolderTextView.h"

@interface PersonalMessageViewController ()
{
    NSString *offset;
    NSMutableArray *messageDateArray;
    CGFloat messageHeight, messageYValue;
}

@property (weak, nonatomic) IBOutlet UITableView *personalMessageTableView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *sendMessageTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;
@property (weak, nonatomic)  NSString *readStatus;
@end

@implementation PersonalMessageViewController
@synthesize personalMessageTableView,messageView,sendMessageTextView,sendMessageBtn;
@synthesize otherUserId;
@synthesize otherUserName;
@synthesize readStatus;

#pragma mark- View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=otherUserName;
    sendMessageTextView.text = @"";
    [sendMessageTextView setPlaceholder:@"Type a message here..."];
    [sendMessageTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    sendMessageTextView.contentInset = UIEdgeInsetsMake(-5, 5, 0, 0);
    sendMessageTextView.alwaysBounceHorizontal = NO;
    sendMessageTextView.bounces = NO;
   // userData = [NSMutableArray new];
    [self registerForKeyboardNotifications];
    messageView.translatesAutoresizingMaskIntoConstraints = YES;
    sendMessageTextView.translatesAutoresizingMaskIntoConstraints = YES;
    messageView.backgroundColor = [UIColor whiteColor];
    messageHeight = 40;
    messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 - 10, self.view.bounds.size.width, messageHeight + 10);
    sendMessageTextView.frame = CGRectMake(5, 2, messageView.frame.size.width - 26, messageHeight - 8);
    messageYValue = messageView.frame.origin.y;
    if ([sendMessageTextView.text isEqualToString:@""] || sendMessageTextView.text.length == 0) {
        sendMessageBtn.enabled = NO;
    }
    else{
        sendMessageBtn.enabled = YES;
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historUpdated:) name:@"UserHistory" object:nil];
    personalMessageTableView.translatesAutoresizingMaskIntoConstraints = YES;
    personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (messageHeight +64 +49 + 14));
    
    readStatus=@"True";
    offset=@"0";
    // Do any additional setup after loading the view.
    [myDelegate showIndicator];
    [self performSelector:@selector(getMessageHistory) withObject:nil afterDelay:.1];
    messageDateArray=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Webservice
-(void)getMessageHistory {
    [[MessageService sharedManager] getMessageHistory:otherUserId readStatus:readStatus pageOffSet:offset success:^(id dataArray) {
        [myDelegate stopIndicator];
        messageDateArray=[dataArray mutableCopy];
        [personalMessageTableView reloadData];
        
    }
                                        failure:^(NSError *error)
     {
         
     }] ;
}
-(void)sendMessage {
    [[MessageService sharedManager] sendMessage:otherUserId message:sendMessageTextView.text success:^(id responseObject) {
        [myDelegate stopIndicator];
        
    }
                                        failure:^(NSError *error)
     {
         
     }] ;

}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)sendMessageBtnAction:(id)sender {
    [self sendMessage];
   // sendMessageTextView.text=@"";
//    if (messageDateArray.count > 0) {
//        NSIndexPath* ip = [NSIndexPath indexPathForRow:messageDateArray.count-1 inSection:0];
//        [personalMessageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }
    if (sendMessageTextView.text.length>=1) {
        sendMessageBtn.enabled=YES;
    }
    else if (sendMessageTextView.text.length==0) {
        sendMessageBtn.enabled=NO;
    }
    [personalMessageTableView reloadData];
    
}

- (IBAction)tapGestureOnView:(UITapGestureRecognizer *)sender {
    [sendMessageTextView resignFirstResponder];
}

#pragma mark - end

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return messageDateArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }
    else {
        return 5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    dateLabel.text=[[messageDateArray objectAtIndex:section]messageDate];
    float width =  [dateLabel.text boundingRectWithSize:dateLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:dateLabel.font } context:nil]
    .size.width;
    dateLabel.frame = CGRectMake((tableView.frame.size.width/2-width/2), 10, width+10,30.0);
    dateLabel.textAlignment=NSTextAlignmentCenter;
    [dateLabel setCornerRadius:5];
    dateLabel.backgroundColor=[UIColor colorWithRed:253.0/255.0 green:160.0/255.0 blue:82.0/255.0 alpha:1.0];
    dateLabel.textColor=[UIColor colorWithRed:(50.0/255.0) green:(50.0/255.0) blue:(50.0/255.0) alpha:1];
    [headerView addSubview:dateLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageHistoryDataModel *data=[[[messageDateArray objectAtIndex:indexPath.section]messagesHistoryArray] objectAtIndex:indexPath.row];
        CGSize size = CGSizeMake(personalMessageTableView.frame.size.width-50,999);
        CGRect textRect = [data.userMessage
                           boundingRectWithSize:size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13.0]}
                           context:nil];
        
        return 80+textRect.size.height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[messageDateArray objectAtIndex:section]messagesHistoryArray].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     MessageHistoryDataModel *data=[[[messageDateArray objectAtIndex:indexPath.section]messagesHistoryArray] objectAtIndex:indexPath.row];
    if ([data.userId isEqualToString:[UserDefaultManager getValue:@"userId"]]) {
        NSString *simpleTableIdentifier = @"meCell";
        PersonalMessageViewCell *meCell=[personalMessageTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (meCell == nil)
        {
            meCell=[[PersonalMessageViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        [meCell displayUserMessage:data indexPath:(int)indexPath.row rectSize:meCell.frame.size];
        
        return meCell;
    }
    else {
            NSString *simpleTableIdentifier = @"otherUserCell";
        PersonalMessageViewCell *otherCell=[personalMessageTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (otherCell == nil)
        {
            otherCell=[[PersonalMessageViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        [otherCell displayOtherUserMessage:data indexPath:(int)indexPath.row rectSize:otherCell.frame.size];
        return otherCell;
    }
    
}
#pragma mark - end

#pragma mark - Keyboard delegates
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- [aValue CGRectValue].size.height -messageHeight -64 -10 , [aValue CGRectValue].size.width, messageHeight+ 10);
    messageYValue = [UIScreen mainScreen].bounds.size.height- [aValue CGRectValue].size.height  -50 -10;
    personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height- [aValue CGRectValue].size.height -messageHeight -64 -14);
    
    if (messageDateArray.count > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:messageDateArray.count-1 inSection:0];
        [personalMessageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification {
    messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 -10, self.view.bounds.size.width, messageHeight+ 10);
    messageYValue = [UIScreen mainScreen].bounds.size.height -64 -49 -10;
    
    personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 -14);
    if (messageDateArray.count > 0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:messageDateArray.count-1 inSection:0];
        [personalMessageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
#pragma mark - end

#pragma mark - Textfield delegates
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:[UIPasteboard generalPasteboard].string]) {
        
        CGSize size = CGSizeMake(sendMessageTextView.frame.size.height,126);
        NSString *string = textView.text;
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        text = [NSString stringWithFormat:@"%@%@",sendMessageTextView.text,text];
        CGRect textRect=[text
                         boundingRectWithSize:size
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15]}
                         context:nil];
        
        if ((textRect.size.height < 126) && (textRect.size.height > 50)) {
            
            sendMessageTextView.frame = CGRectMake(sendMessageTextView.frame.origin.x, sendMessageTextView.frame.origin.y, sendMessageTextView.frame.size.width, textRect.size.height);
            
            messageHeight = textRect.size.height + 8;
            messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14 , self.view.bounds.size.width, messageHeight +10 );
            personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18);
            if (messageDateArray.count > 0) {
                NSIndexPath* ip = [NSIndexPath indexPathForRow:messageDateArray.count-1 inSection:0];
                [personalMessageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
        else if(textRect.size.height <= 50){
            messageHeight = 40;
            sendMessageTextView.frame = CGRectMake(sendMessageTextView.frame.origin.x, sendMessageTextView.frame.origin.y, sendMessageTextView.frame.size.width, messageHeight-8);
            messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14  , self.view.bounds.size.width, messageHeight + 10);
            personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18);
            if (messageDateArray.count > 0) {
                NSIndexPath* ip = [NSIndexPath indexPathForRow:messageDateArray.count-1 inSection:0];
                [personalMessageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
        if (textView.text.length>=1) {
            
            if (trimmedString.length>=1) {
                sendMessageBtn.enabled=YES;
            }
            else{
                sendMessageBtn.enabled=NO;
            }
        }
        else if (textView.text.length==0) {
            sendMessageBtn.enabled=NO;
        }
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (([sendMessageTextView sizeThatFits:sendMessageTextView.frame.size].height < 126) && ([sendMessageTextView sizeThatFits:sendMessageTextView.frame.size].height > 50)) {
        
        sendMessageTextView.frame = CGRectMake(sendMessageTextView.frame.origin.x, sendMessageTextView.frame.origin.y, sendMessageTextView.frame.size.width, [sendMessageTextView sizeThatFits:sendMessageTextView.frame.size].height);
        messageHeight = [sendMessageTextView sizeThatFits:sendMessageTextView.frame.size].height + 8;
        messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14 , self.view.bounds.size.width, messageHeight +10 );
        personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18);
        if (messageDateArray.count > 0) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:messageDateArray.count-1 inSection:0];
            [personalMessageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    else if([sendMessageTextView sizeThatFits:sendMessageTextView.frame.size].height <= 50){
        messageHeight = 40;
        sendMessageTextView.frame = CGRectMake(sendMessageTextView.frame.origin.x, sendMessageTextView.frame.origin.y, sendMessageTextView.frame.size.width, messageHeight-8);
        messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14  , self.view.bounds.size.width, messageHeight + 10);
        personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18 );
        if (messageDateArray.count > 0) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:messageDateArray.count-1 inSection:0];
            [personalMessageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    NSString *string = textView.text;
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textView.text.length>=1) {
        if (trimmedString.length>=1) {
            sendMessageBtn.enabled=YES;
        }
        else if (trimmedString.length==0) {
            sendMessageBtn.enabled=NO;
        }
    }
    else if (textView.text.length==0) {
        sendMessageBtn.enabled=NO;
    }
}

#pragma mark - end

@end
