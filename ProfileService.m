//
//  ProfileService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 17/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ProfileService.h"
#import "ProfileDataModel.h"

#define kUrlGetInterestList             @"getinteresteslists"
#define kUrlGetInterestInList           @"getinterestedinlist"
#define kUrlGetProffessionList          @"getprofessions"
#define kUrlEditUserProfile             @"edituserprofile"
#define kUrlGetUserProfile              @"getuserprofile"
#define kUrlGetOtherUserProfile         @"getotheruserprofile"

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
- (id)init {
    if (self = [super init])
    {
    }
    return self;
}
#pragma mark - end

#pragma mark - Interest list
- (void)getInterestList:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
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
- (void)getInterestedInList:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
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
- (void)getProfessionList:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
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

#pragma mark - Edit profile
- (void)editUserProfile:(NSString *)userName mobileNumber:(NSString *)mobileNumber companyName:(NSString *)companyName companyAddress:(NSString *)companyAddress designation:(NSString *)designation aboutCompany:(NSString *)aboutCompany linkedIn:(NSString *)linkedIn interests:(NSString *)interests interestedIn:(NSString *)interestedIn profession:(NSString *)profession image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"userName":userName,@"mobileNumber":mobileNumber,@"companyName":companyName,@"companyAddress":companyAddress,@"designation":designation,@"aboutCompany":aboutCompany,@"linkedIn":linkedIn,@"interests":interests,@"interestInName":interestedIn,@"professionName":profession};
    NSLog(@"request edit user profile  %@",requestDict);
    [[Webservice sharedManager] postImage:kUrlEditUserProfile parameters:requestDict image:image success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"edit user profile response %@",responseObject);
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
#pragma mark - Get user profile
- (void)getUserProfile:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"request user profile  %@",requestDict);
    [[Webservice sharedManager] post:kUrlGetUserProfile parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"user profile response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            NSMutableArray *profileDataArray = [NSMutableArray new];
            ProfileDataModel *profileData = [[ProfileDataModel alloc]init];
            NSDictionary * profileDataDict =[responseObject objectForKey:@"userProfile"];
            profileData.userImage =[profileDataDict objectForKey:@"userProfilePic"];
            profileData.userName =[profileDataDict objectForKey:@"userName"];
            profileData.userEmail =[profileDataDict objectForKey:@"email"];
            profileData.userMobileNumber =[profileDataDict objectForKey:@"mobileNumber"];
            profileData.userCompanyName =[profileDataDict objectForKey:@"companyName"];
            profileData.userComapnyAddress =[profileDataDict objectForKey:@"companyAddress"];
            profileData.aboutUserCompany =[profileDataDict objectForKey:@"aboutCompany"];
            profileData.userInterests =[profileDataDict objectForKey:@"interests"];
            profileData.userDesignation =[profileDataDict objectForKey:@"designation"];
            profileData.userProfession =[profileDataDict objectForKey:@"profession"];
            profileData.userInterestedIn =[profileDataDict objectForKey:@"interestIn"];
            profileData.userLinkedInLink =[profileDataDict objectForKey:@"linkedIn"];
            profileData.conferenceName =[profileDataDict objectForKey:@"conferenceName"];
            [profileDataArray addObject:profileData];
            success(profileDataArray);
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

#pragma mark - Other user profile
- (void)getOtherUserProfile:(NSString *)otherUserId success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"otheruserId":otherUserId};
    NSLog(@"request other user profile  %@",requestDict);
    [[Webservice sharedManager] post:kUrlGetOtherUserProfile parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"other user profile response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            NSMutableArray *profileDataArray = [NSMutableArray new];
            ProfileDataModel *profileData = [[ProfileDataModel alloc]init];
            NSDictionary * profileDataDict =[responseObject objectForKey:@"userProfile"];
            profileData.userImage =[profileDataDict objectForKey:@"userProfilePic"];
            profileData.userName =[profileDataDict objectForKey:@"userName"];
            profileData.userEmail =[profileDataDict objectForKey:@"email"];
            profileData.userMobileNumber =[profileDataDict objectForKey:@"mobileNumber"];
            profileData.userCompanyName =[profileDataDict objectForKey:@"companyName"];
            profileData.userComapnyAddress =[profileDataDict objectForKey:@"companyAddress"];
            profileData.aboutUserCompany =[profileDataDict objectForKey:@"aboutCompany"];
            profileData.userInterests =[profileDataDict objectForKey:@"interests"];
            profileData.userDesignation =[profileDataDict objectForKey:@"designation"];
            profileData.userProfession =[profileDataDict objectForKey:@"profession"];
            profileData.userInterestedIn =[profileDataDict objectForKey:@"interestIn"];
            profileData.userLinkedInLink =[profileDataDict objectForKey:@"linkedIn"];
            profileData.conferenceName =[profileDataDict objectForKey:@"conferenceName"];
            profileData.vCard=[profileDataDict objectForKey:@"vCardLink"];
            [profileDataArray addObject:profileData];
            success(profileDataArray);
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
