//
//  MessageService.m
//  Finder_iPhoneApp
//
//  Created by Hema on 05/07/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MessageService.h"
#import "MessagesDataModel.h"

#define kUrlSendMessage       @"sendmessage"
#define kUrlMessages          @"getdifferentchats"
#define kUrlMessageHistory    @"getmessagehistory"

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
            success(responseObject);
            }
        
        else if(number.integerValue==0) {
            [myDelegate stopIndicator];
            success(nil);
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"Ok" actionBlock:^(void) {
                [[Webservice sharedManager] logoutUser];
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
#pragma mark - Send message
//Send message
-(void)getDifferentMessage:(void (^)(id data))success failure:(void (^)(NSError *error))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"]};
    NSLog(@"get message %@",requestDict);
    [[Webservice sharedManager] post:kUrlMessages parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"get message response %@",responseObject);
        NSNumber *number = responseObject[@"isSuccess"];
        if (number.integerValue==1) {
            id array =[responseObject objectForKey:@"userChatList"];
            if (([array isKindOfClass:[NSArray class]])) {
                NSArray * messagesArray = [responseObject objectForKey:@"userChatList"];
                NSMutableArray *dataArray = [NSMutableArray new];
                for (int i =0; i<messagesArray.count; i++) {
                    MessagesDataModel *messageDetails = [[MessagesDataModel alloc]init];
                    NSDictionary * messageDict =[messagesArray objectAtIndex:i];
                    NSArray* tempDate = [[messageDict objectForKey:@"date"] componentsSeparatedByString: @" "];
                    NSString* dateString = [tempDate objectAtIndex: 0];
                    messageDetails.messageDate =dateString;
                    messageDetails.messageCount =[messageDict objectForKey:@"messageCount"];
                    messageDetails.otherUserId =[messageDict objectForKey:@"otherUserId"];
                    messageDetails.userName =[messageDict objectForKey:@"userName"];
                    messageDetails.userProfileImage =[messageDict objectForKey:@"userProfileImage"];
                    messageDetails.lastMessage =[messageDict objectForKey:@"lastMessage"];
                    [dataArray addObject:messageDetails];
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
                [[Webservice sharedManager] logoutUser];
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

//{userId:"20", otherUserId:" ",conferenceId:"1",readStatus:"True/False", pageOffSet:"0"}
-(void)getMessageHistory:(NSString *)otherUserId readStatus:(NSString *)readStatus pageOffSet:(NSString *)pageOffSet success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *requestDict = @{@"userId":[UserDefaultManager getValue:@"userId"],@"conferenceId":[UserDefaultManager getValue:@"conferenceId"],@"otherUserId":otherUserId,@"readStatus":readStatus,@"pageOffSet":pageOffSet};
    NSLog(@"get message history %@",requestDict);
    [[Webservice sharedManager] post:kUrlMessageHistory parameters:requestDict success:^(id responseObject) {
        responseObject=(NSMutableDictionary *)[NullValueChecker checkDictionaryForNullValue:[responseObject mutableCopy]];
        NSLog(@"get message response history %@",responseObject);
        NSNumber *number = responseObject[@"isSuccess"];
        if (number.integerValue==1) {
//            id array =[responseObject objectForKey:@"userChatList"];
//            if (([array isKindOfClass:[NSArray class]])) {
//                NSArray * messagesArray = [responseObject objectForKey:@"userChatList"];
//                NSMutableArray *dataArray = [NSMutableArray new];
//                for (int i =0; i<messagesArray.count; i++) {
//                    MessagesDataModel *messageDetails = [[MessagesDataModel alloc]init];
//                    NSDictionary * messageDict =[messagesArray objectAtIndex:i];
//                    NSArray* tempDate = [[messageDict objectForKey:@"date"] componentsSeparatedByString: @" "];
//                    NSString* dateString = [tempDate objectAtIndex: 0];
//                    messageDetails.messageDate =dateString;
//                    messageDetails.messageCount =[messageDict objectForKey:@"messageCount"];
//                    messageDetails.otherUserId =[messageDict objectForKey:@"otherUserId"];
//                    messageDetails.userName =[messageDict objectForKey:@"userName"];
//                    messageDetails.userProfileImage =[messageDict objectForKey:@"userProfileImage"];
//                    messageDetails.lastMessage =[messageDict objectForKey:@"lastMessage"];
//                    [dataArray addObject:messageDetails];
//                }
//                success(dataArray);
//            }
            success(responseObject);
        }
        else if(number.integerValue==0) {
            [myDelegate stopIndicator];
            success(nil);
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:@"Ok" actionBlock:^(void) {
                [[Webservice sharedManager] logoutUser];
            }];
            [alert showWarning:nil title:@"Alert" subTitle:responseObject[@"message"] closeButtonTitle:nil duration:0.0f];
        }
        
    } failure:^(NSError *error)
     {
         [myDelegate stopIndicator];
         failure(error);
     }];

}

@end
