//
//  InfoViewController.h
//  ZxSpecPhone
//
//  Created by Raúl Flores on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface InfoViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    
    UILabel *outputLabel;
     SystemSoundID toneSSIDs[1];
}
@property (nonatomic, retain) IBOutlet UILabel *outputLabel;

- (IBAction)dismissView:(id)sender;
- (IBAction)enviarMail:(id)sender;
-(void)playSound: (int) index;

@end
