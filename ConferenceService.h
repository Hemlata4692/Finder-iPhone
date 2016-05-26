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

//Conference Listing
-(void)getConferenceListing:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//Conference detail
-(void)getConferenceDetail:(NSString *)conferenceId success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end

//Matches detail
-(void)getMatchesDetails:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Settings
-(void)changeSettings:(NSString *)switchIdentifire switchStatus:(NSString *)switchStatus success:(void (^)(id))success failure:(void (^)(NSError *))failure;

-(void)getUserSetting:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
//end

//Calendar detail
-(void)getCalendarDetails:(NSString *)conferenceId success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
//end
@end
