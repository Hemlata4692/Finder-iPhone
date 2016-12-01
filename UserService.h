//
//  UserService.h
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserService : NSObject
+ (id)sharedManager;

//Login screen method
- (void)userLogin:(NSString *)email password:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Forgot password method
- (void)forgotPassword:(NSString *)email success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Change password
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Location update
- (void)locationUpdate:(NSString *)latitude longitude:(NSString *)longitude proximityRange:(NSString *)proximityRange success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end

//Logout
- (void)logoutUser:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Register Device
- (void)registerDeviceForPushNotification:(NSString *)deviceToken deviceType:(NSString *)deviceType success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//end
@end
