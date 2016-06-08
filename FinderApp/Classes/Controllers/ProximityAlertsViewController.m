//
//  ProximityAlertsViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 13/05/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ProximityAlertsViewController.h"
#import "ProximityAlertViewCell.h"
#import "ScheduleMeetingViewController.h"

@interface ProximityAlertsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *proximityAlertTableView;
@end

@implementation ProximityAlertsViewController
@synthesize proximityAlertTableView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Proximity Alerts";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 125;
    }
    else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSString *simpleTableIdentifier = @"proximityRadiusCell";
        ProximityAlertViewCell *proximityCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (proximityCell == nil)  {
            proximityCell = [[ProximityAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [proximityCell.delegateRangeView addShadow:proximityCell.delegateRangeView color:[UIColor lightGrayColor]];
        proximityCell.sliderView.minimumValue=25;
        proximityCell.sliderView.maximumValue=200;
        
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
    else {
        NSString *simpleTableIdentifier = @"proximityListCell";
        ProximityAlertViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (listCell == nil)
        {
            listCell = [[ProximityAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [listCell.proximityListContainerView addShadow:listCell.proximityListContainerView color:[UIColor lightGrayColor]];
        [listCell.scheduleMeetingBtn addTarget:self action:@selector(scheduleMeeting:) forControlEvents:UIControlEventTouchUpInside];
        //  [settingsCell.switchBtn addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventTouchUpInside];
        return listCell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row == 4)
    //    {
    //        changePwdContainerView.hidden = NO;
    //    }
}
#pragma mark - end

#pragma mark - IBActions
//slider value
- (IBAction)sliderValueChanged:(ASValueTrackingSlider *)slider{
    [slider setValue:((int)((slider.value + 2.5) / 25) * 25)];
    NSMutableDictionary *tempDict=[[UserDefaultManager getValue:@"switchStatusDict"] mutableCopy];
    [tempDict setObject:[NSString stringWithFormat:@"%.2f", slider.value] forKey:@"02"];
    [UserDefaultManager setValue:tempDict key:@"switchStatusDict"];
}

- (IBAction)scheduleMeeting:(UIButton *)sender{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleMeetingViewController *scheduleMeeting =[storyboard instantiateViewControllerWithIdentifier:@"ScheduleMeetingViewController"];
     scheduleMeeting.screenName=@"Proximity";
    scheduleMeeting.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [scheduleMeeting setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:scheduleMeeting animated: NO completion:nil];
    
}
#pragma mark - end
@end
