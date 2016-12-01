//
//  MatchesDataModel.h
//  Finder_iPhoneApp
//
//  Created by Hema on 22/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchesDataModel : NSObject
@property(nonatomic,retain)NSString * userImage;
@property(nonatomic,retain)NSString * userName;
@property(nonatomic,retain)NSString * userCompanyName;
@property(nonatomic,retain)NSString * isAccepted;
@property(nonatomic,retain)NSString * isRequestSent;
@property(nonatomic,retain)NSString * reviewStatus;
@property(nonatomic,retain)NSString * otherUserId;
@property(nonatomic,retain)NSString * isArrived;
@property(nonatomic,retain)NSString * userDesignation;

@end
