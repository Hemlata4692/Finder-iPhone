//
//  Webservice.m
//  Finder_iPhoneApp
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "Webservice.h"
#import "NullValueChecker.h"

#define kUrlLogin                       @"login"
#define kUrlForgotPassword              @"forgotpassword"
#define kUrlChangePassword              @"changepassword"

@implementation Webservice
@synthesize manager;

+ (id)sharedManager
{
    static Webservice *sharedMyManager = nil;
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
        manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        
    }
    return self;
}

#pragma mark - AFNetworking method
- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"OH)-<8v^H\"}n#5AzSUhb>Q.w?;BOwyP2:c.a;dzwPQ:Hc:R6[:*Q^J!7+6pJxKs" forHTTPHeaderField:@"acess_token_key"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"Ok" duration:0.0f];
       
    }];
}


- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"OH)-<8v^H\"}n#5AzSUhb>Q.w?;BOwyP2:c.a;dzwPQ:Hc:R6[:*Q^J!7+6pJxKs" forHTTPHeaderField:@"acess_token_key"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {        [formData appendPartWithFileData:imageData name:@"files" fileName:@"files.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // [myDelegate stopIndicator];
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      //  [myDelegate stopIndicator];
        failure(error);
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:error.localizedDescription closeButtonTitle:@"Ok" duration:0.0f];

    }];
}

- (BOOL)isStatusOK:(id)responseObject {
    NSNumber *number = responseObject[@"isSuccess"];
    NSString *msg;
    switch (number.integerValue)
    {
        case 0:
        {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"Ok" duration:0.0f];
            return NO;
        }
        case 1:
            return YES;
            break;
            
        case 2:
        {
            msg = responseObject[@"message"];
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"Ok" actionBlock:^(void) {
                [self logoutUser];
                }];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"Cancel" duration:0.0f];
        }
            return NO;
            break;
        default: {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showWarning:nil title:@"Alert" subTitle:msg closeButtonTitle:@"Ok" duration:0.0f];
        }
            return NO;
            break;
    }
}
- (void)logoutUser
{
//        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
//        
//        myDelegate.window.rootViewController = myDelegate.navigationController;
//        [UserDefaultManager removeValue:@"userId"];
//        [UserDefaultManager removeValue:@"username"];
}

#pragma mark - end

#pragma mark- Login
//Login
- (void)userLogin:(NSString *)email password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *requestDict = @{@"email":email,@"password":password,@"confrenceId":@"1"};
    NSLog(@"request login %@",requestDict);
    [self post:kUrlLogin parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
           NSLog(@"login response %@",responseObject);
         if([self isStatusOK:responseObject])
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
    NSDictionary *requestDict = @{@"email":email,@"confrenceId":@"1"};
     NSLog(@"request forgotPassword %@",requestDict);
    [self post:kUrlForgotPassword parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
          NSLog(@"forgot password response %@",responseObject);
         if([self isStatusOK:responseObject])
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
    [self post:kUrlChangePassword parameters:requestDict success:^(id responseObject)
     {
         responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
         
         if([self isStatusOK:responseObject])
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
