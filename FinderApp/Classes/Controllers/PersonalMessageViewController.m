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

@interface PersonalMessageViewController ()
{
    NSString *offset;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

-(void)getMessageHistory {
    [[MessageService sharedManager] getMessageHistory:otherUserId readStatus:readStatus pageOffSet:offset success:^(id responseObject) {
        [myDelegate stopIndicator];
        
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSString *simpleTableIdentifier = @"meCell";
        PersonalMessageViewCell *meCell=[personalMessageTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (meCell == nil)
        {
            meCell=[[PersonalMessageViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
   
          return meCell;

//        NSString *simpleTableIdentifier = @"otherUserCell";
//        PersonalMessageViewCell *otherCell=[personalMessageTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//        if (otherCell == nil)
//        {
//            otherCell=[[PersonalMessageViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
//        }
//        return otherCell;
    
}
#pragma mark - end


@end
