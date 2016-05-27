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
- (IBAction)sendMessageBtnAction:(id)sender{
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
