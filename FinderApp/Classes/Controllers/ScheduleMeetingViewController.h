//
//  ScheduleMeetingViewController.h
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"

@interface ScheduleMeetingViewController : UIViewController
@property(nonatomic,strong) NSString *screenName;
@property(nonatomic,strong) NSString *ContactName;
@property(nonatomic,strong) NSMutableArray *contactDetailArray;
@property(nonatomic,strong) NSString *contactUserID;
@property(strong, nonatomic) CalendarViewController *calenderObj;
@end
