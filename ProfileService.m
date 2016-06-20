//
//  ProfileService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 17/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ProfileService.h"


#define kUrlGetInterestList             @"getinterestlist"
#define kUrlGetInterestInList           @"getinterestedinlist"
#define kUrlGetProffessionList          @"getprofessions"


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
    //[UserDefaultManager getValue:@"conferenceId"]
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"request interest arear %@",requestDict);
    [[Webservice sharedManager] post:kUrlGetInterestList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"interest area response %@",responseObject);
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
#pragma mark - Interested In list
-(void)getInterestedInList:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    //[UserDefaultManager getValue:@"conferenceId"]
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"request Interested in %@",requestDict);
    [[Webservice sharedManager] post:kUrlGetInterestInList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"Interested in response %@",responseObject);
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
//kUrlGetProffessionList
#pragma mark - Profession list
-(void)getProfessionList:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    //[UserDefaultManager getValue:@"conferenceId"]
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"request Profession  %@",requestDict);
    [[Webservice sharedManager] post:kUrlGetProffessionList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"Profession response %@",responseObject);
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

@end
