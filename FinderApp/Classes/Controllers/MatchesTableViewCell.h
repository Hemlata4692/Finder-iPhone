//
//  MatchesTableViewCell.h
//  Finder_iPhoneApp
//
//  Created by Monika on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchesTableViewCell : UITableViewCell

//Matches cell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *reviewedStatusLbl;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *approvedContactImageView;

//Contact cell
@property (weak, nonatomic) IBOutlet UIView *contactsContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *contactIcon;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactCompanyName;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end
