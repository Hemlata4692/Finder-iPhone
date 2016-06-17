//
//  ProfileService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 17/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ProfileService.h"


#define kUrlGetInterestList             @"getinterestlist"

@implementation ProfileService
#pragma mark - Singleton instance
+ (id)sharedManager
{
    static ProfileService *sharedMyManager = nil;
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

#pragma mark - Interest list
-(void)getInterestList:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"request home %@",requestDict);
    [[Webservice sharedManager] post:kUrlGetInterestList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"home response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
//            NSMutableArray *conferenceArray = [NSMutableArray new];
//            ConferenceDataModel *conferenceDetail = [[ConferenceDataModel alloc]init];
//            NSDictionary * conferenceDict =[responseObject objectForKey:@"getConfrenceDetails"];
//            conferenceDetail.conferenceName =[conferenceDict objectForKey:@"confrenceName"];
//            conferenceDetail.conferenceDate =[conferenceDict objectForKey:@"confrenceDate"];
//            conferenceDetail.conferenceDescription =[conferenceDict objectForKey:@"description"];
//            conferenceDetail.conferenceOrganiserName =[conferenceDict objectForKey:@"organiserName"];
//            conferenceDetail.conferenceImage=[conferenceDict objectForKey:@"imageUrl"];
//            conferenceDetail.conferenceVenue=[conferenceDict objectForKey:@"venue"];
//            [conferenceArray addObject:conferenceDetail];
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
@end
