//
//  UserService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "UserService.h"

#define kUrlLogin                       @"login"
#define kUrlForgotPassword              @"forgotpassword"
#define kUrlChangePassword              @"changepassword"
#define kUrlLocationUpdate              @"locationupdate"
#define kUrlLogout                      @"logout"
#define kUrlRegisterDevice              @"registerdevice"

@implementation UserService

#pragma mark - Singleton instance
+ (id)sharedManager {
    static UserService *sharedMyManager = nil;
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

#pragma mark- Login
//Login
- (void)userLogin:(NSString *)email password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *requestDict = @{@"email":email,@"password":password};
    [[Webservice sharedManager] post:kUrlLogin parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         if([[Webservice sharedManager] isStatusOK:responseObject]) {
             success(responseObject);
         } else
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

#pragma mark- Forgot password
//Forgot Password
- (void)forgotPassword:(NSString *)email success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"email":email};
    [[Webservice sharedManager] post:kUrlForgotPassword parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         if([[Webservice sharedManager] isStatusOK:responseObject])
         {
             success(responseObject);
         } else
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
#pragma mark- Change password
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"oldPassword":oldPassword,@"newPassword":newPassword};
    [[Webservice sharedManager] post:kUrlChangePassword parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         if([[Webservice sharedManager] isStatusOK:responseObject])
         {
             success(responseObject);
         } else
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

#pragma mark- Location update
- (void)locationUpdate:(NSString *)latitude longitude:(NSString *)longitude proximityRange:(NSString *)proximityRange success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"latitude":latitude,@"longitude":longitude ,@"proximityRange":proximityRange};
    [[Webservice sharedManager] post:kUrlLocationUpdate parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"location update %@",requestDict);
       // [self callCrashWebservice:[NSString stringWithFormat:@"Success: %@",requestDict]];
        if ([[responseObject objectForKey:@"isSuccess"] isEqualToString:@"1"]) {
            success(responseObject);
        }
        else {
            [myDelegate stopIndicator];
           // [self callCrashWebservice:[NSString stringWithFormat:@"Faliure: %@",requestDict]];
            failure(nil);
        }
    } failure:^(NSError *error) {
       // [self callCrashWebservice:[NSString stringWithFormat:@"Faliure: %@",requestDict]];
        [myDelegate stopIndicator];
        failure(error);
    }];
}
#pragma mark- end

#pragma mark- Logout
- (void)logoutUser:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"]};
    [[Webservice sharedManager] post:kUrlLogout parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
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

#pragma mark- Register device
- (void)registerDeviceForPushNotification:(NSString *)deviceToken deviceType:(NSString *)deviceType success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"deviceToken":deviceToken,@"deviceType":deviceType};
    [[Webservice sharedManager] post:kUrlRegisterDevice parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         if([[Webservice sharedManager] isStatusOK:responseObject])
         {
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
#pragma mark- end

@end
