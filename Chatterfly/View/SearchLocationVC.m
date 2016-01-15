//
//  SearchLocationVC.m
//  Chatterfly
//
//  Created by Frank on 7/16/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "SearchLocationVC.h"
#import "Public.h"
#import "MyAnnotation.h"
#import "LatLng.h"
#import "chatRoomsVC.h"
#define MILE 1609
#define DISTANCE_BY_MILE 10
#define DISTANCE_BY_METER DISTANCE_BY_MILE * MILE
@interface SearchLocationVC ()

@end

@implementation SearchLocationVC{
    NSMutableArray *searchResults;
    NSMutableArray* positions;
    NSArray* friendsInfo;
    CLLocation *myLocation;
    int loadCount;
}

CLLocationManager *locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    loadCount = 0;
    
    [self initLocationManager];
    //[self setInitMapRegion];
    _markView.layer.cornerRadius = 22;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    [locationManager startUpdatingLocation];
    
}

- (void)initLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager requestWhenInUseAuthorization];
    locationManager.distanceFilter = 500; // meters
}

-(void) setInitMapRegion
{
    double mile = [Global sharedInstance].mileRadius;
    MKCoordinateRegion currentRegion;
    currentRegion.center = _mapView.userLocation.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta  = mile / 25;
    span.longitudeDelta = mile / 25;
    currentRegion.span = span;
    [_mapView setRegion:currentRegion animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateLocation");
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"regionDidChanged");
    if(loadCount == 0)
    {
        [self setInitMapRegion];
        loadCount++;
    }
    else
    {
        MKMapRect mRect = _mapView.visibleMapRect;
        MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
        MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
        
        [Global sharedInstance].mileRadius = (int)(MKMetersBetweenMapPoints(eastMapPoint, westMapPoint) * 0.95 / 2 / 1609);
        if([Global sharedInstance].mileRadius < 2)
            _markLabel.text = @"mile";
        else
            _markLabel.text = @"miles";
        
        NSString *mileString = [NSString stringWithFormat: @"%d", [Global sharedInstance].mileRadius];
        [_milesLabel setText:mileString];
    }
}

-(float)getDistanceFrom:(CLLocation*)loc1 to:(CLLocation*)loc2
{
    return [loc1 distanceFromLocation:loc2];
}

-(void) viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    NSLog(@"OnBack");
    
    chatRoomsVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chatRoom"];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)updateFriendsMarker
//{
//    NSMutableArray * annotations = [[NSMutableArray alloc] init];
//    for (LatLng *pos in positions) {
//        MyAnnotation *annotation = [[MyAnnotation alloc] init];
//        [annotation setTitle:pos.name];
//        [annotation setCoordinate:pos.coordinate.latitude
//                        longitude:pos.coordinate.longitude];
//        [annotations addObject:annotation];
//    }
//    [_mapView removeAnnotations:_mapView.annotations];
//    [_mapView addAnnotations:annotations];
//}

//#pragma mark - ADClusterMapViewDelegate
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    NSLog(@"name:%@", annotation.title);
//    MKAnnotationView * pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotation.title];
//    if (!pinView) {
//        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
//                                               reuseIdentifier:annotation.title];
//        //UIImage *image = nil;
//        for(int i = 0; i < searchResults.count; i++){
//            PFUser* obj = [searchResults objectAtIndex:i];
//            
//            if ([annotation.title isEqualToString:obj[PF_USER_USERNAME]]){
//                
//                [obj[PF_USER_PICTURE] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                    if (!error) {
//                        UIImage *image = [UIImage imageWithData:data];
//                        image = [self imageWithImage: image scaledToSize:CGSizeMake(30, 30)];
//                        pinView.image = image;
//                        // image can now be set on a UIImageView
//                    }
//                }];
//                
//                break;
//            }
//            
//            if ([annotation.title isEqualToString:@"Current Location"]){
//                
//                [[PFUser currentUser][PF_USER_PICTURE] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                    if (!error) {
//                        UIImage *image = [UIImage imageWithData:data];
//                        image = [self imageWithImage: image scaledToSize:CGSizeMake(30, 30)];
//                        pinView.image = image;
//                        // image can now be set on a UIImageView
//                    }
//                }];
//                
//                break;
//            }
//        }
//        
//        pinView.canShowCallout = YES;
//    }
//    else {
//        pinView.annotation = annotation;
//    }
//    return pinView;
//}


//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    MyAnnotation* annotation = view.annotation;
//    [mapView deselectAnnotation:annotation animated:YES];
//    
//    for(int i = 0; i< searchResults.count; i++)
//    {
//        if(annotation.title == [searchResults objectAtIndex:i][PF_USER_USERNAME])
//        {
//            PFUser *otherUser = [searchResults objectAtIndex:i];
//            PFUser *currentUser = [PFUser currentUser];
//            NSString *groupId = StartPrivateChat(otherUser, currentUser);
//            [self actionChat:groupId user : otherUser];
//        }
//    }
//    
//}



//- (void)actionChat:(NSString *)groupId user:(PFUser*) user
////-------------------------------------------------------------------------------------------------------------------------------------------------
//{
//    
//    ChatView *chatView = [[ChatView alloc] initWith:groupId];
//    chatView.oppUser = user;
//    chatView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chatView animated:YES];
//}


//- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
//{
//    UIGraphicsBeginImageContext(newSize);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}


//- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
//{
//    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
//    circleView.strokeColor = [UIColor blueColor];
//    circleView.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.2];
//    return circleView;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
