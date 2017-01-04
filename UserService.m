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
    NSLog(@"request login %@",requestDict);
    [[Webservice sharedManager] post:kUrlLogin parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"login response %@",responseObject);
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
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"oldPassword":oldPassword,@"newPassword":newPassword};
    NSLog(@"request changePassword %@",requestDict);
    [[Webservice sharedManager] post:kUrlChangePassword parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         NSLog(@"changePassword response %@",responseObject);
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
    NSLog(@"location %@",requestDict);
    [[Webservice sharedManager] post:kUrlLocationUpdate parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"location response%@",responseObject);
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

//-(void)callCrashWebservice :(NSString *)crashString {
//    
//    NSDictionary *requestDict = @{@"content":crashString,@"to":@"hemlata@ranosys.com,rohit@ranosys.com",@"subject":@"Finder location webservice"};
//    NSError *error;
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://ranosys.net/client/starrez/crash.php"]];
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:&error];
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:url];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        //DLog(@"data is %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        
//    }];
//    [postDataTask resume];
//}
//

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
    NSLog(@"request for push notification %@",requestDict);
    [[Webservice sharedManager] post:kUrlRegisterDevice parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         if([[Webservice sharedManager] isStatusOK:responseObject])
         {
             NSLog(@"response for push notification %@",responseObject);
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
