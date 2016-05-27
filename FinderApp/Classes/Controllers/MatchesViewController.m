//
//  MatchesViewController.m
//  Finder_iPhoneApp
//
//  Created by Monika on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MatchesViewController.h"
#import "MatchesTableViewCell.h"
#import "ConferenceService.h"
#import "UIImage+deviceSpecificMedia.h"
#import "ScheduleMeetingViewController.h"

@interface MatchesViewController ()
{
    NSInteger selectedSegment;
}
@property (weak, nonatomic) IBOutlet UITableView *matchesTableView;

@end

@implementation MatchesViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Matches";
    [self setTabBarImages];
   
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //    [myDelegate showIndicator];
    //    [self performSelector:@selector(getMatchesDetails) withObject:nil afterDelay:.1];
}
#pragma mark - end
#pragma mark - Set tabbar images
-(void)setTabBarImages
{
    UITabBarController * myTab = (UITabBarController *)self.tabBarController;
    UITabBar *tabBar = myTab.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    //  [[[self tabBarController] tabBar] setBackgroundImage:[UIImage imageNamed:@"header.png"]];
    tabBar.clipsToBounds=YES;
    UIImage * tempImg =[UIImage imageNamed:@"matches"];
    [tabBarItem1 setImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"matches"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tempImg =[UIImage imageNamed:@"matches_selected"];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"matches_selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    tempImg =[UIImage imageNamed:@"messages"];
    [tabBarItem2 setImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"messages"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tempImg =[UIImage imageNamed:@"messages_selected"];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"messages_selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem2.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    tempImg =[UIImage imageNamed:@"conference"];
    [tabBarItem3 setImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"conference"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tempImg =[UIImage imageNamed:@"conference_selected"];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"conference_selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem3.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    tempImg =[UIImage imageNamed:@"calendar"];
    [tabBarItem4 setImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"calendar"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tempImg =[UIImage imageNamed:@"calendar_selected"];
    [tabBarItem4 setSelectedImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"calendar_selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem4.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    tempImg =[UIImage imageNamed:@"more"];
    [tabBarItem5 setImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"more"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tempImg =[UIImage imageNamed:@"more_selected"];
    [tabBarItem5 setSelectedImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"more_selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem5.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    myTab.selectedIndex=2;
}

#pragma mark - end
#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    PostListingDataModel *postListData;
//    if (indexPath.section==0) {
//        postListData=[todayPostData objectAtIndex:indexPath.row];
//        CGSize size = CGSizeMake(postListingTableView.frame.size.width-70,999);
//        CGRect textRect = [postListData.postContent
//                           boundingRectWithSize:size
//                           options:NSStringDrawingUsesLineFragmentOrigin
//                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0]}
//                           context:nil];
//        textRect.origin.x = 8;
//        textRect.origin.y = 19;
//        if ([[todayPostData objectAtIndex:indexPath.row]uploadedPhotoArray].count==0 )
//        {
//            return 180+textRect.size.height;
//        }
//        else
//        {
//            return 286+textRect.size.height;
//        }
//    }
//    else
//    {
//        postListData=[yesterdayPostData objectAtIndex:indexPath.row];
//        CGSize size = CGSizeMake(postListingTableView.frame.size.width-70,999);
//        CGRect textRect = [postListData.postContent
//                           boundingRectWithSize:size
//                           options:NSStringDrawingUsesLineFragmentOrigin
//                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0]}
//                           context:nil];
//        textRect.origin.x = 8;
//        textRect.origin.y = 19;
//        if ([[yesterdayPostData objectAtIndex:indexPath.row]uploadedPhotoArray].count==0 )
//        {
//            return 180+textRect.size.height;
//        }
//        else
//        {
//            return 286+textRect.size.height;
//        }
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedSegment == 2)
    {
        NSString *simpleTableIdentifier = @"contactsCell";
        MatchesTableViewCell *contactsCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (contactsCell == nil)
        {
            contactsCell = [[MatchesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [contactsCell.contactsContainerView addShadow:contactsCell.contactsContainerView color:[UIColor lightGrayColor]];
         [contactsCell.scheduleMeetingBtn addTarget:self action:@selector(scheduleMeetingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return contactsCell;
    }
    else
    {
        NSString *simpleTableIdentifier = @"matchesCell";
        MatchesTableViewCell *matchesCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (matchesCell == nil)
        {
            matchesCell = [[MatchesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [matchesCell.containerView addShadow:matchesCell.containerView color:[UIColor lightGrayColor]];
        
//        CGSize size = CGSizeMake(postListingTableView.frame.size.width-70,999);
//        CGRect textRect = [postLabel.text
//                           boundingRectWithSize:size
//                           options:NSStringDrawingUsesLineFragmentOrigin
//                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0]}
//                           context:nil];
//        postLabel.numberOfLines = 0;
//        textRect.origin.x = postLabel.frame.origin.x;
//        textRect.origin.y = 19;
//        postLabel.frame = textRect;
//        //dynamic framing of objects
//        postLabel.frame =CGRectMake(8, postLabel.frame.origin.y, postListingTableView.frame.size.width-70, postLabel.frame.size.height);

        
        return matchesCell;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark - end
#pragma mark - Webservice
//-(void)getMatchesDetails
//{
//    [[ConferenceService sharedManager] getMatchesDetails:^(id matchesArray)
//     {
//         [myDelegate stopIndicator];
//     }
//                                                 failure:^(NSError *error)
//     {
//
//     }] ;
//}
#pragma mark - end
#pragma mark - Segment control

- (IBAction)matchesSegmentAction:(UISegmentedControl *)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
    }
    else if(selectedSegment == 1)
    {
    }
    else
    {
        
    }
    [self.matchesTableView reloadData];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)scheduleMeetingBtnAction:(UIButton *)sender
{
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleMeetingViewController *scheduleMeeting =[storyboard instantiateViewControllerWithIdentifier:@"ScheduleMeetingViewController"];
    scheduleMeeting.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [scheduleMeeting setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:scheduleMeeting animated: NO completion:nil];
    
}
#pragma mark - end
@end
