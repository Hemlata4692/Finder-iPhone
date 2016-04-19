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
@end
