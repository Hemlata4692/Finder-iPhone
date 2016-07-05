//
//  MessageService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 05/07/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MessageService.h"

#define kUrlSendMessage       @"sendmessage"

@implementation MessageService

#pragma mark - Singleton instance
+ (id)sharedManager
{
    static MessageService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}
#pragma mark - end
#pragma mark - Send message
//Send message
-(void)sendMessage:(NSString *)otherUserId message:(NSString *)message success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"otherUserId":otherUserId,@"message":message};
    NSLog(@"send message %@",requestDict);
    [[Webservice sharedManager] post:kUrlSendMessage parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"send message response %@",responseObject);
        NSNumber *number = responseObject[@"isSuccess"];
        if (number.integerValue==1) {
//            id array =[responseObject objectForKey:@"userContactList"];
//            if (([array isKindOfClass:[NSArray class]])) {
//                NSArray * matchesListArray = [responseObject objectForKey:@"userContactList"];
//                NSMutableArray *dataArray = [NSMutableArray new];
//                for (int i =0; i<matchesListArray.count; i++) {
//                    MatchesDataModel *matchesDetails = [[MatchesDataModel alloc]init];
//                    NSDictionary * matchesDataDict =[matchesListArray objectAtIndex:i];
//                    matchesDetails.userImage =[matchesDataDict objectForKey:@"userProfilePic"];
//                    matchesDetails.userName =[matchesDataDict objectForKey:@"userName"];
//                    matchesDetails.userCompanyName =[matchesDataDict objectForKey:@"companyName"];
//                    matchesDetails.isAccepted =[matchesDataDict objectForKey:@"isAccepted"];
//                    matchesDetails.reviewStatus =[matchesDataDict objectForKey:@"reviewStatus"];
//                    matchesDetails.isRequestSent =[matchesDataDict objectForKey:@"isRequestSent"];
//                    matchesDetails.otherUserId =[matchesDataDict objectForKey:@"otherUserId"];
//                    matchesDetails.isArrived =[matchesDataDict objectForKey:@"isArrived"];
//                    [dataArray addObject:matchesDetails];
//                }
                success(responseObject);
            }
        
        else if(number.integerValue==0) {
            [myDelegate stopIndicator];
            success(nil);
        }
        else {
//            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//            [alert addButton:@"Ok" actionBlock:^(void) {
//                [self logoutUser];
//            }];
//            [alert showWarning:nil title:@"Alert" subTitle:responseObject[@"message"] closeButtonTitle:nil duration:0.0f];
        }
        
    } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];

}
@end
