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
    self.navigationItem.title=@"MATCHES";
    
//    [myDelegate showIndicator];
//    [self performSelector:@selector(getMatchesDetails) withObject:nil afterDelay:.1];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - end

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
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

@end
