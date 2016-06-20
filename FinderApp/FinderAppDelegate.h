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
@property (nonatomic, retain) NSMutableDictionary *multiplePickerDic;
-(void)showIndicator;
-(void)stopIndicator;
-(void)startTrackingBg;
-(void)locationUpdate;
-(void)registerDeviceForNotification;
-(void)unregisterDeviceForNotification;
@end

