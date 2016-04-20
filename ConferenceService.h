//
//  ConferenceService.h
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConferenceService : NSObject
+ (id)sharedManager;

//Conference detail
-(void)getConferenceDetail:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Matches detail
-(void)getMatchesDetails:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Settings
-(void)changeSettings:(NSString *)switchIdentifire switchStatus:(NSString *)switchStatus success:(void (^)(id))success failure:(void (^)(NSError *))failur;
//end
@end
