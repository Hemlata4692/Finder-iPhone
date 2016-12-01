//
//  MessagesDataModel.h
//  Finder_iPhoneApp
//
//  Created by Hema on 08/07/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagesDataModel : NSObject
@property(nonatomic,retain)NSString * messageDate;
@property(nonatomic,retain)NSString * messageCount;
@property(nonatomic,retain)NSString * otherUserId;
@property(nonatomic,retain)NSString * userName;
@property(nonatomic,retain)NSString * userProfileImage;
@property(nonatomic,retain)NSString * lastMessage;
@property(nonatomic,retain)NSMutableArray * messagesHistoryArray;
@end
