//
//  ConferenceService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ConferenceService.h"
#import "ConferenceDataModel.h"
#import "ConferenceListDataModel.h"
#import "CalendarDataModel.h"
#import "ContactDataModel.h"
#import "EventDataModel.h"
#import "PendingAppointmentDataModel.h"

#define kUrlConferenceList              @"getconferencelisting"
#define kUrlConferenceDetail            @"getconferencedetails"
#define kUrlChangeSettings              @"settings"
#define kUrlUserSettings                @"getusersetting"
#define kUrlCalendarDetails             @"getcalenderdetails"
#define kUrlContactDetails              @"getcontactlist"
#define kUrlScheduleMeeting             @"schedulemeetingrequest"
#define kUrlPendingAppointment          @"pendingappointments"
#define kUrlRequestedAppointment        @"requestedappointments"
#define kUrlAcceptCancelAppointment     @"accpetcancelscheduledmeeting"
#define kUrlgetproximityalerts          @"getproximityalerts"

@implementation ConferenceService
#pragma mark - Singleton instance
+ (id)sharedManager
{
    static ConferenceService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}
#pragma mark - end

#pragma mark- Conference listing
-(void)getConferenceListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"]};
    NSLog(@"request conference list %@",requestDict);
    [[Webservice sharedManager] post:kUrlConferenceList parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"conference list response %@",responseObject);
         NSNumber *number = responseObject[@"isSuccess"];
         if (number.integerValue==1) {
             [myDelegate stopIndicator];
             id array =[responseObject objectForKey:@"conferenceListing"];
             if (([array isKindOfClass:[NSArray class]])) {
                 NSArray * conferenceArray = [responseObject objectForKey:@"conferenceListing"];
                 NSMutableArray *dataArray = [NSMutableArray new];
                 for (int i =0; i<conferenceArray.count; i++)
                 {
                     ConferenceListDataModel *conferenceList = [[ConferenceListDataModel alloc]init];
                     NSDictionary * conferenceDict =[conferenceArray objectAtIndex:i];
                     conferenceList.conferenceName =[conferenceDict objectForKey:@"conferenceName"];
                     conferenceList.conferenceDate =[conferenceDict objectForKey:@"conferenceDate"];
                     conferenceList.conferenceId =[conferenceDict objectForKey:@"conferenceId"];
                     conferenceList.isExpired =[conferenceDict objectForKey:@"isExpired"];
                     [dataArray addObject:conferenceList];
                 }
                 success(dataArray);
             }
         }
         else if(number.integerValue==0) {
             [myDelegate stopIndicator];
             success(nil);
         }
         else {
             SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
             [alert addButton:@"Ok" actionBlock:^(void) {
                 [[Webservice sharedManager] logoutUser];
             }];
             [alert showWarning:nil title:@"Alert" subTitle:responseObject[@"message"] closeButtonTitle:nil duration:0.0f];
         }
     } failure:^(NSError *error) {
         [myDelegate stopIndicator];
         failure(error);
     }];
    
}

#pragma mark- end

