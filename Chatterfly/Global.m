//
//  Global.m
//  Restarant
//
//  Created by PJ95 on 5/29/15.
//  Copyright (c) 2015 PJ95. All rights reserved.
//

#import "Global.h"

@implementation Global

+ (Global *) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                  });
    
    return sharedInstance;
}

- (id) init{
    if (self = [super init]){
        self.distance = 0.5;
        self.mileRadius = 10;
    }
    return self;
}

+ (UIStoryboard*) appStoryboard
{
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    //        return [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    //    }
    if (IS_IPHONE_6)
        return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    else if (IS_IPHONE_5)
        return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return nil;
}

@end
