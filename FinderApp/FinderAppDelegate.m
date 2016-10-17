//
//  AppDelegate.m
//  FinderApp
//
//  Created by Hema on 01/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "FinderAppDelegate.h"
#import "MMMaterialDesignSpinner.h"
#import "UserService.h"
#import "ConferenceListViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MyAlert.h"
#import "UserService.h"
#import "MatchesViewController.h"
#import "MatchesService.h"
#import "ConferenceService.h"
#import "OtherUserProfileViewController.h"

@interface FinderAppDelegate ()<CLLocationManagerDelegate,MyAlertDelegate>
{
    UIView *loaderView;
    UIImageView *logoImage;
    NSTimer *timer;
    NSString *latitude, *longitude;
    MyAlert* alert;
    UILabel *notificationBadge;
}
@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;
@property (nonatomic, strong) NSDictionary *alertDict;
@end

@implementation FinderAppDelegate
@synthesize isLocation,locationManager;
@synthesize multiplePickerDic;
@synthesize alertDict;
@synthesize tabBarView;
@synthesize alertType;
@synthesize requestArrived;
@synthesize currentNavigationController;
@synthesize myView;

#pragma mark - Global indicator view
- (void)showIndicator
{
    logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 50, 50)];
    logoImage.backgroundColor=[UIColor whiteColor];
    logoImage.layer.cornerRadius=25.0f;
    logoImage.clipsToBounds=YES;
    logoImage.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    loaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    loaderView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:0.3];
    [loaderView addSubview:logoImage];
    self.spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.spinnerView.tintColor = [UIColor colorWithRed:237.0/255.0 green:120.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    self.spinnerView.lineWidth=3.0f;
    [self.window addSubview:loaderView];
    [self.window addSubview:self.spinnerView];
    [self.spinnerView startAnimating];
}
- (void)stopIndicator
{
    [loaderView removeFromSuperview];
    [self.spinnerView removeFromSuperview];
    [self.spinnerView stopAnimating];
}
#pragma mark - end

#pragma mark - Appdelegate methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:237.0/255.0 green:120.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Roboto-Regular" size:19.0], NSFontAttributeName, nil]];
    multiplePickerDic=[[NSMutableDictionary alloc]init];
    alertDict=[NSDictionary new];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
        locationManager.allowsBackgroundLocationUpdates = YES;
    }
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager startUpdatingLocation];
    isLocation=@"0";
    self.deviceToken = @"";
    //google analytics tracking id
    //UA-80202935-1
    NSLog(@"%@",[UserDefaultManager getValue:@"PendingMessage"]);
    if(NULL==[UserDefaultManager getValue:@"PendingMessage"] || nil==[UserDefaultManager getValue:@"PendingMessage"])
    {
        [UserDefaultManager setValue:@"0" key:@"PendingMessage"];
    }
    NSLog(@"userId %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    NSLog(@"conferenceId %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"conferenceId"]);
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //conferenceId
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]!=nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"conferenceId"]!=nil)
    {
        isLocation=@"1";
        MatchesViewController * objView=[storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:objView];
        [self.window makeKeyAndVisible];
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]!=nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"conferenceId"]==nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ConferenceListViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"ConferenceListViewController"];
        [myDelegate.window setRootViewController:homeView];
        [myDelegate.window makeKeyAndVisible];
    }
    else
    {
        LoginViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject:loginView]
                                             animated: YES];
    }
    if ([UserDefaultManager getValue:@"switchStatusDict"]==NULL) {
        NSMutableDictionary *switchDict=[[NSMutableDictionary alloc]init];
        [switchDict setObject:@"true" forKey:@"00"];
        [switchDict setObject:@"true" forKey:@"01"];
        [switchDict setObject:@"25" forKey:@"02"];
        [switchDict setObject:@"true" forKey:@"10"];
        [switchDict setObject:@"true" forKey:@"11"];
        [switchDict setObject:@"true" forKey:@"12"];
        [switchDict setObject:@"true" forKey:@"13"];
        [switchDict setObject:@"true" forKey:@"14"];
        [UserDefaultManager setValue:switchDict key:@"switchStatusDict"];
    }
    //permission for local notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    UILocalNotification *localNotiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
    //Accept local notification when app is not open
    if (localNotiInfo) {
        [self application:application didReceiveLocalNotification:localNotiInfo];
    }
    //Accept push notification when app is not open
    application.applicationIconBadgeNumber = 0;
    NSDictionary *remoteNotifiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if (remoteNotifiInfo)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self application:application didReceiveRemoteNotification:remoteNotifiInfo];
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    [timer invalidate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startTrackingBg) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - end

