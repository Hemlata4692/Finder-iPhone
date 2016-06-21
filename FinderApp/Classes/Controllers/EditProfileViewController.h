//
//  EditProfileViewController.h
//  Finder_iPhoneApp
//
//  Created by Hema on 10/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileViewController.h"

@interface EditProfileViewController : GlobalBackViewController
@property(nonatomic,strong) NSMutableArray* profileArray;
@property(strong, nonatomic) MyProfileViewController *userProfileObj;
@end
