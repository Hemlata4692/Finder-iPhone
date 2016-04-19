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
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"matchesCell";
    MatchesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[MatchesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.containerView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    cell.containerView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    cell.containerView.layer.shadowOpacity = 1.0f;
    cell.containerView.layer.shadowRadius = 1.0f;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark - end
#pragma mark - Webservice
-(void)getMatchesDetails
{
    [[ConferenceService sharedManager] getMatchesDetails:^(id matchesArray)
     {
         [myDelegate stopIndicator];
     }
                                                 failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end
#pragma mark - Segment control

- (IBAction)matchesSegmentAction:(UISegmentedControl *)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        _matchesTableView.hidden=NO;
    }
    else if(selectedSegment == 1)
    {
        _matchesTableView.hidden=YES;
    }
    else
    {
        
    }
}
#pragma mark - end

@end
