//
//  ConferenceService.h
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConferenceService : NSObject
+ (id)sharedManager;

//Conference Listing
-(void)getConferenceListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//Conference detail
-(void)getConferenceDetail:(NSString *)conferenceId success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Settings
-(void)changeSettings:(NSString *)switchIdentifire switchStatus:(NSString *)switchStatus success:(void (^)(id))success failure:(void (^)(NSError *))failure;

-(void)getUserSetting:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Calendar detail
-(void)getCalendarDetails:(NSString *)conferenceId success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Contact detail
-(void)getContactDetails:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Schedule meeting
-(void)scheduleMeeting:(NSString *)contactUserId venue:(NSString *)venue meetingAgenda:(NSString *)meetingAgenda date:(NSString *)date timeFrom:(NSString *)timeFrom timeTo:(NSString *)timeTo success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Pending appointments
-(void)pendingAppointment:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Requested appointments
-(void)requestedAppointment:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Accpet cancel appointment
-(void)acceptCancelMeeting:(NSString *)appointmentId meetingUserId:(NSString *)meetingUserId flag:(NSString *)flag date:(NSString *)date type:(NSString *)type success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

@end
