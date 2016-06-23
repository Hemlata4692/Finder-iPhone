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
#import "EventDataModel.h"

#define kUrlConferenceList              @"getconferencelisting"
#define kUrlConferenceDetail            @"getconferencedetails"
#define kUrlChangeSettings              @"settings"
#define kUrlUserSettings                @"getusersetting"
#define kUrlCalendarDetails             @"getcalenderdetails"

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
                 [self logoutUser];
             }];
             [alert showWarning:nil title:@"Alert" subTitle:responseObject[@"message"] closeButtonTitle:nil duration:0.0f];
         }
     } failure:^(NSError *error) {
         [myDelegate stopIndicator];
         failure(error);
     }];
    
}
- (void)logoutUser
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
    
    myDelegate.window.rootViewController = myDelegate.navigationController;
    [UserDefaultManager removeValue:@"userId"];
    [UserDefaultManager removeValue:@"username"];
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
         if([[Webservice sharedManager] isStatusOK:responseObject]) {
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
                         eventDetails.eventName =[eventArrayDict objectForKey:@"event"];
                         eventDetails.eventTime =[eventArrayDict objectForKey:@"eventTime"];
                         [calendarDetails.eventArray addObject:eventDetails];
                     }
                     [dataArray addObject:calendarDetails];
                 }
                 success(dataArray);
             }
             else {
                 success(responseObject);
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
@end
