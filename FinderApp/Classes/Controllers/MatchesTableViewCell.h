//
//  MatchesTableViewCell.h
//  Finder_iPhoneApp
//
//  Created by Monika on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *reviewedStatusLbl;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
