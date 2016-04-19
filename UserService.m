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

@implementation UserService

#pragma mark - Singleton instance
+ (id)sharedManager
{
    static UserService *sharedMyManager = nil;
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

#pragma mark- Login
//Login
- (void)userLogin:(NSString *)email password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *requestDict = @{@"email":email,@"password":password,@"conferenceId":@"1"};
    NSLog(@"request login %@",requestDict);
    [[Webservice sharedManager] post:kUrlLogin parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"login response %@",responseObject);
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

#pragma mark- Forgot password
//Forgot Password
-(void)forgotPassword:(NSString *)email success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"email":email,@"conferenceId":@"1"};
    NSLog(@"request forgotPassword %@",requestDict);
    [[Webservice sharedManager] post:kUrlForgotPassword parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"forgot password response %@",responseObject);
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
-(void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"user_id":[UserDefaultManager getValue:@"userId"],@"oldPassword":oldPassword,@"newPassword":newPassword};
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
-(void)locationUpdate:(NSString *)latitude longitude:(NSString *)longitude success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":@"1",@"latitude":latitude,@"longitude":longitude};
    [[Webservice sharedManager] post:kUrlLocationUpdate parameters:requestDict success:^(id responseObject)
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
@end
