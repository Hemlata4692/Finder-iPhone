//
//  Webservice.h
//  Finder_iPhoneApp
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//new AWS link
#define BASE_URL                                  @"http://finderapp.com.sg/backend/api/"
//client link
//#define BASE_URL                                  @"http://ranosys.net/client/finder/api/"

//testing link
//#define BASE_URL                                @"http://ranosys.net/client/finder/m3/api/"

@interface Webservice : NSObject
@property(nonatomic,retain)AFHTTPRequestOperationManager *manager;
+ (id)sharedManager;

- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (BOOL)isStatusOK:(id)responseObject;
- (void)logoutUser:(NSString *)msg;
@end
