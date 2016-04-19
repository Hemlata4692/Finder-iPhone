//
//  SettingsViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsViewCell.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end

@implementation SettingsViewController
@synthesize settingsTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"MY SETTINGS";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
    {
         return 35;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * notificationLabel = [[UILabel alloc] init];
    notificationLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    notificationLabel.text=@"NOTIFICATIONS";
    float width =  [notificationLabel.text boundingRectWithSize:notificationLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:notificationLabel.font } context:nil]
    .size.width;
    notificationLabel.frame = CGRectMake(15, 0, width,35.0);
    notificationLabel.textColor=[UIColor colorWithRed:(40.0/255.0) green:(40.0/255.0) blue:(40.0/255.0) alpha:1];
    [headerView addSubview:notificationLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    else
    {
    return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==2) {
            return 100;
        }
        else
        {
        return 65;
        }
    }
    else
    {
        return 65;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==2)
    {
        NSString *simpleTableIdentifier = @"proximityCell";
        SettingsViewCell *proximityCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (proximityCell == nil)
        {
            proximityCell = [[SettingsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        proximityCell.proximityRadiusView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        proximityCell.proximityRadiusView.layer.shadowOffset = CGSizeMake(0, 1);
        proximityCell.proximityRadiusView.layer.shadowOpacity = 1;
        proximityCell.proximityRadiusView.layer.shadowRadius = 1.0;

        return proximityCell;
    }
    else
    {
        NSString *simpleTableIdentifier = @"settingsCell";
        SettingsViewCell *settingsCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (settingsCell == nil)
        {
            settingsCell = [[SettingsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        settingsCell.settingsContainerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        settingsCell.settingsContainerView.layer.shadowOffset = CGSizeMake(0, 1);
        settingsCell.settingsContainerView.layer.shadowOpacity = 1;
        settingsCell.settingsContainerView.layer.shadowRadius = 1.0;
        RESwitch *defaultSwitch = [settingsCell viewWithTag:10];
        if (!defaultSwitch)
        {
            defaultSwitch = [[RESwitch alloc] initWithFrame:CGRectMake(settingsCell.nameLabel.frame.size.width+70, settingsCell.settingsContainerView.frame.size.height/2-5, 75, 28)];
            defaultSwitch.tag = 10;
             [settingsCell.settingsContainerView  addSubview:defaultSwitch];
        }
       [defaultSwitch addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
        return settingsCell;
    }
    

}
- (void)switchViewChanged:(RESwitch *)switchView
{
    NSLog(@"Value: %i", switchView.on);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 4)
//    {
//        changePwdContainerView.hidden = NO;
//    }
}
#pragma mark - end
@end
