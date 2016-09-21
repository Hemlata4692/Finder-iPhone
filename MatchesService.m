//
//  MatchesService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 22/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MatchesService.h"
#import "MatchesDataModel.h"

#define kUrlMatchesList                 @"matcheslist"
#define kUrlUpdateReviewStatus          @"updatereviewstatus"
#define kUrlSendCancelMatchRequest      @"sendcancelmatchrequest"
#define kUrlAcceptDecline               @"acceptdecline"
#define kUrlContactList                 @"contactlist"
#define kUrlAcceptDeclineRequest        @"acceptdeclinerequest"

@implementation MatchesService
#pragma mark - Singleton instance
+ (id)sharedManager {
    static MatchesService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (id)init {
    if (self = [super init])
    {
    }
    return self;
}
#pragma mark - end

#pragma mark - Matches List
- (void)getMatchesList:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"request matches %@",requestDict);
    [[Webservice sharedManager] post:kUrlMatchesList parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"matches response %@",responseObject);
        NSNumber *number = responseObject[@"isSuccess"];
        if (number.integerValue==1) {
            id array =[responseObject objectForKey:@"userContactList"];
            if (([array isKindOfClass:[NSArray class]])) {
                NSArray * matchesListArray = [responseObject objectForKey:@"userContactList"];
                NSMutableArray *dataArray = [NSMutableArray new];
                for (int i =0; i<matchesListArray.count; i++) {
                    MatchesDataModel *matchesDetails = [[MatchesDataModel alloc]init];
                    NSDictionary * matchesDataDict =[matchesListArray objectAtIndex:i];
                    matchesDetails.userImage =[matchesDataDict objectForKey:@"userProfilePic"];
                    matchesDetails.userName =[matchesDataDict objectForKey:@"userName"];
                    matchesDetails.userCompanyName =[matchesDataDict objectForKey:@"companyName"];
                    matchesDetails.isAccepted =[matchesDataDict objectForKey:@"isAccepted"];
                    matchesDetails.reviewStatus =[matchesDataDict objectForKey:@"reviewStatus"];
                    matchesDetails.isRequestSent =[matchesDataDict objectForKey:@"isRequestSent"];
                    matchesDetails.otherUserId =[matchesDataDict objectForKey:@"otherUserId"];
                    matchesDetails.isArrived =[matchesDataDict objectForKey:@"isArrived"];
                    matchesDetails.userDesignation =[matchesDataDict objectForKey:@"userDesignation"];
                    [dataArray addObject:matchesDetails];
                }
                success(dataArray);
            }
        }
        else if(number.integerValue==0) {
            [myDelegate stopIndicator];
            success(nil);
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"Ok" actionBlock:^(void) {
                [[Webservice sharedManager] logoutUser:responseObject[@"message"]];
            }];
            [alert showWarning:nil title:@"Alert" subTitle:responseObject[@"message"] closeButtonTitle:nil duration:0.0f];
        }
        
    } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];
    
}
#pragma mark - end

#pragma mark - Update review status
- (void)updateReviewStatus:(NSString *)otherUserId reviewStatus:(NSString *)reviewStatus success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"otherUserId":otherUserId,@"reviewStatus":reviewStatus};
    NSLog(@"request matches %@",requestDict);
    [[Webservice sharedManager] post:kUrlUpdateReviewStatus parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"matches response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        }
        else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];
}
#pragma mark - end

#pragma mark - Send cancel request
- (void)sendCancelMatchRequest:(NSString *)otherUserId sendRequest:(NSString *)sendRequest success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"otherUserId":otherUserId,@"send":sendRequest};
    NSLog(@"request matches %@",requestDict);
    [[Webservice sharedManager] post:kUrlSendCancelMatchRequest parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"request sent matches response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        }
        else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];
}
#pragma mark - end

#pragma mark - Accept decline request
- (void)acceptDeclineRequest:(NSString *)otherUserId acceptRequest:(NSString *)acceptRequest success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"otherUserId":otherUserId,@"accept":acceptRequest};
    NSLog(@"accept decline matches %@",requestDict);
    [[Webservice sharedManager] post:kUrlAcceptDeclineRequest parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"accept decline sent matches response %@",responseObject);
        if([[Webservice sharedManager] isStatusOK:responseObject]) {
            success(responseObject);
        }
        else {
            [myDelegate stopIndicator];
            failure(nil);
        }
    } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];
}
#pragma mark - end
@end