#pragma mark - Location update in background
- (void)locationUpdate {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]!=nil) {
        [[UserService sharedManager] locationUpdate:latitude longitude:longitude proximityRange:[[UserDefaultManager getValue:@"switchStatusDict"] objectForKey:@"02"] success:^(id responseObject)
         {
             NSLog(@"webservice did fire");
             [self startTrackingBg];
         } failure:^(NSError *error) {
         }] ;
    }
}
- (void) startTrackingBg {
    if ([isLocation isEqualToString:@"2"])
    {
        isLocation=@"0";
        timer = [NSTimer scheduledTimerWithTimeInterval:3*60
                                                 target: self
                                               selector: @selector(locationUpdate)
                                               userInfo: nil
                                                repeats: YES];
        NSLog(@"Timer did fire");
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = (CLLocation *)[locations lastObject];
    CLLocationCoordinate2D cordinates = newLocation.coordinate;
    latitude=[NSString stringWithFormat:@"%f",cordinates.latitude];
    longitude=[NSString stringWithFormat:@"%f",cordinates.longitude];
    if ([isLocation isEqualToString:@"1"])
    {
        isLocation=@"2";
        [ self locationUpdate];
    }
}
#pragma mark - end

#pragma mark - Push notification methods
- (void)registerDeviceForNotification {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken1 {
    NSString *token = [[deviceToken1 description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---.......................%@", token);
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    self.deviceToken = token;
    [[UserService sharedManager] registerDeviceForPushNotification:token deviceType:@"ios" success:^(id responseObject) {
        NSLog(@"push notification response is  --------------------->>>%@",responseObject);
    } failure:^(NSError *error) {
    }] ;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"push notification user info is active state --------------------->>>%@",userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    alertDict=[userInfo objectForKey:@"aps"];
    if (application.applicationState == UIApplicationStateActive)
    {
        if ([[alertDict objectForKey:@"type"] isEqualToString:@"1"]) {
            alert = [[MyAlert alloc] initWithTitle:@"New Match Request" myView:self.window delegate:self message:[alertDict objectForKey:@"alert"] viewBtnText:@"View" acceptBtnText:@"Accept" declineBtnText:@"Decline" isTextField:NO];
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"2"]) {
            alert = [[MyAlert alloc] initWithTitle:@"New Meeting Request" myView:self.window delegate:self message:[alertDict objectForKey:@"alert"] viewBtnText:@"Accept" acceptBtnText:@"" declineBtnText:@"Decline" isTextField:YES];
            if (![myDelegate.myView isEqualToString:@"PendingViewController"]) {
                if ([[UserDefaultManager getValue:@"PendingMessage"] isEqualToString:@"0"]) {
                    [self addBadgeIconOnMoreTab];
                }
                if ([myDelegate.myView isEqualToString:@"MoreViewController"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMoreListing" object:nil];
                }
            }
            else {
                [self removeBadgeIconOnMoreTab];
            }
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"3"]) {
            alert = [[MyAlert alloc] initWithTitle:@"Request Accepted" myView:self.window delegate:self message:[alertDict objectForKey:@"alert"] viewBtnText:@"Ok" acceptBtnText:@"" declineBtnText:@"Cancel" isTextField:NO];
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"4"]) {
            alert = [[MyAlert alloc] initWithTitle:@"Match Request Rejected" myView:self.window delegate:self message:[alertDict objectForKey:@"alert"] viewBtnText:@"Ok" acceptBtnText:@"" declineBtnText:@"Cancel" isTextField:NO];
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"5"]) {
            alert = [[MyAlert alloc] initWithTitle:@"Meeting Request Accepted" myView:self.window delegate:self message:[alertDict objectForKey:@"alert"] viewBtnText:@"Ok" acceptBtnText:@"" declineBtnText:@"Cancel" isTextField:NO];
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"6"]) {
            alert = [[MyAlert alloc] initWithTitle:@"Meeting Request Rejected" myView:self.window delegate:self message:[alertDict objectForKey:@"alert"] viewBtnText:@"Ok" acceptBtnText:@"" declineBtnText:@"Cancel" isTextField:NO];
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"7"]) {
            alert = [[MyAlert alloc] initWithTitle:@"New Conference Assigned" myView:self.window delegate:self message:[alertDict objectForKey:@"alert"] viewBtnText:@"Ok" acceptBtnText:@"" declineBtnText:@"Cancel" isTextField:NO];
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"8"]) {
            alert = [[MyAlert alloc] initWithTitle:@"Proximity Alerts" myView:self.window delegate:self message:[alertDict objectForKey:@"alert"] viewBtnText:@"Ok" acceptBtnText:@"" declineBtnText:@"Cancel" isTextField:NO];
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"9"]) {
            if ([myDelegate.myView isEqualToString:@"PersonalMessageView"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMessageHistory" object:nil];
            }
            else {
                [self addBadgeIcon];
            }
        }
    }
    else {
        if ([[alertDict objectForKey:@"type"] isEqualToString:@"1"]) {
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"2"]) {
            alertType=@"2";
            if ([[UserDefaultManager getValue:@"PendingMessage"] isEqualToString:@"0"]) {
                [self addBadgeIconOnMoreTab];
            }
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"8"]) {
            alertType=@"8";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MatchesViewController * objView=[storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [self.window setRootViewController:objView];
            [self.window makeKeyAndVisible];
        }
    }
}
- (void)myAlertDelegateAction:(CustomAlert *)myAlert option:(int)option reason:(NSString *)reason {
    
    if (option == 0) {
        if ([[alertDict objectForKey:@"type"] isEqualToString:@"1"]) {
            NSLog(@"alert 1");
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OtherUserProfileViewController *view1=[sb instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
            view1.viewType=@"Matches";
            view1.isRequestArrived=@"T";
            view1.otherUserId=[alertDict objectForKey:@"otherUserId"];
            [self.currentNavigationController pushViewController:view1 animated:YES];
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"2"]) {
            [self removeBadgeIconOnMoreTab];
            if ([myDelegate.myView isEqualToString:@"MoreViewController"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMoreListing" object:nil];
            }

            [[ConferenceService sharedManager] acceptCancelMeeting:[alertDict objectForKey:@"appointmentId"] meetingUserId:[alertDict objectForKey:@"meetinguserId"] flag:@"accept" type:@"requested" reasonForCancel:@"" success:^(id responseObject) {
                NSLog(@"calendar type 2");
                if ([myDelegate.myView isEqualToString:@"CalendarViewController"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarDetails" object:nil];
                    NSLog(@"calendar type 2 after success");
                }
            }
                                                           failure:^(NSError *error)
             {
             }] ;
        }
        //accept match request
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"3"]) {
            if ([myDelegate.myView isEqualToString:@"MatchesViewController"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MatchesDetails" object:nil];
            }
        }
        //cancel match request
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"4"]) {
            if ([myDelegate.myView isEqualToString:@"MatchesViewController"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MatchesDetails" object:nil];
            }
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"5"]) {
            if ([myDelegate.myView isEqualToString:@"CalendarViewController"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarDetails" object:nil];
            }
            else if ([myDelegate.myView isEqualToString:@"PendingViewController"]) {
                alertType=@"5";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Requested" object:nil];
            }
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"6"]) {
            if ([myDelegate.myView isEqualToString:@"CalendarViewController"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarDetails" object:nil];
            }
            else if ([myDelegate.myView isEqualToString:@"PendingViewController"]) {
                alertType=@"6";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Requested" object:nil];
            }
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"7"]) {
            if ([myDelegate.myView isEqualToString:@"ConferenceViewController"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Conference" object:nil];
            }
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"8"]) {
            if ([myDelegate.myView isEqualToString:@"ProximityAlertsViewController"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ProximityAlerts" object:nil];
            }
        }
        NSLog(@"view");
    }
    else if(option == 1) {
        if ([[alertDict objectForKey:@"type"] isEqualToString:@"1"]) {
            [[MatchesService sharedManager] acceptDeclineRequest:[alertDict objectForKey:@"otherUserId"] acceptRequest:@"T" success:^(id responseObject) {
                if ([myDelegate.myView isEqualToString:@"MatchesViewController"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MatchesDetails" object:nil];
                }
            }
                                                         failure:^(NSError *error)
             {
             }] ;
        }
        NSLog(@"accept");
    }
    else
    {
        if ([[alertDict objectForKey:@"type"] isEqualToString:@"1"]) {
            [[MatchesService sharedManager] acceptDeclineRequest:[alertDict objectForKey:@"otherUserId"] acceptRequest:@"F" success:^(id responseObject) {
                if ([myDelegate.myView isEqualToString:@"MatchesViewController"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MatchesDetails" object:nil];
                }
            }
                                                         failure:^(NSError *error)
             {
             }] ;
        }
        else if ([[alertDict objectForKey:@"type"] isEqualToString:@"2"]) {
            [[ConferenceService sharedManager] acceptCancelMeeting:[alertDict objectForKey:@"appointmentId"] meetingUserId:[alertDict objectForKey:@"meetinguserId"] flag:@"cancel" type:@"requested" reasonForCancel:reason success:^(id responseObject) {
                if ([myDelegate.myView isEqualToString:@"CalendarViewController"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarDetails" object:nil];
                }
            }
                                                           failure:^(NSError *error)
             {
             }] ;
        }
        NSLog(@"decline");
    }
    [alert dismissAlertView:self.window];
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"did failtoRegister and testing : %@",str);
}
- (void)unregisterDeviceForNotification {
    [[UIApplication sharedApplication]  unregisterForRemoteNotifications];
}
#pragma mark - end

#pragma mark - Local notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateActive) {
    }
    else {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}
#pragma mark - end

#pragma mark - Add badge icon
- (void)addBadgeIcon {
    for (UILabel *subview in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            if (subview.tag == 3365) {
                [subview removeFromSuperview];
            }
        }
    }
    notificationBadge = [[UILabel alloc] init];
    notificationBadge.hidden=NO;
    notificationBadge.frame = CGRectMake((([UIScreen mainScreen].bounds.size.width/5))+45 , ([UIScreen mainScreen].bounds.size.height-40), 8, 8);
    notificationBadge.backgroundColor = [UIColor redColor];
    notificationBadge.layer.cornerRadius = 5;
    notificationBadge.layer.masksToBounds = YES;
    notificationBadge.tag = 3365;
    [myDelegate.tabBarView.tabBar addSubview:notificationBadge];
    [[UIApplication sharedApplication].keyWindow addSubview:notificationBadge];
}
#pragma mark - end

