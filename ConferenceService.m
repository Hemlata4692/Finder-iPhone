//
//  ConferenceService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ConferenceService.h"
#import "ConferenceDataModel.h"

#define kUrlConferenceDetail            @"getconferencedetails"

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

#pragma mark- Conference detail
-(void)getConferenceDetail:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":@"1"};
    NSLog(@"request home %@",requestDict);
    [[Webservice sharedManager] post:kUrlConferenceDetail parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"home response %@",responseObject);
         if([[Webservice sharedManager] isStatusOK:responseObject])
         {
             NSMutableArray *conferenceArray = [NSMutableArray new];
             ConferenceDataModel *conferenceDetail = [[ConferenceDataModel alloc]init];
             NSDictionary * conferenceDict =[responseObject objectForKey:@"getConfrenceDetails"];
             conferenceDetail.conferenceName =[conferenceDict objectForKey:@"confrenceName"];
             conferenceDetail.conferenceDate =[conferenceDict objectForKey:@"confrenceDate"];
             conferenceDetail.conferenceDescription =[conferenceDict objectForKey:@"description"];
             conferenceDetail.conferenceOrganiserName =[conferenceDict objectForKey:@"organiserName"];
             conferenceDetail.conferenceImage=[conferenceDict objectForKey:@"imageUrl"];
             conferenceDetail.conferenceVenue=[conferenceDict objectForKey:@"venue"];
            [conferenceArray addObject:conferenceDetail];
             success(conferenceArray);
         }
         else
         {
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

@end
