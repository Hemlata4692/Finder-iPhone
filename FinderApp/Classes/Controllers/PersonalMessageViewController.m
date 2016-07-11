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

@interface PersonalMessageViewController ()
{
    NSString *offset;
    NSMutableArray *messageDateArray;
}

@property (weak, nonatomic) IBOutlet UITableView *personalMessageTableView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITextView *sendMessageTextView;
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

#pragma mark - IBActions
- (IBAction)sendMessageBtnAction:(id)sender {
    [[MessageService sharedManager] sendMessage:otherUserId message:sendMessageTextView.text success:^(id responseObject) {
        [myDelegate stopIndicator];
    
    }
                                                 failure:^(NSError *error)
     {
         
     }] ;
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
//    NSArray *dateStrings = [[[messageDateArray objectAtIndex:section]messageDate] componentsSeparatedByString:@" "];
//    NSMutableString *string = [[NSMutableString alloc]init];
//    NSString *result;
//    for (int i=0; i<dateStrings.count-1; i++) {
//        result = [dateStrings objectAtIndex:i];
//        [string appendString:[NSString stringWithFormat:@"%@ ",result]];
//    }
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
    MessageHistoryDataModel *data=[[[messageDateArray objectAtIndex:indexPath.row]messagesHistoryArray] objectAtIndex:indexPath.row];
        CGSize size = CGSizeMake(personalMessageTableView.frame.size.width-20,999);
        CGRect textRect = [@"gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer hema"
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
     MessageHistoryDataModel *data=[[[messageDateArray objectAtIndex:indexPath.row]messagesHistoryArray] objectAtIndex:indexPath.row];
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
        return otherCell;
    }
    
}
#pragma mark - end


@end
