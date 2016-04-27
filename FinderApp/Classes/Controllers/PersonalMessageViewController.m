//
//  PersonalMessageViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "PersonalMessageViewController.h"
#import "PersonalMessageViewCell.h"

@interface PersonalMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *personalMessageTableView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITextView *sendMessageTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;
@end

@implementation PersonalMessageViewController
@synthesize personalMessageTableView,messageView,sendMessageTextView,sendMessageBtn;

#pragma mark- View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)sendMessageBtnAction:(id)sender
{
}
#pragma mark - end

#pragma mark - Table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalMessageViewCell *cell=[personalMessageTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell=[[PersonalMessageViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    return cell;
}
@end