#pragma mark- Conference detail
-(void)getConferenceDetail:(NSString *)conferenceId success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":conferenceId};
    NSLog(@"request home %@",requestDict);
    [[Webservice sharedManager] post:kUrlConferenceDetail parameters:requestDict success:^(id responseObject) {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"home response %@",responseObject);
         if([[Webservice sharedManager] isStatusOK:responseObject]) {
             NSMutableArray *conferenceArray = [NSMutableArray new];
             ConferenceDataModel *conferenceDetail = [[ConferenceDataModel alloc]init];
             NSDictionary * conferenceDict =[responseObject objectForKey:@"getConfrenceDetails"];
             conferenceDetail.conferenceName =[conferenceDict objectForKey:@"confrenceName"];
             conferenceDetail.conferenceDate =[conferenceDict objectForKey:@"confrenceDate"];
             conferenceDetail.conferenceDescription =[conferenceDict objectForKey:@"description"];
             conferenceDetail.conferenceOrganiserName =[conferenceDict objectForKey:@"organiserName"];
             conferenceDetail.conferenceImage=[conferenceDict objectForKey:@"imageUrl"];
             conferenceDetail.conferenceVenue=[conferenceDict objectForKey:@"venue"];
              conferenceDetail.representativeEmail=[conferenceDict objectForKey:@"organiserEmail"];
             [conferenceArray addObject:conferenceDetail];
             success(conferenceArray);
         }
         else {
             [myDelegate stopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Settings
-(void)changeSettings:(NSString *)switchIdentifire switchStatus:(NSString *)switchStatus success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"switchIdentifire":switchIdentifire,@"switchStatus":switchStatus};
    NSLog(@"settings request %@",requestDict);
    [[Webservice sharedManager] post:kUrlChangeSettings parameters:requestDict success:^(id responseObject) {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"settings response %@",responseObject);
         NSNumber *number = responseObject[@"isSuccess"];
         if (number.integerValue!=0) {
             success(responseObject);
         }
         else {
             [myDelegate stopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error) {
         [myDelegate stopIndicator];
         failure(error);
     }];
    
}
//getUserSetting
-(void)getUserSetting:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"]};
    NSLog(@"user setting request %@",requestDict);
    [[Webservice sharedManager] post:kUrlUserSettings parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"user setting response %@",responseObject);
         if([[Webservice sharedManager] isStatusOK:responseObject]) {
             success(responseObject);
         }
         else {
             [myDelegate stopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error) {
         [myDelegate stopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Calendar Details
-(void)getCalendarDetails:(NSString *)conferenceId success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":conferenceId};
    NSLog(@"request calendar details %@",requestDict);
    [[Webservice sharedManager] post:kUrlCalendarDetails parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"calendar details response %@",responseObject);
         NSNumber *number = responseObject[@"isSuccess"];
         if (number.integerValue==1) {
             id array =[responseObject objectForKey:@"calenderDetails"];
             if (([array isKindOfClass:[NSArray class]])) {
                 NSArray * calendarDataArray = [responseObject objectForKey:@"calenderDetails"];
                 NSMutableArray *dataArray = [NSMutableArray new];
                
                 for (int i =0; i<calendarDataArray.count; i++) {
                     CalendarDataModel *calendarDetails = [[CalendarDataModel alloc]init];
                     calendarDetails.eventArray=[[NSMutableArray alloc]init];
                     NSDictionary * calendarDict =[calendarDataArray objectAtIndex:i];
                     calendarDetails.conferenceDate =[calendarDict objectForKey:@"conferenceDate"];
                     NSMutableArray *tempArray=[calendarDict objectForKey:@"eventArray"];
                     for (int j=0; j<tempArray.count; j++) {
                          NSDictionary * eventArrayDict =[tempArray objectAtIndex:j];
                         EventDataModel *eventDetails = [[EventDataModel alloc]init];
                         eventDetails.eventName =[eventArrayDict objectForKey:@"eventName"];
                         eventDetails.eventTime =[eventArrayDict objectForKey:@"eventTime"];
                         eventDetails.eventDescription =[eventArrayDict objectForKey:@"eventDescription"];
                         eventDetails.userImage =[eventArrayDict objectForKey:@"userImage"];
                         eventDetails.userId =[eventArrayDict objectForKey:@"userId"];
                         eventDetails.eventVenue = [eventArrayDict objectForKey:@"eventVenue"];
                         [calendarDetails.eventArray addObject:eventDetails];
                     }
                     [dataArray addObject:calendarDetails];
                 }
                 success(dataArray);
             }
            
         }
         else if(number.integerValue==0) {
             [myDelegate stopIndicator];
             success(nil);
         }
         else {
             SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
             [alert addButton:@"Ok" actionBlock:^(void) {
                 [[Webservice sharedManager] logoutUser];
             }];
             [alert showWarning:nil title:@"Alert" subTitle:responseObject[@"message"] closeButtonTitle:nil duration:0.0f];
         }

     } failure:^(NSError *error) {
         [myDelegate stopIndicator];
         failure(error);
     }];
    
}
#pragma mark- end

#pragma mark- Contact list
-(void)getContactDetails:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"user contact request %@",requestDict);
    [[Webservice sharedManager] post:kUrlContactDetails parameters:requestDict success:^(id responseObject)
     {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"user contact response %@",responseObject);
         if([[Webservice sharedManager] isStatusOK:responseObject]) {
             id array =[responseObject objectForKey:@"userContactList"];
             if (([array isKindOfClass:[NSArray class]])) {
                 NSArray * contactDataArray = [responseObject objectForKey:@"userContactList"];
                 NSMutableArray *dataArray = [NSMutableArray new];
                 for (int i =0; i<contactDataArray.count; i++) {
                     ContactDataModel *contactDetails = [[ContactDataModel alloc]init];
                     NSDictionary * calendarDict =[contactDataArray objectAtIndex:i];
                     contactDetails.companyName =[calendarDict objectForKey:@"companyName"];
                     contactDetails.contactName =[calendarDict objectForKey:@"contactName"];
                     contactDetails.contactUserId =[calendarDict objectForKey:@"contactUserId"];
                     contactDetails.userImage =[calendarDict objectForKey:@"userImage"];
                    [dataArray addObject:contactDetails];
                 }
                 success(dataArray);
         }
         }
         else {
             [myDelegate stopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error) {
         [myDelegate stopIndicator];
         failure(error);
     }];
}
#pragma mark- end

#pragma mark- Schedule meeting
-(void)scheduleMeeting:(NSString *)contactUserId venue:(NSString *)venue meetingAgenda:(NSString *)meetingAgenda date:(NSString *)date timeFrom:(NSString *)timeFrom timeTo:(NSString *)timeTo success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"contactUserId":contactUserId,@"venue":venue,@"meetingAgenda":meetingAgenda,@"date":date,@"timeFrom":timeFrom,@"timeTo":timeTo};
    NSLog(@"schedule meeting request %@",requestDict);
    [[Webservice sharedManager] post:kUrlScheduleMeeting parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"schedule meeting response %@",responseObject);
         if([[Webservice sharedManager] isStatusOK:responseObject]) {
                 success(responseObject);
             }
         else {
             [myDelegate stopIndicator];
             failure(nil);
         }
     } failure:^(NSError *error) {
         [myDelegate stopIndicator];
         failure(error);
     }];

}
#pragma mark- end
#pragma mark - Pending appointment
-(void)pendingAppointment:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"request pending appointment  %@",requestDict);
    [[Webservice sharedManager] post:kUrlPendingAppointment parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"pending appointment response %@",responseObject);
        NSNumber *number = responseObject[@"isSuccess"];
        if (number.integerValue==1) {
            id array =[responseObject objectForKey:@"pendingAppointments"];
            if (([array isKindOfClass:[NSArray class]])) {
                NSArray * pendingAppointmentArray = [responseObject objectForKey:@"pendingAppointments"];
                NSMutableArray *dataArray = [NSMutableArray new];
                for (int i =0; i<pendingAppointmentArray.count; i++) {
                    PendingAppointmentDataModel *appointmentDetails = [[PendingAppointmentDataModel alloc]init];
                    NSDictionary * appointmentDict =[pendingAppointmentArray objectAtIndex:i];
                    appointmentDetails.appointmentDate =[appointmentDict objectForKey:@"appointmentDate"];
                    appointmentDetails.appointmentId =[appointmentDict objectForKey:@"appointmentId"];
                    appointmentDetails.meetingPerson =[appointmentDict objectForKey:@"meetingPerson"];
                    appointmentDetails.meetingPersonImage =[appointmentDict objectForKey:@"meetingPersonImage"];
                    appointmentDetails.meetingTime =[appointmentDict objectForKey:@"meetingTime"];
                    appointmentDetails.meetingUserId =[appointmentDict objectForKey:@"meetingUserId"];
                    appointmentDetails.meetingDescription=[appointmentDict objectForKey:@"meetingDescription"];
                    appointmentDetails.meetingVenue=[appointmentDict objectForKey:@"meetingVenue"];
                    [dataArray addObject:appointmentDetails];
                }
                success(dataArray);
            }
        }
        else if(number.integerValue==0) {
            [myDelegate stopIndicator];
            success(nil);
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"Ok" actionBlock:^(void) {
                [[Webservice sharedManager] logoutUser];
            }];
            [alert showWarning:nil title:@"Alert" subTitle:responseObject[@"message"] closeButtonTitle:nil duration:0.0f];
        }

    } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];
}
#pragma mark - end

