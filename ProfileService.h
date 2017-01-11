//
//  ProfileService.h
//  Finder_iPhoneApp
//
//  Created by Hema on 17/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileService : NSObject
+ (id)sharedManager;

//Interest list
- (void)getInterestList:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//Interested In list
- (void)getInterestedInList:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//Profession list
- (void)getProfessionList:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//Edit profile
- (void)editUserProfile:(NSString *)userName userSurname:(NSString *)userSurname userEmail:(NSString *)userEmail mobileNumber:(NSString *)mobileNumber companyName:(NSString *)companyName companyAddress:(NSString *)companyAddress designation:(NSString *)designation aboutCompany:(NSString *)aboutCompany linkedIn:(NSString *)linkedIn interests:(NSString *)interests interestedIn:(NSString *)interestedIn profession:(NSString *)profession otherInterests:(NSString *)otherInterests otherInterestedIn:(NSString *)otherInterestedIn otherProfession:(NSString *)otherProfession image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//User profile
- (void)getUserProfile:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//Other user profile
- (void)getOtherUserProfile:(NSString *)otherUserId success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end
