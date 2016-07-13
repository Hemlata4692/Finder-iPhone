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
    int totalRecords, firstTime;
    int btnTag;
    UIRefreshControl *refreshControl;
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
    firstTime=1;
    [self setTextView];
    // Pull To Refresh
    refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, 10, 10)];
    [personalMessageTableView addSubview:refreshControl];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@""];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHistory) name:@"GetMessageHistory" object:nil];
}
-(void)getHistory {
    
    [myDelegate showIndicator];
    [self performSelector:@selector(getMessageHistory) withObject:nil afterDelay:0.1];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    readStatus=@"True";
    offset=@"0";
    [myDelegate removeBadgeIconLastTab];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setTextView {
    myDelegate.myView=@"PersonalMessageView";
    sendMessageTextView.text = @"";
    [sendMessageTextView setPlaceholder:@"Type a message here..."];
    [sendMessageTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    sendMessageTextView.contentInset = UIEdgeInsetsMake(-5, 5, 0, 0);
    sendMessageTextView.alwaysBounceHorizontal = NO;
    sendMessageTextView.bounces = NO;
    [self registerForKeyboardNotifications];
    messageView.translatesAutoresizingMaskIntoConstraints = YES;
    sendMessageTextView.translatesAutoresizingMaskIntoConstraints = YES;
    messageView.backgroundColor = [UIColor whiteColor];
    sendMessageTextView.backgroundColor=[UIColor whiteColor];
    messageHeight = 40;
    messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 - 10, self.view.bounds.size.width, messageHeight + 10);
    sendMessageTextView.frame = CGRectMake(5, 2, messageView.frame.size.width - 55, messageHeight - 8);
    messageYValue = messageView.frame.origin.y;
    if ([sendMessageTextView.text isEqualToString:@""] || sendMessageTextView.text.length == 0) {
        sendMessageBtn.enabled = NO;
    }
    else{
        sendMessageBtn.enabled = YES;
    }
    personalMessageTableView.translatesAutoresizingMaskIntoConstraints = YES;
    personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (messageHeight +64 +49 + 14));
    readStatus=@"True";
    offset=@"0";
    [myDelegate showIndicator];
    [self performSelector:@selector(getMessageHistory) withObject:nil afterDelay:.1];
    messageDateArray=[[NSMutableArray alloc]init];
}
#pragma mark - end
#pragma mark - Refresh table
//Pull to refresh implementation on my submission data
- (void)refreshTable
{
    readStatus=@"True";
    firstTime=2;
    offset=[NSString stringWithFormat:@"%lu",(unsigned long)messageDateArray.count];
    if (messageDateArray.count<totalRecords) {
         [self getMessageHistory];
    }
    [refreshControl endRefreshing];
}
#pragma mark - end
#pragma mark - Webservice
-(void)getMessageHistory {
    [[MessageService sharedManager] getMessageHistory:otherUserId readStatus:readStatus pageOffSet:offset success:^(id dataArray) {
        [myDelegate stopIndicator];
      
        if (messageDateArray.count<1) {
            messageDateArray=[dataArray mutableCopy];
        }
        else
        {
            [messageDateArray addObjectsFromArray:dataArray];
        }
        if (messageDateArray!=nil) {
            totalRecords= [[messageDateArray objectAtIndex:messageDateArray.count-1]intValue];
            [messageDateArray removeLastObject];
            [personalMessageTableView reloadData];
            if (firstTime==1) {
                NSIndexPath* ip = [NSIndexPath indexPathForRow:[[[messageDateArray objectAtIndex:messageDateArray.count-1] messagesHistoryArray] count]-1 inSection:messageDateArray.count-1 ];
                [personalMessageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
        
    }
                                              failure:^(NSError *error)
     {
         
     }] ;
}

-(void)sendMessage {
    [[MessageService sharedManager] sendMessage:otherUserId message:sendMessageTextView.text success:^(id responseObject) {
        [myDelegate stopIndicator];
        sendMessageTextView.text=@"";
        NSInteger lastSectionIndex = [personalMessageTableView numberOfSections] - 1;
        NSInteger lastRowIndex = [personalMessageTableView numberOfRowsInSection:lastSectionIndex] - 1;
        MessageHistoryDataModel *tempModel = [[[messageDateArray objectAtIndex:lastSectionIndex]messagesHistoryArray ]objectAtIndex:lastRowIndex];
        tempModel.messageSendingFailed=@"No";
        [[[messageDateArray objectAtIndex:lastSectionIndex]messagesHistoryArray ] replaceObjectAtIndex:lastRowIndex withObject:tempModel];
        [personalMessageTableView reloadData];
        
    }
                                        failure:^(NSError *error)
     {
         NSInteger lastSectionIndex = [personalMessageTableView numberOfSections] - 1;
         NSInteger lastRowIndex = [personalMessageTableView numberOfRowsInSection:lastSectionIndex] - 1;
         MessageHistoryDataModel *tempModel = [[[messageDateArray objectAtIndex:lastSectionIndex]messagesHistoryArray ]objectAtIndex:lastRowIndex];
         tempModel.messageSendingFailed=@"Yes";
         [[[messageDateArray objectAtIndex:lastSectionIndex]messagesHistoryArray ] replaceObjectAtIndex:lastRowIndex withObject:tempModel];
         [personalMessageTableView reloadData];
         
     }] ;
    
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)sendMessageBtnAction:(id)sender {
    [sendMessageTextView resignFirstResponder];
    [self sendMessage];
    if (sendMessageTextView.text.length>=1) {
        sendMessageBtn.enabled=YES;
    }
    else if (sendMessageTextView.text.length==0) {
        sendMessageBtn.enabled=NO;
    }
    
    MessagesDataModel *messageDetails = [[MessagesDataModel alloc]init];
    messageDetails.messagesHistoryArray=[[NSMutableArray alloc]init];
    MessageHistoryDataModel *messageHistory = [[MessageHistoryDataModel alloc]init];
    NSMutableArray *localMessageArray = [NSMutableArray new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    if (messageDateArray==nil) {
        messageDateArray=[[NSMutableArray alloc]init];
        messageDetails.messageDate =dateString;
        
        messageHistory.dateTime =@"";
        messageHistory.userId =[UserDefaultManager getValue:@"userId"];
        messageHistory.userMessage =sendMessageTextView.text;
        messageHistory.messageSendingFailed=@"No";
        [messageDetails.messagesHistoryArray addObject:messageHistory];
        [messageDateArray addObject:messageDetails];
    }
    
   else if (![dateString isEqualToString:[[messageDateArray objectAtIndex:messageDateArray.count - 1]messageDate]]) {
        messageDetails.messageDate =dateString;
        messageHistory.dateTime =@"";
        messageHistory.userId =[UserDefaultManager getValue:@"userId"];
        messageHistory.userMessage =sendMessageTextView.text;
        messageHistory.messageSendingFailed=@"No";
        [messageDetails.messagesHistoryArray addObject:messageHistory];
        [messageDateArray addObject:messageDetails];
    }
    else
    {
        localMessageArray = [[[messageDateArray objectAtIndex:messageDateArray.count - 1]messagesHistoryArray] mutableCopy];
        messageDetails = [messageDateArray objectAtIndex:messageDateArray.count - 1];
        messageHistory.dateTime =@"";
        messageHistory.userId =[UserDefaultManager getValue:@"userId"];
        messageHistory.userMessage =sendMessageTextView.text;
        messageHistory.messageSendingFailed=@"No";
        [localMessageArray addObject:messageHistory];
        messageDetails.messagesHistoryArray = [localMessageArray mutableCopy];
        [messageDateArray replaceObjectAtIndex:messageDateArray.count - 1 withObject:messageDetails];
    }    
    [personalMessageTableView reloadData];
    sendMessageTextView.text=@"";
    NSIndexPath* ip = [NSIndexPath indexPathForRow:[[[messageDateArray objectAtIndex:messageDateArray.count-1] messagesHistoryArray] count]-1 inSection:messageDateArray.count-1 ];
    [personalMessageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
- (IBAction)retryButtonAction:(MyButton *)sender {
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:@"Yes" actionBlock:^(void) {
        [self sendMessage];
    }];
    [alert showWarning:nil title:@"Alert" subTitle:@"Do you want to resend message?" closeButtonTitle:@"No" duration:0.0f];
    
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
        return 0;
    }
    else {
        return 0;
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
        [meCell.retryButton addTarget:self action:@selector(retryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        meCell.retryButton.Tag=(int)indexPath.row;
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
}
- (void)keyboardWillHide:(NSNotification *)notification {
    messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 -10, self.view.bounds.size.width, messageHeight+ 10);
    messageYValue = [UIScreen mainScreen].bounds.size.height -64 -49 -10;
    
    personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height- messageHeight -64 -49 -14);
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
    }
        else if(textRect.size.height <= 50){
            messageHeight = 40;
            sendMessageTextView.frame = CGRectMake(sendMessageTextView.frame.origin.x, sendMessageTextView.frame.origin.y, sendMessageTextView.frame.size.width, messageHeight-8);
            messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14  , self.view.bounds.size.width, messageHeight + 10);
            personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18);
         
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
    }
    else if([sendMessageTextView sizeThatFits:sendMessageTextView.frame.size].height <= 50){
        messageHeight = 40;
        sendMessageTextView.frame = CGRectMake(sendMessageTextView.frame.origin.x, sendMessageTextView.frame.origin.y, sendMessageTextView.frame.size.width, messageHeight-8);
        messageView.frame = CGRectMake(0, messageYValue-messageHeight - 14  , self.view.bounds.size.width, messageHeight + 10);
        personalMessageTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  messageYValue-messageHeight - 18 );
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
