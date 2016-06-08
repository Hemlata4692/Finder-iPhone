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
#import "MatchesViewController.h"

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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end


#pragma mark - Webservice
-(void)getConferenceListing{
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return conferenceListingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MatchesViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    [UserDefaultManager setValue:[[conferenceListingArray objectAtIndex:indexPath.row] conferenceId] key:@"conferenceId"];
    [myDelegate.window setRootViewController:homeView];
    [myDelegate.window makeKeyAndVisible];
}

#pragma mark - end
@end
