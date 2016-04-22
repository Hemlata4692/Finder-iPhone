//
//  SettingsViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsViewCell.h"
#import "ConferenceService.h"
#import "RESwitch.h"
#import "NYSliderPopover.h"

@interface SettingsViewController ()
{
    NSMutableArray *settingsSection1Array, *settingsSection2Array;
    NSMutableArray *setSwitchStatus;
}
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (nonatomic, strong) NSString *switchIdentifire;
@property (nonatomic, strong) NSString *switchStatus;

@end

@implementation SettingsViewController
@synthesize settingsTableView,switchIdentifire,switchStatus;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"MY SETTINGS";
    // Do any additional setup after loading the view.
    settingsSection1Array = [NSMutableArray arrayWithObjects:@"Pre-Conference Match",@"Proximity Alert", nil];
    settingsSection2Array = [NSMutableArray arrayWithObjects:@"New Request",@"New Message",@"Request Accepted", nil];
    setSwitchStatus=[[NSMutableArray alloc]init];
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
        return 40;
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
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * notificationLabel = [[UILabel alloc] init];
    notificationLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    notificationLabel.text=@"NOTIFICATIONS";
    float width =  [notificationLabel.text boundingRectWithSize:notificationLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:notificationLabel.font } context:nil]
    .size.width;
    notificationLabel.frame = CGRectMake(15, 0, width,40.0);
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
            return 125;
        }
        else
        {
            return 60;
        }
    }
    else
    {
        return 60;
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
        [proximityCell.proximityRadiusView addShadow:proximityCell.proximityRadiusView color:[UIColor lightGrayColor]];
        proximityCell.sliderView.minimumValue=50;
        proximityCell.sliderView.maximumValue=500;
        //proximityCell.sliderView.popover.textLabel.text = [NSString stringWithFormat:@"%.2f", proximityCell.sliderView.value];
        [proximityCell.sliderView setValue:[[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"] intValue]];
      //  proximityCell.sliderView.value=[[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"] intValue];
        proximityCell.sliderView.popover.textLabel.text=[NSString stringWithFormat:@"%.2f", proximityCell.sliderView.value];
        [proximityCell.sliderView showPopover];
        [proximityCell.sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        
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
        [settingsCell.settingsContainerView addShadow:settingsCell.settingsContainerView color:[UIColor lightGrayColor]];
        
        if (indexPath.section==0) {
            settingsCell.nameLabel.text=[settingsSection1Array objectAtIndex:indexPath.row];
        }
        else
        {
            settingsCell.nameLabel.text=[settingsSection2Array objectAtIndex:indexPath.row];
        }
        
        RESwitch *defaultSwitch = [settingsCell viewWithTag:10];
        if (!defaultSwitch)
        {
            defaultSwitch = [[RESwitch alloc] initWithFrame:CGRectMake(settingsTableView.frame.size.width-85, settingsCell.nameLabel.frame.origin.y+settingsCell.nameLabel.frame.size.height/2-12, 70, 25)];
            defaultSwitch.tag = 10;
            [settingsCell.settingsContainerView  addSubview:defaultSwitch];
        }
        defaultSwitch.switchTag=(int)indexPath.row;
        defaultSwitch.sectionTag=(int)indexPath.section;
        
        if ([[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:[NSString stringWithFormat:@"%d%d", defaultSwitch.sectionTag,defaultSwitch.switchTag]] isEqualToString: @"False"])
        {
            defaultSwitch.on=0;
        }
        else
        {
            defaultSwitch.on=1;
        }
        
        [defaultSwitch addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
        return settingsCell;
    }
}

- (IBAction)sliderValueChanged:(NYSliderPopover *)slider
{
    [slider setValue:((int)((slider.value + 2.5) / 50) * 50)];
    slider.popover.textLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
    NSMutableDictionary *tempDict=[[UserDefaultManager getValue:@"switchStatusDict"] mutableCopy];
    [tempDict setObject:[NSString stringWithFormat:@"%.2f", slider.value] forKey:@"02"];
    [UserDefaultManager setValue:tempDict key:@"switchStatusDict"];
}


- (void)switchViewChanged:(RESwitch *)switchView
{
    if (switchView.sectionTag==0) {
        
        if ( switchView.switchTag==0) {
            NSLog(@"Value 0: %i", switchView.on);
            if (switchView.on==0) {
                switchStatus=@"False";
                switchIdentifire=@"preConferenceMatch";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
            else
            {
                switchStatus=@"True";
                switchIdentifire=@"preConferenceMatch";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
        }
        else if (switchView.switchTag==1)
        {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==0) {
                switchStatus=@"False";
                switchIdentifire=@"proximityAlert";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
            else
            {
                switchStatus=@"True";
                switchIdentifire=@"proximityAlert";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
        }
    }
    else
    {
        if (switchView.switchTag==0)
        {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==0) {
                switchStatus=@"False";
                switchIdentifire=@"newRequest";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
            else
            {
                switchStatus=@"True";
                switchIdentifire=@"newRequest";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
        }
        if (switchView.switchTag==1)
        {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==0) {
                switchStatus=@"False";
                switchIdentifire=@"newMessage";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
            else
            {
                switchStatus=@"True";
                switchIdentifire=@"newMessage";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
        }
        if (switchView.switchTag==2)
        {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==0) {
                switchStatus=@"False";
                switchIdentifire=@"requestAccept";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
            else
            {
                switchStatus=@"True";
                switchIdentifire=@"requestAccept";
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.switchTag]];
            }
        }
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row == 4)
    //    {
    //        changePwdContainerView.hidden = NO;
    //    }
}
#pragma mark - end

#pragma mark - Webservice
-(void)changeSettings:(NSString *)switchKey
{
    [[ConferenceService sharedManager] changeSettings:switchIdentifire switchStatus:switchStatus success:^(id responseObject) {
        if ([[responseObject objectForKey:@"isSuccess"] isEqualToString:@"1"]) {
            
            NSMutableDictionary *tempDict=[[UserDefaultManager getValue:@"switchStatusDict"] mutableCopy];
            [tempDict setObject:switchStatus forKey:switchKey];
            [UserDefaultManager setValue:tempDict key:@"switchStatusDict"];
            
        }
    }
                                              failure:^(NSError *error)
     {
         
     }] ;
    
}

@end
