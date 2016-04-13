//
//  Webservice.h
//  Finder_iPhoneApp
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//client link
//#define BASE_URL                                  @"http://52.74.174.129/admin/api/"

//testing link
#define BASE_URL                                @"http://ranosys.net/client/finder/admin/api/"
@interface Webservice : NSObject
@property(nonatomic,retain)AFHTTPRequestOperationManager *manager;
+ (id)sharedManager;

//Login screen method
- (void)userLogin:(NSString *)email password:(NSString *)password conferenceId:(NSString *)conferenceId success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Forgot password method
-(void)forgotPassword:(NSString *)email conferenceId:(NSString *)conferenceId success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Change password
-(void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

@end
