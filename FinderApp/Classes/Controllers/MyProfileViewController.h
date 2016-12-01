//
//  MyProfileViewController.h
//  Finder_iPhoneApp
//
//  Created by Hema on 08/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDataModel.h"

@interface MyProfileViewController : GlobalBackViewController
@property (nonatomic,strong) NSString *viewName;
@property (nonatomic,strong) NSString *viewType;
@property (nonatomic,strong) NSString *otherUserID;
@property(strong, nonatomic) ProfileDataModel *myProfileData;
@end
