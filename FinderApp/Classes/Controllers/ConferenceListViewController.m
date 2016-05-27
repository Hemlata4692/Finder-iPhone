//
//  ConferenceListViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 13/05/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ConferenceListViewController.h"
#import "ConferenceService.h"
#import "ConferenceListCell.h"
#import "ConferenceListDataModel.h"
#import "HomeViewController.h"

@interface ConferenceListViewController ()
{
    NSMutableArray *conferenceListingArray;
}
@property (weak, nonatomic) IBOutlet UITableView *conferenceListTableView;


@end

@implementation ConferenceListViewController
@synthesize conferenceListTableView;
#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Select Conference";
    conferenceListingArray=[[NSMutableArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getConferenceListing) withObject:nil afterDelay:.1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end


#pragma mark - Webservice
-(void)getConferenceListing
{
    [[ConferenceService sharedManager] getConferenceListing:^(id dataArray) {
        [myDelegate stopIndicator];
        conferenceListingArray=[dataArray mutableCopy];
        [conferenceListTableView reloadData];
    }
                                                   failure:^(NSError *error)
     {
         
     }] ;
    
}
#pragma mark - end

#pragma mark - Table view delegate and datasource
#pragma mark - Table view delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return conferenceListingArray.count;
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
//                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:16.0]}
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
     NSString *simpleTableIdentifier = @"conferenceListCell";
        ConferenceListCell *conferenceCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (conferenceCell == nil)
        {
            conferenceCell = [[ConferenceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    ConferenceListDataModel *data=[conferenceListingArray objectAtIndex:indexPath.row];
    [conferenceCell displayConferenceListData:data indexPath:(int)indexPath.row rectSize:conferenceListTableView.frame.size];

    return conferenceCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    [UserDefaultManager setValue:[[conferenceListingArray objectAtIndex:indexPath.row] conferenceId] key:@"conferenceId"];
    [myDelegate.window setRootViewController:homeView];
    [myDelegate.window makeKeyAndVisible];
}

#pragma mark - end
@end
