//
//  MessageHistoryDataModel.h
//  Finder_iPhoneApp
//
//  Created by Hema on 11/07/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageHistoryDataModel : NSObject
@property(nonatomic,retain)NSString * dateTime;
@property(nonatomic,retain)NSString * userId;
@property(nonatomic,retain)NSString * userMessage;
@end
