//
//  MessageService.h
//  Finder_iPhoneApp
//
//  Created by Hema on 05/07/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageService : NSObject
+ (id)sharedManager;

//Send message
-(void)sendMessage:(NSString *)otherUserId message:(NSString *)message success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end
