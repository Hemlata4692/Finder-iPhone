//
//  MessagesViewController.m
//  Finder_iPhoneApp
//
//  Created by Monika on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessagesViewCell.h"

@interface MessagesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"MESSAGE";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"messagesCell";
     MessagesViewCell *messagesCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (messagesCell == nil)
    {
        messagesCell = [[MessagesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
   [messagesCell.messageViewContainer addShadow:messagesCell.messageViewContainer color:[UIColor lightGrayColor]];
    return messagesCell;
}
#pragma mark - end

@end
