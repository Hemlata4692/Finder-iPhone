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
#import "MyButton.h"
#import "ASValueTrackingSlider.h"

@interface SettingsViewController () {
    NSMutableArray *settingsSection1Array, *settingsSection2Array;
    NSMutableArray *setSwitchStatus;
}
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (nonatomic, strong) NSString *switchIdentifire;
@property (nonatomic, strong) NSString *switchStatus;

@end

@implementation SettingsViewController
@synthesize settingsTableView,switchIdentifire,switchStatus;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"My Settings";
    // Do any additional setup after loading the view.
    settingsSection1Array = [NSMutableArray arrayWithObjects:@"Pre-Conference Match",@"Proximity Alert", nil];
    settingsSection2Array = [NSMutableArray arrayWithObjects:@"New Message",@"Request Accepted",@"Proximity Matches",@"Conference Updates",nil];
    setSwitchStatus=[[NSMutableArray alloc]init];
    
    [myDelegate showIndicator];
    [self performSelector:@selector(getUserSettings) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else {
        return 40;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * notificationLabel = [[UILabel alloc] init];
    notificationLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
    notificationLabel.text=@"Notifications";
    float width =  [notificationLabel.text boundingRectWithSize:notificationLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:notificationLabel.font } context:nil]
    .size.width;
    notificationLabel.frame = CGRectMake(15, 10, width,30.0);
    notificationLabel.textColor=[UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1];
    [headerView addSubview:notificationLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 3;
    }
    else {
        return settingsSection2Array.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            return 125;
        }
        else {
            return 60;
        }
    }
    else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==2) {
        NSString *simpleTableIdentifier = @"proximityCell";
        SettingsViewCell *proximityCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (proximityCell == nil) {
            proximityCell = [[SettingsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [proximityCell.proximityRadiusView addShadow:proximityCell.proximityRadiusView color:[UIColor lightGrayColor]];
        proximityCell.sliderView.minimumValue=25;
        proximityCell.sliderView.maximumValue=200;
        //        UIImage *thumbImage = [UIImage imageNamed:@"knob.png"];
        //        UIImage *sliderMinTrackImage = [UIImage imageNamed: @"range_slider.png"];
        //        UIImage *sliderMaxTrackImage = [UIImage imageNamed: @"range_slider.png"];
        //        sliderMinTrackImage = [sliderMinTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 17, 0, 0)];
        //        sliderMaxTrackImage = [sliderMaxTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 17)];
        //        [proximityCell.sliderView setThumbImage:thumbImage forState:UIControlStateNormal];
        //        [proximityCell.sliderView setMinimumTrackImage:sliderMinTrackImage forState:UIControlStateNormal];
        //        [proximityCell.sliderView setMaximumTrackImage:sliderMaxTrackImage forState:UIControlStateNormal];
        //
        [NSString stringWithFormat:@"%2d,M",[[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"] intValue]];
        [proximityCell.sliderView setValue:[[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"] intValue]];
        [proximityCell.sliderView setMaxFractionDigitsDisplayed:0];
        proximityCell.sliderView.popUpViewColor = [UIColor colorWithRed:47.0/255.0 green:81.0/255.0 blue:116.0/255.0 alpha:1.0];
        proximityCell.sliderView.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        proximityCell.sliderView.textColor = [UIColor whiteColor];
        proximityCell.sliderView.popUpViewWidthPaddingFactor = 1.7;
        [proximityCell.sliderView showPopUpViewAnimated:YES];
        [proximityCell.sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        return proximityCell;
    }
    else {
        NSString *simpleTableIdentifier = @"settingsCell";
        SettingsViewCell *settingsCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (settingsCell == nil) {
            settingsCell = [[SettingsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [settingsCell.settingsContainerView addShadow:settingsCell.settingsContainerView color:[UIColor lightGrayColor]];
        if (indexPath.section==0) {
            settingsCell.nameLabel.text=[settingsSection1Array objectAtIndex:indexPath.row];
        }
        else {
            settingsCell.nameLabel.text=[settingsSection2Array objectAtIndex:indexPath.row];
        }
        settingsCell.switchBtn.Tag=(int)indexPath.row;
        settingsCell.switchBtn.sectionTag=(int)indexPath.section;

        if ([[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:[NSString stringWithFormat:@"%d%d", settingsCell.switchBtn.sectionTag,settingsCell.switchBtn.Tag]] isEqualToString: @"false"]) {
            settingsCell.switchBtn.on=0;
            [settingsCell.switchBtn setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
        }
        else {
            settingsCell.switchBtn.on=1;
            [settingsCell.switchBtn setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
        }
        [settingsCell.switchBtn addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventTouchUpInside];
        return settingsCell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.row == 4)
    //    {
    //        changePwdContainerView.hidden = NO;
    //    }
}
#pragma mark - end

#pragma mark - IBActions
//slider value
- (IBAction)sliderValueChanged:(ASValueTrackingSlider *)slider {
    [slider setValue:((int)((slider.value + 2.5) / 25) * 25)];
    NSMutableDictionary *tempDict=[[UserDefaultManager getValue:@"switchStatusDict"] mutableCopy];
    [tempDict setObject:[NSString stringWithFormat:@"%.2f", slider.value] forKey:@"02"];
    [UserDefaultManager setValue:tempDict key:@"switchStatusDict"];
}
//switch value
- (IBAction)switchViewChanged:(MyButton *)switchView {
    if (switchView.sectionTag==0) {
        if ( switchView.Tag==0) {
            NSLog(@"Value 0: %i", switchView.on);
            if (switchView.on==1) {
                switchView.on=0;
                switchStatus=@"false";
                switchIdentifire=@"preConferenceMatch";
                [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else {
                switchView.on=1;
                switchStatus=@"true";
                switchIdentifire=@"preConferenceMatch";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
        else if (switchView.Tag==1) {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==1) {
                switchView.on=0;
                switchStatus=@"false";
                switchIdentifire=@"proximityAlert";
                [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else  {
                switchView.on=1;
                switchStatus=@"true";
                switchIdentifire=@"proximityAlert";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
    }
    else {
        if (switchView.Tag==0) {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==1) {
                switchView.on=0;
                switchStatus=@"false";
                switchIdentifire=@"newMessage";
                [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else {
                switchView.on=1;
                switchStatus=@"true";
                switchIdentifire=@"newMessage";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
        if (switchView.Tag==1) {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==1) {
                switchView.on=0;
                switchStatus=@"false";
                switchIdentifire=@"requestAccept";
                [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else  {
                switchView.on=1;
                switchStatus=@"true";
                switchIdentifire=@"requestAccept";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
        if (switchView.Tag==2) {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==1) {
                switchView.on=0;
                switchStatus=@"false";
                switchIdentifire=@"proximityMatches";
                [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else {
                switchView.on=1;
                switchStatus=@"true";
                switchIdentifire=@"proximityMatches";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
        if (switchView.Tag==3) {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==1) {
                switchView.on=0;
                switchStatus=@"false";
                switchIdentifire=@"conferenceUpdates";
                [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else {
                switchView.on=1;
                switchStatus=@"true";
                switchIdentifire=@"conferenceUpdates";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
    }
}

#pragma mark - end

#pragma mark - Webservice
-(void)changeSettings:(NSString *)switchKey {
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
-(void)getUserSettings {
    [[ConferenceService sharedManager] getUserSetting:^(id responseObject) {
        [myDelegate stopIndicator];
        if ([[responseObject objectForKey:@"isSuccess"] isEqualToString:@"1"]) {
            NSDictionary *settingDict=[responseObject objectForKey:@"conferenceSettings"];
            NSMutableDictionary *tempDict=[[UserDefaultManager getValue:@"switchStatusDict"] mutableCopy];
            if ([settingDict objectForKey:@"preConferenceMatch"]) {
                [tempDict setObject:[settingDict objectForKey:@"preConferenceMatch"] forKey:@"00"];
            }
            if ([settingDict objectForKey:@"proximityAlert"]) {
                [tempDict setObject:[settingDict objectForKey:@"proximityAlert"] forKey:@"01"];
            }
                       if ([settingDict objectForKey:@"newMessage"]) {
                [tempDict setObject:[settingDict objectForKey:@"newMessage"] forKey:@"10"];
            }
            if ([settingDict objectForKey:@"requestAccept"]) {
                [tempDict setObject:[settingDict objectForKey:@"requestAccept"] forKey:@"11"];
            }
            if ([settingDict objectForKey:@"proximityMatches"]) {
                [tempDict setObject:[settingDict objectForKey:@"proximityMatches"] forKey:@"12"];
            }
            if ([settingDict objectForKey:@"conferenceUpdates"]) {
                [tempDict setObject:[settingDict objectForKey:@"conferenceUpdates"] forKey:@"13"];
            }
            [UserDefaultManager setValue:tempDict key:@"switchStatusDict"];
            [settingsTableView reloadData];
        }
    }
                                              failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end
@end
