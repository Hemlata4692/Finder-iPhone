//
//  EventDataModel.h
//  Finder_iPhoneApp
//
//  Created by Hema on 31/05/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDataModel : NSObject
@property(nonatomic,retain)NSString * eventName;
@property(nonatomic,retain)NSString * eventTime;
@property(nonatomic,retain)NSString * eventDescription;
@property(nonatomic,retain)NSString * eventVenue;
@property(nonatomic,retain)NSString * userImage;
@property(nonatomic,retain)NSString * userId;
@end
