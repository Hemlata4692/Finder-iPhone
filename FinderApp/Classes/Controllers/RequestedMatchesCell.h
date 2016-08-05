//
//  RequestedMatchesCell.h
//  Finder_iPhoneApp
//
//  Created by Ranosys on 04/08/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchesDataModel.h"

@interface RequestedMatchesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (void)displayData :(MatchesDataModel *)allMatchesDetails;
@end
