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
-(void)getInterestList:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
@end