#pragma mark - Requested appointment
-(void)requestedAppointment:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"request request appointment  %@",requestDict);
    [[Webservice sharedManager] post:kUrlRequestedAppointment parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"request appointment response %@",responseObject);
        NSNumber *number = responseObject[@"isSuccess"];
        if (number.integerValue==1) {
            id array =[responseObject objectForKey:@"pendingAppointments"];
            if (([array isKindOfClass:[NSArray class]])) {
                NSArray * pendingAppointmentArray = [responseObject objectForKey:@"pendingAppointments"];
                NSMutableArray *dataArray = [NSMutableArray new];
                for (int i =0; i<pendingAppointmentArray.count; i++) {
                    PendingAppointmentDataModel *appointmentDetails = [[PendingAppointmentDataModel alloc]init];
                    NSDictionary * appointmentDict =[pendingAppointmentArray objectAtIndex:i];
                    appointmentDetails.appointmentDate =[appointmentDict objectForKey:@"appointmentDate"];
                    appointmentDetails.appointmentId =[appointmentDict objectForKey:@"appointmentId"];
                    appointmentDetails.meetingPerson =[appointmentDict objectForKey:@"meetingPerson"];
                    appointmentDetails.meetingPersonImage =[appointmentDict objectForKey:@"meetingPersonImage"];
                    appointmentDetails.meetingTime =[appointmentDict objectForKey:@"meetingTime"];
                    appointmentDetails.meetingUserId =[appointmentDict objectForKey:@"meetingUserId"];
                    appointmentDetails.meetingDescription=[appointmentDict objectForKey:@"meetingDescription"];
                    [dataArray addObject:appointmentDetails];
                }
                success(dataArray);
            }
        }
        else if(number.integerValue==0) {
            [myDelegate stopIndicator];
            success(nil);
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"Ok" actionBlock:^(void) {
                [[Webservice sharedManager] logoutUser];
            }];
            [alert showWarning:nil title:@"Alert" subTitle:responseObject[@"message"] closeButtonTitle:nil duration:0.0f];
        }
    } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];
}
#pragma mark - end

