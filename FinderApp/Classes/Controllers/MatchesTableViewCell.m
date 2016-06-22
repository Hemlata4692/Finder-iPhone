//
//  MatchesTableViewCell.m
//  Finder_iPhoneApp
//
//  Created by Monika on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MatchesTableViewCell.h"

@implementation MatchesTableViewCell

//Matches cell
@synthesize name;
@synthesize companyName;
@synthesize approveButton;
@synthesize cancelButton;
@synthesize reviewedStatusLbl;
@synthesize containerView;
@synthesize sendRequestButton;
@synthesize allMatchesApproveButton;
@synthesize allMatchesRejectButton;

//Contact cell
@synthesize contactsContainerView;
@synthesize contactIcon;
@synthesize contactName;
@synthesize contactCompanyName;
@synthesize messageButton;
@synthesize scheduleMeetingBtn;

#pragma mark - Load nib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - end

-(void)displayData :(MatchesDataModel *)allMatchesDetails indexPath:(int)indexPath {
    name.text=allMatchesDetails.userName;
    companyName.text=allMatchesDetails.userCompanyName;
    if ([allMatchesDetails.isAccepted isEqualToString:@"F"] && [allMatchesDetails.isRequestSent isEqualToString:@"F"] && [allMatchesDetails.isArrived isEqualToString:@"F"]) {
        approveButton.hidden=YES;
        cancelButton.hidden=YES;
        allMatchesRejectButton.hidden=YES;
        allMatchesApproveButton.hidden=YES;
        sendRequestButton.hidden=NO;
    }
    else if ([allMatchesDetails.isAccepted isEqualToString:@"F"] && [allMatchesDetails.isRequestSent isEqualToString:@"T"] && [allMatchesDetails.isArrived isEqualToString:@"F"]) {
        approveButton.hidden=YES;
        cancelButton.hidden=YES;
        sendRequestButton.hidden=YES;
        allMatchesRejectButton.hidden=NO;
        allMatchesApproveButton.hidden=NO;
        [allMatchesApproveButton setImage:[UIImage imageNamed:@"pending.png"] forState:UIControlStateNormal
         ];
        [allMatchesRejectButton setImage:[UIImage imageNamed:@"reject.png"] forState:UIControlStateNormal
         ];
    
    }
    else if ([allMatchesDetails.isAccepted isEqualToString:@"F"] && [allMatchesDetails.isRequestSent isEqualToString:@"F"] && [allMatchesDetails.isArrived isEqualToString:@"T"]) {
        approveButton.hidden=YES;
        cancelButton.hidden=YES;
        sendRequestButton.hidden=YES;
        allMatchesRejectButton.hidden=NO;
        allMatchesApproveButton.hidden=NO;
        [allMatchesApproveButton setImage:[UIImage imageNamed:@"approve.png"] forState:UIControlStateNormal
         ];
        [allMatchesRejectButton setImage:[UIImage imageNamed:@"reject.png"] forState:UIControlStateNormal
         ];

    }
    else if ([allMatchesDetails.isAccepted isEqualToString:@"T"] && [allMatchesDetails.isRequestSent isEqualToString:@"F"] && [allMatchesDetails.isArrived isEqualToString:@"F"]) {
        approveButton.hidden=YES;
        cancelButton.hidden=YES;
        sendRequestButton.hidden=YES;
        allMatchesRejectButton.hidden=NO;
        allMatchesApproveButton.hidden=NO;
        [allMatchesApproveButton setImage:[UIImage imageNamed:@"scedule_meeting.png"] forState:UIControlStateNormal
         ];
        [allMatchesRejectButton setImage:[UIImage imageNamed:@"message_icon.png"] forState:UIControlStateNormal
         ];

    }
}

-(void)displayNewMatchRequests :(MatchesDataModel *)newMatchesDetails indexPath:(int)indexPath {
    name.text=newMatchesDetails.userName;
    companyName.text=newMatchesDetails.userCompanyName;
    approveButton.hidden=NO;
    cancelButton.hidden=NO;
    sendRequestButton.hidden=YES;
    allMatchesRejectButton.hidden=YES;
    allMatchesApproveButton.hidden=YES;
    [approveButton setImage:[UIImage imageNamed:@"approve.png"] forState:UIControlStateNormal
     ];
    [cancelButton setImage:[UIImage imageNamed:@"reject.png"] forState:UIControlStateNormal
     ];

}

-(void)displayContacts :(MatchesDataModel *)contactData indexPath:(int)indexPath {
    contactName.text=contactData.userName;
    contactCompanyName.text=contactData.userCompanyName;
    __weak UIImageView *weakRef = contactIcon;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:contactData.userImage]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [contactIcon setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}
@end
