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
//#define BASE_URL                                  @""

//testing link
#define BASE_URL                                @"http://ranosys.net/client/finder/admin/api/"

@interface Webservice : NSObject
@property(nonatomic,retain)AFHTTPRequestOperationManager *manager;
+ (id)sharedManager;

- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (void)postImage:(NSString *)path parameters:(NSDictionary *)parameters image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (BOOL)isStatusOK:(id)responseObject;
@end