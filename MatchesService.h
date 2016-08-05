//
//  MatchesService.h
//  Finder_iPhoneApp
//
//  Created by Hema on 22/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchesService : NSObject
+ (id)sharedManager;

//Matches listing
- (void)getMatchesList:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

//Updae review status
- (void)updateReviewStatus:(NSString *)otherUserId reviewStatus:(NSString *)reviewStatus success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//Send cancel request
- (void)sendCancelMatchRequest:(NSString *)otherUserId sendRequest:(NSString *)sendRequest success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//Accept decline request
- (void)acceptDeclineRequest:(NSString *)otherUserId acceptRequest:(NSString *)acceptRequest success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end
