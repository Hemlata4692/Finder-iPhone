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

#pragma mark - View life cycle
- (void)viewDidLoad
{
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
        [proximityCell.sliderView setValue:[[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"] intValue]];
        [proximityCell.sliderView setMaxFractionDigitsDisplayed:0];
        proximityCell.sliderView.popUpViewColor = [UIColor colorWithRed:255.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
        proximityCell.sliderView.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        proximityCell.sliderView.textColor = [UIColor whiteColor];
        proximityCell.sliderView.popUpViewWidthPaddingFactor = 1.7;
        [proximityCell.sliderView showPopUpViewAnimated:YES];
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
        
        settingsCell.switchBtn.Tag=(int)indexPath.row;
        settingsCell.switchBtn.sectionTag=(int)indexPath.section;
        if ([[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:[NSString stringWithFormat:@"%d%d", settingsCell.switchBtn.sectionTag,settingsCell.switchBtn.Tag]] isEqualToString: @"False"])
        {
            settingsCell.switchBtn.on=0;
            [settingsCell.switchBtn setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
        }
        else
        {
            settingsCell.switchBtn.on=1;
            [settingsCell.switchBtn setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
        }
        
        [settingsCell.switchBtn addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventTouchUpInside];
        return settingsCell;
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

#pragma mark - IBActions
//slider value
- (IBAction)sliderValueChanged:(ASValueTrackingSlider *)slider
{
    [slider setValue:((int)((slider.value + 2.5) / 25) * 25)];
    NSMutableDictionary *tempDict=[[UserDefaultManager getValue:@"switchStatusDict"] mutableCopy];
    [tempDict setObject:[NSString stringWithFormat:@"%.2f", slider.value] forKey:@"02"];
    [UserDefaultManager setValue:tempDict key:@"switchStatusDict"];
}
//switch value
- (IBAction)switchViewChanged:(MyButton *)switchView
{
    if (switchView.sectionTag==0) {
        
        if ( switchView.Tag==0) {
            NSLog(@"Value 0: %i", switchView.on);
            if (switchView.on==1)
            {
                switchView.on=0;
                switchStatus=@"False";
                switchIdentifire=@"preConferenceMatch";
                 [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else
            {
                switchView.on=1;
                switchStatus=@"True";
                switchIdentifire=@"preConferenceMatch";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
        else if (switchView.Tag==1)
        {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==1) {
                switchView.on=0;
                switchStatus=@"False";
                switchIdentifire=@"proximityAlert";
                 [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else
            {
                switchView.on=1;
                switchStatus=@"True";
                switchIdentifire=@"proximityAlert";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
    }
    else
    {
        if (switchView.Tag==0)
        {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==1) {
                switchView.on=0;
                switchStatus=@"False";
                switchIdentifire=@"newRequest";
                 [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else
            {
                switchView.on=1;
                switchStatus=@"True";
                switchIdentifire=@"newRequest";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
        if (switchView.Tag==1)
        {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==1) {
                switchView.on=0;
                switchStatus=@"False";
                switchIdentifire=@"newMessage";
                [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else
            {
                switchView.on=1;
                switchStatus=@"True";
                switchIdentifire=@"newMessage";
                [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
        if (switchView.Tag==2)
        {
            NSLog(@"Value 1: %i", switchView.on);
            if (switchView.on==1)
            {
                switchView.on=0;
                switchStatus=@"False";
                switchIdentifire=@"requestAccept";
                 [switchView setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
            else
            {
                switchView.on=1;
                switchStatus=@"True";
                switchIdentifire=@"requestAccept";
                 [switchView setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
                [self changeSettings:[NSString stringWithFormat:@"%d%d", switchView.sectionTag,switchView.Tag]];
            }
        }
    }
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
#pragma mark - end
@end