#pragma mark - Accept cancel meeting
-(void)acceptCancelMeeting:(NSString *)appointmentId meetingUserId:(NSString *)meetingUserId flag:(NSString *)flag type:(NSString *)type success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"appointmentId":appointmentId,@"meetingUserId":meetingUserId,@"flag":flag,@"type":type};
    NSLog(@"accept decline appointment %@",requestDict);
    [[Webservice sharedManager] post:kUrlAcceptCancelAppointment parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"accept decline appointment response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        }
        else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];

}
#pragma mark - end
#pragma mark - Proximity alerts
-(void)getProximityAlerts:(NSString *)proximityRadius success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"proximityRadius":proximityRadius};
    NSLog(@"proximity radius request %@",requestDict);
    [[Webservice sharedManager] post:kUrlgetproximityalerts parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"proximity radius response %@",responseObject);
         NSNumber *number = responseObject[@"isSuccess"];
         if (number.integerValue==1) {
             id array =[responseObject objectForKey:@"proximityAlertList"];
             if (([array isKindOfClass:[NSArray class]])) {
                 NSArray * proximityRadiusArray = [responseObject objectForKey:@"proximityAlertList"];
                 NSMutableArray *dataArray = [NSMutableArray new];
                 for (int i =0; i<proximityRadiusArray.count; i++) {
                     ContactDataModel *proximityAlerts = [[ContactDataModel alloc]init];
                     NSDictionary * proximityRadiusDict =[proximityRadiusArray objectAtIndex:i];
                     proximityAlerts.companyName =[proximityRadiusDict objectForKey:@"companyName"];
                     proximityAlerts.contactName =[proximityRadiusDict objectForKey:@"userName"];
                     proximityAlerts.contactUserId =[proximityRadiusDict objectForKey:@"otherUserId"];
                     proximityAlerts.userImage =[proximityRadiusDict objectForKey:@"userProfileImage"];
                     [dataArray addObject:proximityAlerts];
                 }
                 success(dataArray);
             }
         }
         else if(number.integerValue==0) {
             [myDelegate stopIndicator];
             success(nil);
         }
         else {
             SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
             [alert addButton:@"Ok" actionBlock:^(void) {
                 [[Webservice sharedManager] logoutUser];
             }];
             [alert showWarning:nil title:@"Alert" subTitle:responseObject[@"message"] closeButtonTitle:nil duration:0.0f];
         }
     } failure:^(NSError *error) {
         [myDelegate stopIndicator];
         failure(error);
     }];
}
#pragma mark - end
@end
