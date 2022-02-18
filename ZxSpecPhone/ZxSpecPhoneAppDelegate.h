//
//  ZxSpecPhoneAppDelegate.h
//  ZxSpecPhone
//
//  Created by Raúl Flores on 26/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZxSpecPhoneViewController;

@interface ZxSpecPhoneAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ZxSpecPhoneViewController *viewController;

@end
