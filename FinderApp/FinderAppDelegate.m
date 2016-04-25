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
#import <CoreLocation/CoreLocation.h>
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "MyAlert.h"

@interface FinderAppDelegate ()<CLLocationManagerDelegate,MyAlertDelegate>
{
    UIView *loaderView;
    UIImageView *logoImage;
    CLLocationManager *locationManager;
    NSTimer *timer;
    NSString *latitude, *longitude;
    MyAlert* alert;
}
@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;
@end

@implementation FinderAppDelegate
@synthesize isLocation;

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:237.0/255.0 green:120.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Roboto-Regular" size:18.0], NSFontAttributeName, nil]];
    
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

    NSLog(@"userId %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]!=nil)
    {
        isLocation=@"1";
        HomeViewController * objView=[storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:objView];
        [self.window makeKeyAndVisible];
    }
    else
    {
        LoginViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject:loginView]
                                             animated: YES];
    }
    
    if ([UserDefaultManager getValue:@"switchStatusDict"]==NULL) {
        NSMutableDictionary *switchDict=[[NSMutableDictionary alloc]init];
        [switchDict setObject:@"True" forKey:@"00"];
        [switchDict setObject:@"True" forKey:@"01"];
        [switchDict setObject:@"0" forKey:@"02"];
        [switchDict setObject:@"True" forKey:@"10"];
        [switchDict setObject:@"True" forKey:@"11"];
        [switchDict setObject:@"True" forKey:@"12"];
        [UserDefaultManager setValue:switchDict key:@"switchStatusDict"];
    }
    
    //permission for local notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    UILocalNotification *localNotiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
   
    //Accept local notification when app is not open
    if (localNotiInfo)
    {
        [self application:application didReceiveLocalNotification:localNotiInfo];
    }
    return YES;
}
-(void)locationUpdate
{
    [[UserService sharedManager] locationUpdate:latitude longitude:longitude success:^(id responseObject)
     {
         NSLog(@"webservice did fire");
         [self startTrackingBg];
         
     } failure:^(NSError *error) {
         
     }] ;
    
}
- (void) startTrackingBg
{
    if ([isLocation isEqualToString:@"2"])
    {
        isLocation=@"0";
      
        timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                 target: self
                                               selector: @selector(locationUpdate)
                                               userInfo: nil
                                                repeats: YES];
         NSLog(@"Timer did fire");
    }
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location updating1111");
    CLLocationCoordinate2D cordinates = newLocation.coordinate;
    NSLog(@"***************************My Loaction---->%f, %f*************************** ", cordinates.latitude, cordinates.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"location updating2222");
    CLLocation *newLocation = (CLLocation *)[locations lastObject];
    CLLocationCoordinate2D cordinates = newLocation.coordinate;
       NSLog(@"***************************My Loaction---->%f, %f*************************** ", cordinates.latitude, cordinates.longitude);
  
    latitude=[NSString stringWithFormat:@"%f",cordinates.latitude];
    longitude=[NSString stringWithFormat:@"%f",cordinates.longitude];
    if ([isLocation isEqualToString:@"1"])
    {
        isLocation=@"2";
        [ self locationUpdate];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Push notification methods
-(void)registerDeviceForNotification
{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken1
{
    NSString *token = [[deviceToken1 description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    self.deviceToken = token;
    //    [[WebService sharedManager] registerDeviceForPushNotification:^(id responseObject) {
    //
    //    } failure:^(NSError *error) {
    //
    //    }] ;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    if (application.applicationState == UIApplicationStateActive)
    {
       alert = [[MyAlert alloc] initWithTitle:@"New Meeting Request" myView:self.window delegate:self message:@"this is text vaklfkldsfkl lfj fjg gjr jthik rthjrtkhj rtjhhjrtihrtkhj tjhtjh hjrtjhkrth rthjrtjhkrththjrth g 5 hguhg ghghu g ghrhg rgr ghrgjr ghr g hema" viewBtnText:@"View" acceptBtnText:@"Accept" declineBtnText:@"Decline"];
        
        NSLog(@"push notification user info is active state --------------------->>>%@",userInfo);
    }
    
}

- (void)myAlertDelegateAction:(CustomAlert *)myAlert option:(int)option{
    
    if (option == 0) {
        
        NSLog(@"left");
    }
    else if(option == 1){
        
        NSLog(@"right");
    }
    else
    {
        NSLog(@"decline");
    }
    [alert dismissAlertView:self.window];
}

//-(NSString *)getNotificationMessage : (NSDictionary *)userInfo
//{
//    NSLog(@"Notification response  %@", userInfo);
//    NSDictionary *tempDict=[userInfo objectForKey:@"aps"];
//    threadId = [tempDict objectForKey:@"threadid"];
//    groupId = [tempDict objectForKey:@"groupId"];
//    notificationRole = [[tempDict objectForKey:@"role"] intValue];
//    NSLog(@"%@", threadId);
//    NSLog(@"%@", groupId);
//    return [tempDict objectForKey:@"alert"];
//}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"did failtoRegister and testing : %@",str);
    
}

@end