#pragma mark - Remove badge icon
- (void)removeBadgeIconLastTab {
    notificationBadge.hidden=YES;
    notificationBadge.frame = CGRectMake((([UIScreen mainScreen].bounds.size.width/5))+45 , ([UIScreen mainScreen].bounds.size.height-40), 0, 0);
    for (UILabel *subview in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            if (subview.tag == 3365) {
                [subview removeFromSuperview];
            }
        }
    }
}
#pragma mark - end

#pragma mark - Add badge icon
- (void)addBadgeIconOnMoreTab {
    for (UILabel *subview in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            if (subview.tag == 3367) {
                [subview removeFromSuperview];
            }
        }
    }
    notificationBadge = [[UILabel alloc] init];
    notificationBadge.hidden=NO;
    notificationBadge.frame = CGRectMake((([UIScreen mainScreen].bounds.size.width/5) * 5) - (([UIScreen mainScreen].bounds.size.width/5)/2) + 13 , ([UIScreen mainScreen].bounds.size.height-44), 8, 8);
    notificationBadge.backgroundColor = [UIColor redColor];
    notificationBadge.layer.cornerRadius = 4;
    notificationBadge.layer.masksToBounds = YES;
    notificationBadge.tag = 3367;
    [myDelegate.tabBarView.tabBar addSubview:notificationBadge];
    [UserDefaultManager setValue:@"1" key:@"PendingMessage"];
    [[UIApplication sharedApplication].keyWindow addSubview:notificationBadge];
}
#pragma mark - end

#pragma mark - Remove badge icon
- (void)removeBadgeIconOnMoreTab
{
    notificationBadge.hidden=YES;
    notificationBadge.frame = CGRectMake((([UIScreen mainScreen].bounds.size.width/5) * 5) - (([UIScreen mainScreen].bounds.size.width/5)/2) + 13 , ([UIScreen mainScreen].bounds.size.height-44), 0, 0);
    for (UILabel *subview in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            if (subview.tag == 3367) {
                [subview removeFromSuperview];
            }
        }
    }
    [UserDefaultManager setValue:@"0" key:@"PendingMessage"];
}
#pragma mark - end
@end
