//
//  RequestedMatchesViewController.m
//  Finder_iPhoneApp
//
//  Created by Ranosys on 04/08/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "RequestedMatchesViewController.h"
#import "RequestedMatchesCell.h"
#import "MatchesService.h"
#import "OtherUserProfileViewController.h"
@interface RequestedMatchesViewController () {

    NSMutableArray *requestedMatchesDataArray;
    NSString *otherUserId;
}

@property (weak, nonatomic) IBOutlet UITableView *requestedMatchesTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@end

@implementation RequestedMatchesViewController
@synthesize noRecordLabel;
@synthesize requestedMatchesTableView;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationItem.title = @"Requested Matches";
    myDelegate.myView = @"RequestedMatchesViewController";
    requestedMatchesDataArray = [[NSMutableArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getMatchesDetails) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    myDelegate.myView=@"other";
}
#pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (requestedMatchesDataArray.count != 0) {
        
        float height = [self getDynamicLabelHeight:[[requestedMatchesDataArray objectAtIndex:indexPath.row] userName] font:[UIFont fontWithName:@"Roboto-Bold" size:16] widthValue:[[UIScreen mainScreen] bounds].size.width - 8 - 115]; //Here width = [[UIScreen mainScreen] bounds].size.width - 8(left padding) - 115(right padding)
        height += [self getDynamicLabelHeight:[[requestedMatchesDataArray objectAtIndex:indexPath.row] userCompanyName] font:[UIFont fontWithName:@"Roboto-Regular" size:15] widthValue:[[UIScreen mainScreen] bounds].size.width - 8 - 115] + 20 + 20;//Here width = dynamicSize([[UIScreen mainScreen] bounds].size.width + 8(left space) + 115(right space)) + 13(top space) + 13(bottom space)

        return height;
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return requestedMatchesDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSString *simpleTableIdentifier = @"requestedMatchesCell";
        RequestedMatchesCell *newMatchesCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (newMatchesCell == nil)  {
            newMatchesCell = [[RequestedMatchesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    
        [newMatchesCell displayData:[requestedMatchesDataArray objectAtIndex:indexPath.row]];
        [newMatchesCell.containerView addShadow:newMatchesCell.containerView color:[UIColor lightGrayColor]];

        newMatchesCell.cancelButton.tag=(int)indexPath.row;

        [newMatchesCell.cancelButton addTarget:self action:@selector(cancelRequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
        return newMatchesCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserProfileViewController *userProfile =[storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
        userProfile.viewType=@"Matches";
        userProfile.otherUserId=[[requestedMatchesDataArray objectAtIndex:indexPath.row] otherUserId];
        userProfile.isRequestSent=[[requestedMatchesDataArray objectAtIndex:indexPath.row] isRequestSent];
        [self.navigationController pushViewController:userProfile animated:YES];
}
#pragma mark - end

#pragma mark - Webservice
//get matches details
- (void)getMatchesDetails
{
    [requestedMatchesDataArray removeAllObjects];
    [[MatchesService sharedManager] getMatchesList:^(id dataArray) {
        
        [myDelegate stopIndicator];
        if ([dataArray count] != 0) {
            noRecordLabel.hidden=YES;
            for (int i =0; i<[dataArray count]; i++)
            {
                if ([[[dataArray objectAtIndex:i] isRequestSent] isEqualToString:@"T"])
                {
                    [requestedMatchesDataArray addObject:[dataArray objectAtIndex:i]];
                }
            }
            
            if (requestedMatchesDataArray.count!=0) {
                requestedMatchesTableView.hidden = NO;
                 [requestedMatchesTableView reloadData];
            }
            else {
                noRecordLabel.hidden = NO;
                noRecordLabel.text = @"No request(s) found.";
                requestedMatchesTableView.hidden=YES;
            }
        }
        else {
        
            noRecordLabel.hidden = NO;
            noRecordLabel.text = @"No request(s) found.";
            requestedMatchesTableView.hidden=YES;
        }
    }
    failure:^(NSError *error)
     {
         noRecordLabel.hidden = NO;
         noRecordLabel.text = @"No request(s) found.";
         requestedMatchesTableView.hidden=YES;
     }] ;
}

//send/cancel match request
- (void)sendCancelMatchRequest {
    [[MatchesService sharedManager] sendCancelMatchRequest:otherUserId sendRequest:@"F" success:^(id responseObject) {
       
        [self getMatchesDetails];
    }
                                                   failure:^(NSError *error)
     {
         
     }] ;
}

- (IBAction)cancelRequestButtonAction:(UIButton *)sender {
    
    otherUserId=[[requestedMatchesDataArray objectAtIndex:[sender tag]]otherUserId];
   
    [myDelegate showIndicator];
    [self performSelector:@selector(sendCancelMatchRequest) withObject:nil afterDelay:.1];
}

#pragma mark - Get dynamic label height according to given string
- (float)getDynamicLabelHeight:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue{
    
    CGSize size = CGSizeMake(widthValue,500);
    CGRect textRect=[text
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:font}
                     context:nil];
    return textRect.size.height;
}
#pragma mark - end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
