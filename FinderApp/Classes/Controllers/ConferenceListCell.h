//
//  ConferenceListCell.h
//  Finder_iPhoneApp
//
//  Created by Hema on 23/05/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConferenceListDataModel.h"

@interface ConferenceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *conferenceStartDate;
@property (weak, nonatomic) IBOutlet UILabel *conferenceStartMonth;
@property (weak, nonatomic) IBOutlet UILabel *conferenceEndDate;
@property (weak, nonatomic) IBOutlet UILabel *conferenceEndMonth;
@property (weak, nonatomic) IBOutlet UILabel *conferenceNameLabel;
-(void)displayConferenceListData :(ConferenceListDataModel *)conferenceList :(int)indexPath;
@end
