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
#import "MyProfileViewController.h"
#import "OtherUserProfileViewController.h"
#import "MatchesService.h"
#import "MatchesDataModel.h"
#import "MyButton.h"

@interface MatchesViewController ()
{
    NSInteger selectedSegment;
    NSMutableArray *allMatchesDataArray;
    NSMutableArray *latestMatchesArray;
    NSMutableArray *contactArray;
    int btnTag;
}
@property (weak, nonatomic) IBOutlet UITableView *matchesTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchesSegmentControl;
@property (nonatomic,retain) NSString * accepted;
@property (nonatomic,retain) NSString * requestSent;
@property (nonatomic,retain) NSString * reviewStatus;
@property (nonatomic,retain) NSString * otherUserId;
@property (nonatomic,retain) NSString * requestArrived;
@end

@implementation MatchesViewController
@synthesize noRecordLabel;
@synthesize matchesTableView;
@synthesize requestArrived;
@synthesize accepted;
@synthesize reviewStatus;
@synthesize otherUserId;
@synthesize requestSent;
@synthesize matchesSegmentControl;

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Matches";
    [self setTabBarImages];
    //    noRecordLabel.hidden=NO;
    //    matchesTableView.hidden=YES;
    allMatchesDataArray=[[NSMutableArray alloc]init];
    latestMatchesArray=[[NSMutableArray alloc]init];
    contactArray=[[NSMutableArray alloc]init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    matchesSegmentControl.selectedSegmentIndex=1;
    selectedSegment=1;
    [myDelegate showIndicator];
    [self performSelector:@selector(getMatchesDetails) withObject:nil afterDelay:.1];
}
#pragma mark - end
#pragma mark - Set tabbar images
-(void)setTabBarImages{
    UITabBarController * myTab = (UITabBarController *)self.tabBarController;
    UITabBar *tabBar = myTab.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
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
    
    tempImg =[UIImage imageNamed:@"proximity_tab"];
    [tabBarItem3 setImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"proximity_tab"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tempImg =[UIImage imageNamed:@"proximity_selected"];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:[tempImg imageForDeviceWithNameForOtherImages:@"proximity_selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
    // myTab.selectedIndex=2;
}

#pragma mark - end
#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (selectedSegment==0) {
        return latestMatchesArray.count;
    }
    else if (selectedSegment==1) {
        return allMatchesDataArray.count;
    }
    else {
        return contactArray.count;
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedSegment == 2)  {
        NSString *simpleTableIdentifier = @"contactsCell";
        MatchesTableViewCell *contactsCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (contactsCell == nil)  {
            contactsCell = [[MatchesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [contactsCell.contactsContainerView addShadow:contactsCell.contactsContainerView color:[UIColor lightGrayColor]];
        MatchesDataModel *data=[contactArray objectAtIndex:indexPath.row];
        [contactsCell displayContacts:data indexPath:(int)indexPath.row rectSize:contactsCell.frame.size];
        contactsCell.scheduleMeetingBtn.Tag=(int)indexPath.row;
        contactsCell.messageButton.Tag=(int)indexPath.row;
        [contactsCell.scheduleMeetingBtn addTarget:self action:@selector(scheduleMeetingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [contactsCell.messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        return contactsCell;
    }
    //new segement
    else if (selectedSegment == 0) {
        NSString *simpleTableIdentifier = @"matchesCell";
        MatchesTableViewCell *newMatchesCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (newMatchesCell == nil)  {
            newMatchesCell = [[MatchesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [newMatchesCell.containerView addShadow:newMatchesCell.containerView color:[UIColor lightGrayColor]];
        MatchesDataModel *data=[latestMatchesArray objectAtIndex:indexPath.row];
        [newMatchesCell displayNewMatchRequests:data indexPath:(int)indexPath.row rectSize:newMatchesCell.frame.size];
        newMatchesCell.approveButton.Tag=(int)indexPath.row;
        newMatchesCell.cancelButton.Tag=(int)indexPath.row;
        [newMatchesCell.approveButton addTarget:self action:@selector(approveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [newMatchesCell.cancelButton addTarget:self action:@selector(cancelRequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return newMatchesCell;
    }
    else {
        
        NSString *simpleTableIdentifier = @"matchesCell";
        MatchesTableViewCell *matchesCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (matchesCell == nil)  {
            matchesCell = [[MatchesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [matchesCell.containerView addShadow:matchesCell.containerView color:[UIColor lightGrayColor]];
        MatchesDataModel *data=[allMatchesDataArray objectAtIndex:indexPath.row];
        [matchesCell displayData:data indexPath:(int)indexPath.row rectSize:matchesCell.frame.size];
        matchesCell.allMatchesApproveButton.Tag=(int)indexPath.row;
        matchesCell.allMatchesRejectButton.Tag=(int)indexPath.row;
        matchesCell.sendRequestButton.Tag=(int)indexPath.row;
        [matchesCell.allMatchesApproveButton addTarget:self action:@selector(allMatchesApproveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [matchesCell.allMatchesRejectButton addTarget:self action:@selector(allMatchesRejectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [matchesCell.sendRequestButton addTarget:self action:@selector(sendRequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return matchesCell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedSegment==0) {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserProfileViewController *userProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
        userProfile.viewType=@"Matches";
        userProfile.otherUserId=[[latestMatchesArray objectAtIndex:indexPath.row] otherUserId];
        userProfile.isRequestSent=[[latestMatchesArray objectAtIndex:indexPath.row] isRequestSent];
        userProfile.isRequestArrived=[[latestMatchesArray objectAtIndex:indexPath.row] isArrived];
        [self.navigationController pushViewController:userProfile animated:YES];

    }
    else if (selectedSegment==1) {
        if ([[[allMatchesDataArray objectAtIndex:indexPath.row] isAccepted] isEqualToString:@"T"]) {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyProfileViewController *profileView =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
            profileView.viewName=@"User Profile";
            profileView.viewType=@"Matches";
            profileView.otherUserID=[[allMatchesDataArray objectAtIndex:indexPath.row] otherUserId];
            [self.navigationController pushViewController:profileView animated:YES];
        }
        else {
            UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OtherUserProfileViewController *userProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
            userProfile.viewType=@"Matches";
            userProfile.otherUserId=[[allMatchesDataArray objectAtIndex:indexPath.row] otherUserId];
            userProfile.isRequestSent=[[allMatchesDataArray objectAtIndex:indexPath.row] isRequestSent];
            userProfile.isRequestArrived=[[allMatchesDataArray objectAtIndex:indexPath.row] isArrived];
            [self.navigationController pushViewController:userProfile animated:YES];
        }

    }
    else {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyProfileViewController *profileView =[storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
        profileView.viewName=@"User Profile";
        profileView.viewType=@"Matches";
        profileView.otherUserID=[[contactArray objectAtIndex:indexPath.row] otherUserId];
        [self.navigationController pushViewController:profileView animated:YES];
    }
}
#pragma mark - end
#pragma mark - Webservice
//get matches details
-(void)getMatchesDetails
{
    [[MatchesService sharedManager] getMatchesList:^(id dataArray) {
        [myDelegate stopIndicator];
        allMatchesDataArray=[dataArray mutableCopy];
      //  matchesSegmentControl.selectedSegmentIndex=1;
        if (matchesSegmentControl.selectedSegmentIndex==0) {
            selectedSegment=0;
            
        }
        else{
            selectedSegment=1;
        }
        if (allMatchesDataArray.count==0) {
            noRecordLabel.hidden=NO;
            noRecordLabel.text=@"No matches found.";
        }
        else {
            [self filterData];
        }
    }
                                           failure:^(NSError *error)
     {
         
     }] ;
}
//filter data for new , all and contacts segment
-(void)filterData {
    
    [latestMatchesArray removeAllObjects];
    [contactArray removeAllObjects];
    if (selectedSegment==0)
    {
        //new segment
        for (int i =0; i<allMatchesDataArray.count; i++)
        {
            MatchesDataModel *requestArrivedData = [allMatchesDataArray objectAtIndex:i];
            
            if ([[[allMatchesDataArray objectAtIndex:i] isArrived] isEqualToString:@"T"])
            {
                [latestMatchesArray addObject:requestArrivedData];
                noRecordLabel.hidden=YES;
            }
        }
        if (latestMatchesArray.count==0) {
            noRecordLabel.hidden=NO;
            noRecordLabel.text=@"No new match requests.";
        }
    }
    else if (selectedSegment==1)
    {
        noRecordLabel.hidden=YES;
    }
    else{
        //contacts segment
        for (int i =0; i<allMatchesDataArray.count; i++)
        {
            MatchesDataModel *acceptedRequests = [allMatchesDataArray objectAtIndex:i];
            
            if ([[[allMatchesDataArray objectAtIndex:i] isAccepted] isEqualToString:@"T"])
            {
                [contactArray addObject:acceptedRequests];
                noRecordLabel.hidden=YES;
            }
        }
        if (contactArray.count==0) {
            noRecordLabel.hidden=NO;
            noRecordLabel.text=@"No contacts added yet.";
        }
    }
    [matchesTableView reloadData];
    
}
//send/cancel match request
-(void)sendCancelMatchRequest {
    [[MatchesService sharedManager] sendCancelMatchRequest:otherUserId sendRequest:requestSent success:^(id responseObject) {
        [myDelegate stopIndicator];
        MatchesDataModel *tempModel = [allMatchesDataArray objectAtIndex:btnTag];
        tempModel.isRequestSent=requestSent;
        [allMatchesDataArray replaceObjectAtIndex:btnTag withObject:tempModel];
        [matchesTableView reloadData];
    }
                                                   failure:^(NSError *error)
     {
         
     }] ;
    
}

//accept/decline match request
-(void)acceptDeclineRequest {
    if (selectedSegment==0) {
        [[MatchesService sharedManager] acceptDeclineRequest:otherUserId acceptRequest:accepted success:^(id responseObject) {
            [self getMatchesDetails];
//            MatchesDataModel *tempModel = [latestMatchesArray objectAtIndex:btnTag];
//            tempModel.isAccepted=accepted;
//            tempModel.isArrived=@"F";
//            tempModel.isRequestSent=@"F";
//            [latestMatchesArray replaceObjectAtIndex:btnTag withObject:tempModel];
            [matchesTableView reloadData];
            
        }
                                                     failure:^(NSError *error)
         {
             
         }] ;
    }
    else {
        
        [[MatchesService sharedManager] acceptDeclineRequest:otherUserId acceptRequest:accepted success:^(id responseObject) {
            [myDelegate stopIndicator];
            MatchesDataModel *tempModel = [allMatchesDataArray objectAtIndex:btnTag];
            tempModel.isAccepted=accepted;
            tempModel.isArrived=@"F";
            tempModel.isRequestSent=@"F";
            [allMatchesDataArray replaceObjectAtIndex:btnTag withObject:tempModel];
            [matchesTableView reloadData];
            
        }
                                                     failure:^(NSError *error)
         {
             
         }] ;
        
    }
    
}
#pragma mark - end
#pragma mark - Segment control

- (IBAction)matchesSegmentAction:(UISegmentedControl *)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    selectedSegment = segmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        [self filterData];
    }
    else if(selectedSegment == 1) {
        [self filterData];
    }
    else {
        [self filterData];
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)scheduleMeetingBtnAction:(MyButton *)sender {
    btnTag=[sender Tag];
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleMeetingViewController *scheduleMeeting =[storyboard instantiateViewControllerWithIdentifier:@"ScheduleMeetingViewController"];
    scheduleMeeting.screenName=@"Matches";
     scheduleMeeting.ContactName=[[contactArray objectAtIndex:btnTag]userName];
    scheduleMeeting.contactUserID=[[contactArray objectAtIndex:btnTag]otherUserId];
    scheduleMeeting.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    [scheduleMeeting setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:scheduleMeeting animated: NO completion:nil];
}

- (IBAction)sendMessage:(MyButton *)sender {
    
}

- (IBAction)approveButtonAction:(MyButton *)sender {
    btnTag=[sender Tag];
    otherUserId=[[latestMatchesArray objectAtIndex:btnTag]otherUserId];
    accepted=@"T";
    [myDelegate showIndicator];
    [self performSelector:@selector(acceptDeclineRequest) withObject:nil afterDelay:.1];
}

- (IBAction)cancelRequestButtonAction:(MyButton *)sender {
    btnTag=[sender Tag];
    otherUserId=[[latestMatchesArray objectAtIndex:btnTag]otherUserId];
    accepted=@"F";
    [myDelegate showIndicator];
    [self performSelector:@selector(acceptDeclineRequest) withObject:nil afterDelay:.1];
}

- (IBAction)allMatchesApproveButtonAction:(MyButton *)sender {
    btnTag=[sender Tag];
    otherUserId=[[allMatchesDataArray objectAtIndex:btnTag]otherUserId];
    if ([[[allMatchesDataArray objectAtIndex:btnTag]isArrived] isEqualToString:@"T"]) {
        accepted=@"T";
        [myDelegate showIndicator];
        [self performSelector:@selector(acceptDeclineRequest) withObject:nil afterDelay:.1];
    }
    else if ([[[allMatchesDataArray objectAtIndex:btnTag]isRequestSent] isEqualToString:@"T"]) {
         NSLog(@"pending");
    }
    else if ([[[allMatchesDataArray objectAtIndex:btnTag]isAccepted] isEqualToString:@"T"]) {
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ScheduleMeetingViewController *scheduleMeeting =[storyboard instantiateViewControllerWithIdentifier:@"ScheduleMeetingViewController"];
        scheduleMeeting.screenName=@"Matches";
        scheduleMeeting.ContactName=[[allMatchesDataArray objectAtIndex:btnTag]userName];
        scheduleMeeting.contactUserID=[[allMatchesDataArray objectAtIndex:btnTag]otherUserId];
        scheduleMeeting.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
        [scheduleMeeting setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self presentViewController:scheduleMeeting animated: NO completion:nil];

    }
    
}

- (IBAction)allMatchesRejectButtonAction:(MyButton *)sender {
    btnTag=[sender Tag];
    otherUserId=[[allMatchesDataArray objectAtIndex:btnTag]otherUserId];
    if ([[[allMatchesDataArray objectAtIndex:btnTag]isArrived] isEqualToString:@"T"]) {
        accepted=@"F";
        [myDelegate showIndicator];
        [self performSelector:@selector(acceptDeclineRequest) withObject:nil afterDelay:.1];
    }
    else if ([[[allMatchesDataArray objectAtIndex:btnTag]isRequestSent] isEqualToString:@"T"]) {
        requestSent=@"F";
        [myDelegate showIndicator];
        [self performSelector:@selector(sendCancelMatchRequest) withObject:nil afterDelay:.1];
    }
    else if ([[[allMatchesDataArray objectAtIndex:btnTag]isAccepted] isEqualToString:@"T"]) {
        NSLog(@"message");
    }
    
}

- (IBAction)sendRequestButtonAction:(MyButton *)sender {
    btnTag=[sender Tag];
    otherUserId=[[allMatchesDataArray objectAtIndex:btnTag]otherUserId];
    requestSent=@"T";
    [myDelegate showIndicator];
    [self performSelector:@selector(sendCancelMatchRequest) withObject:nil afterDelay:.1];
}

#pragma mark - end
@end
