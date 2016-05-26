//
//  NewMessageViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "NewMessageViewController.h"
#import "MessagesViewCell.h"

@interface NewMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *contactListTableView;

@end

@implementation NewMessageViewController
@synthesize contactListTableView;
#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Contacts";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"newMessageCell";
    MessagesViewCell *newMsg=[contactListTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (newMsg == nil)
    {
        newMsg=[[MessagesViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    [newMsg.messageContainerView addShadow:newMsg.messageContainerView color:[UIColor lightGrayColor]];
    [newMsg.userImageView setCornerRadius:newMsg.userImageView.frame.size.width/2];
    return newMsg;
    
}
#pragma mark - end
@end
