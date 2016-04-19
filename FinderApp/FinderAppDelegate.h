//
//  AppDelegate.h
//  FinderApp
//
//  Created by Hema on 01/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinderAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *navigationController;
@property (nonatomic, strong) NSString *isLocation;
-(void)showIndicator;
-(void)stopIndicator;
-(void)startTrackingBg;
-(void)locationUpdate;
@end

