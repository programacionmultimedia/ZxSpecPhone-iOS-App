//
//  ZxSpecPhoneViewController.h
//  ZxSpecPhone
//
//  Created by Raúl Flores on 26/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ZxSpecPhoneViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,ABNewPersonViewControllerDelegate>{
    
    SystemSoundID toneSSIDs[13];
    
    UIImageView *sprite;
}




@property(nonatomic, retain) NSString *phoneNumberString;
@property(nonatomic, retain)  IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, retain) IBOutlet UIImageView *sprite;

-(IBAction)numberButtonPressed:(UIButton *)pressedButton;
-(IBAction)deleteButtonPressed:(UIButton *)pressedButton;
-(IBAction)dialButtonPressed:(UIButton *)pressedButton;
-(IBAction)contactsButtonPressed:(UIButton *)pressedButton;
-(IBAction)infoButtonPressed:(UIButton *)pressedButton;
- (IBAction)addButtonPressed:(UIButton *)pressedButton;

-(void)displayPhoneNumber;
-(void)playSound: (int) index;
-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration ;

@end
