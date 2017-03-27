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
    [[Webservice sharedManager] post:kUrlGetInterestList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
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
    [[Webservice sharedManager] post:kUrlGetInterestInList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
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
    [[Webservice sharedManager] post:kUrlGetProffessionList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
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
- (void)editUserProfile:(NSString *)userName userSurname:(NSString *)userSurname userEmail:(NSString *)userEmail mobileNumber:(NSString *)mobileNumber companyName:(NSString *)companyName companyAddress:(NSString *)companyAddress designation:(NSString *)designation aboutCompany:(NSString *)aboutCompany linkedIn:(NSString *)linkedIn interests:(NSString *)interests interestedIn:(NSString *)interestedIn profession:(NSString *)profession otherInterests:(NSString *)otherInterests otherInterestedIn:(NSString *)otherInterestedIn otherProfession:(NSString *)otherProfession image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"userName":userName,@"userSurname":userSurname,@"userEmail":userEmail,@"mobileNumber":mobileNumber,@"companyName":companyName,@"companyAddress":companyAddress,@"designation":designation,@"aboutCompany":aboutCompany,@"linkedIn":linkedIn,@"interests":interests,@"interestInName":interestedIn,@"professionName":profession,@"otherInterests":otherInterests,@"otherInterestedIn":otherInterestedIn,@"otherProfession":otherProfession};
    [[Webservice sharedManager] postImage:kUrlEditUserProfile parameters:requestDict image:image success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
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
    [[Webservice sharedManager] post:kUrlGetUserProfile parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
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
            profileData.userSurname =[profileDataDict objectForKey:@"userSurname"];
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
    [[Webservice sharedManager] post:kUrlGetOtherUserProfile parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
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
            profileData.userSurname =[profileDataDict objectForKey:@"userSurname"];
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
