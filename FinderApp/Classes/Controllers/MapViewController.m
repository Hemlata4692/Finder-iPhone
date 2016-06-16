//
//  MapViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 16/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "AddressAnnotation.h"

@interface MapViewController ()<MKMapViewDelegate>
{
     AddressAnnotation *addAnnotation;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController
@synthesize mapView;
@synthesize latitude;
@synthesize longitude;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Conference Venue";
    [mapView setDelegate:self];
    mapView.showsUserLocation=NO;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta =0.005;     // 0.0 is min value u van provide for zooming
    span.longitudeDelta=0.005;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [latitude floatValue];
    coordinate.longitude = [longitude floatValue];
    region.span=span;
    region.center =coordinate;
    addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:coordinate];
    [mapView addAnnotation:addAnnotation];
    addAnnotation.myPinColor=MKPinAnnotationColorRed;
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

@end
