//
//  PendingAppointmentDataModel.h
//  Finder_iPhoneApp
//
//  Created by Hema on 24/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingAppointmentDataModel : NSObject
@property(nonatomic,retain)NSString * appointmentDate;
@property(nonatomic,retain)NSString * appointmentId;
@property(nonatomic,retain)NSString * meetingPerson;
@property(nonatomic,retain)NSString * meetingPersonImage;
@property(nonatomic,retain)NSString * meetingUserId;
@property(nonatomic,retain)NSString * meetingTime;
@property(nonatomic,retain)NSString * meetingDescription;
@property(nonatomic,retain)NSString * meetingVenue;
@end
