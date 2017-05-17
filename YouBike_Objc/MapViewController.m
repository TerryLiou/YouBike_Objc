//
//  MapViewController.m
//  YouBike_Objc
//
//  Created by 劉洧熏 on 2017/5/15.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *objLocationManager;
    CLLocationCoordinate2D stationCoordinate;
    double stationLatitue, stationLongitute;

    NSArray* routes;
    BOOL isUpdatingRoutes;
    
}

@property (strong,nonatomic) MKMapItem *destination;
@property (strong,nonatomic) MKMapItem *source;


@end

@implementation MapViewController

@synthesize segment;
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //mapViewDelegete.delegate = self;
    mapView.showsUserLocation = YES;
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:TRUE];
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 0.02, 0.02);
    //[mapView setRegion:region animated:YES];
    mapView.delegate = self;
    [self showRouteOnMap];
    
    }

-(void)showRouteOnMap {
    stationCoordinate = CLLocationCoordinate2DMake(25.033408, 121.564099);
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placemarkDestination = [[MKPlacemark alloc] initWithCoordinate: stationCoordinate];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemarkDestination];
    [request setDestination:destination];
    //request
    request.requestsAlternateRoutes = NO;
    request.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [self addAnnotation:placemarkDestination];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
             if (error) {
                 NSLog(@"ERROR");
                 NSLog(@"%@", [error localizedDescription]);
             } else {
                 [self showRoute: response];
             }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response {
    
        for (MKRoute * route in response.routes) {
            [mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
            
            for (MKRouteStep *step in route.steps) {
                NSLog(@"%@", step.instructions);
            }
        
    }
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (void) addAnnotation:(CLPlacemark *)placemark {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    
    [self.mapView addAnnotation:point];
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
}
/* CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(latitude_UserLocation, longitude_UserLocation);
    //shown area
    MKCoordinateSpan span;
    span.latitudeDelta = 0.2;
    span.longitudeDelta = 0.2;
    //staring point
    CLLocationCoordinate2D location2D;
    location2D.latitude = latitude_UserLocation;
    location2D.longitude = longitude_UserLocation;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = location2D;
    [mapView setRegion:region animated:true];
    
    CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(25.135915, 121.664099);
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center = sourceCoords;
    span.latitudeDelta = 1;
    span.longitudeDelta = 1;
    region.span = span;
    [mapView setRegion:region animated:TRUE];

    
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:_destination];
    CLLocationCoordinate2D destCoords = CLLocationCoordinate2DMake(25.035915, 121.564099);
    MKPlacemark *placeMark1 = [[MKPlacemark alloc] initWithCoordinate:destCoords addressDictionary:nil];

    
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:_source];
    request.source = mapItem1;

}*/
- (IBAction)mapSegment:(id)sender {
    switch (segment.selectedSegmentIndex) {
        case 0:
            [mapView setMapType:MKMapTypeStandard];
            break;
        case 1:
            [mapView setMapType:MKMapTypeSatellite];
            break;
        case 2:
            [mapView setMapType:MKMapTypeHybrid];
            break;
        default:
            break;
    }
}

@end
