//
//  SearchLocationVC.h
//  Chatterfly
//
//  Created by Frank on 7/16/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface SearchLocationVC : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{

}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (retain, nonatomic) IBOutlet UIView *markView;
@property (retain, nonatomic) IBOutlet UILabel *milesLabel;
@property (retain, nonatomic) IBOutlet UILabel *markLabel;

@end
