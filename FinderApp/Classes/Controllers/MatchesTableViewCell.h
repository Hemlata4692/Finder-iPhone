//
//  MatchesTableViewCell.h
//  Finder_iPhoneApp
//
//  Created by Monika on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchesDataModel.h"
#import "MyButton.h"

@interface MatchesTableViewCell : UITableViewCell

//Matches cell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet MyButton *approveButton;
@property (weak, nonatomic) IBOutlet MyButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *reviewedStatusLbl;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet MyButton *sendRequestButton;
@property (weak, nonatomic) IBOutlet MyButton *allMatchesApproveButton;
@property (weak, nonatomic) IBOutlet MyButton *allMatchesRejectButton;


//Contact cell
@property (weak, nonatomic) IBOutlet UIView *contactsContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *contactIcon;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactCompanyName;
@property (weak, nonatomic) IBOutlet MyButton *messageButton;
@property (weak, nonatomic) IBOutlet MyButton *scheduleMeetingBtn;

-(void)displayData :(MatchesDataModel *)allMatchesDetails indexPath:(int)indexPath;
-(void)displayContacts :(MatchesDataModel *)contactData indexPath:(int)indexPath;
-(void)displayNewMatchRequests :(MatchesDataModel *)newMatchesDetails indexPath:(int)indexPath;
@end
