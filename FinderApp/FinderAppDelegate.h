//
//  AppDelegate.h
//  FinderApp
//
//  Created by Hema on 01/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FinderAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *navigationController;
@property (nonatomic, strong) NSString *isLocation;
@property(nonatomic,retain)NSString * deviceToken;
@property (nonatomic, strong)  CLLocationManager *locationManager;
@property (nonatomic,retain) UITabBarController *tabBarView;
@property (nonatomic, strong) NSString *alertType;
@property (nonatomic, strong) NSString *requestArrived;
@property(nonatomic,retain) UINavigationController *currentNavigationController;
@property (strong, nonatomic)NSString *myView;
@property (nonatomic, strong) NSString *otherUserID;
@property (nonatomic, strong) NSString *otherUserName;
- (void)showIndicator;
- (void)stopIndicator;
- (void)startTrackingBg;
- (void)locationUpdate;
- (void)registerDeviceForNotification;
- (void)unregisterDeviceForNotification;
- (void)removeBadgeIconLastTab;
- (void)addBadgeIcon;
- (void)removeBadgeIconOnMoreTab;
- (void)addBadgeIconOnMoreTab;
- (void)addBadgeIconOnProximityTab;
- (void)addBadgeIconOnMatchesTab;
- (void)removeBadgeIconOnMatchesTab;
- (void)removeBadgeIconOnProximityTab;
@end

//com.finder.finderapp app store id
