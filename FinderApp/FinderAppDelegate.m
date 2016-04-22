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

@interface FinderAppDelegate ()<CLLocationManagerDelegate>
{
    UIView *loaderView;
    UIImageView *logoImage;
    CLLocationManager *locationManager;
    NSTimer *timer;
    NSString *latitude, *longitude;
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
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.spinnerView = spinnerView;
    self.spinnerView.bounds = CGRectMake(0, 0, 40, 40);
    self.spinnerView.tintColor = [UIColor colorWithRed:36.0/255.0 green:108.0/255.0 blue:164.0/255.0 alpha:1.0];
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
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:36.0/255.0 green:108.0/255.0 blue:164.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Roboto-Regular" size:18.0], NSFontAttributeName, nil]];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
   // [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
        locationManager.allowsBackgroundLocationUpdates = YES;
    }
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager startUpdatingLocation];
    isLocation=@"0";
    
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

@end
