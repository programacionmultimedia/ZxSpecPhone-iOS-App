//
//  ZxSpecPhoneViewController.m
//  ZxSpecPhone
//
//  Created by Raúl Flores on 26/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZxSpecPhoneViewController.h"
#import "InfoViewController.h"

@implementation ZxSpecPhoneViewController

@synthesize phoneNumberString;
@synthesize phoneNumberLabel;
@synthesize sprite;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
       
        phoneNumberString = [[NSString alloc] init];
        
        for(int count = 0; count < 13; count++){
            NSString *toneFilename = [NSString stringWithFormat:@"DTMF_%02d", count];
            
            NSURL *toneURLRef = [[NSBundle mainBundle] URLForResource:toneFilename
                                                        withExtension:@"wav"];
            
            //NSLog(@"toneFilename: %@",[toneFilename description]);
            
            
            SystemSoundID toneSSID = 0;
            
            AudioServicesCreateSystemSoundID(
                                             (CFURLRef) toneURLRef,
                                             &toneSSID
                                             );
            toneSSIDs[count] = toneSSID;
        }
    }
    
    
//    for( NSString *familyName in [UIFont familyNames] ) {
//        for( NSString *fontName in [UIFont fontNamesForFamilyName:familyName] ) {
//            NSLog(@"%@", fontName);
//        }
//    }
    
    
    

    
    return self;
}
- (void)viewDidUnload {
    [self setPhoneNumberLabel:nil];
    [self setSprite:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [phoneNumberString release];
    [phoneNumberLabel release];
    [sprite release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.phoneNumberLabel setFont:[UIFont fontWithName:@"ZXSpectrum" size:22]];
    
    sprite.alpha  =1;
    [self fadeOut : sprite withDuration: 0.5  ];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void)displayPhoneNumber
{
    if([self.phoneNumberString length] >= 4 && [self.phoneNumberString length] <= 7)
    {
        NSRange  prefixRange   = {0, 3};
        NSString *prefixString = [self.phoneNumberString substringWithRange:prefixRange];
        
        NSString *lineNumberString = [self.phoneNumberString substringFromIndex:3];
        
        self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@-%@", prefixString, lineNumberString];
    }
    else if([self.phoneNumberString length] >= 8 && [self.phoneNumberString length] <= 10)
    {
        NSRange areaCodeRange = {0, 3};
        NSString *areaCodeString = [self.phoneNumberString substringWithRange:areaCodeRange];
        
        NSRange prefixRange = {3, 3};
        NSString *prefixString = [self.phoneNumberString substringWithRange:prefixRange];
        
        NSString *lineNumberString = [self.phoneNumberString substringFromIndex:6];
        
        self.phoneNumberLabel.text = [NSString stringWithFormat:@"(%@) %@-%@", areaCodeString, prefixString, lineNumberString];
        
    }    
    else
    {
        self.phoneNumberLabel.text = self.phoneNumberString;
    }    
}

-(IBAction)numberButtonPressed:(UIButton *)pressedButton
{
    //int toneIndex = [pressedButton.titleLabel.text intValue];
    
  
    
    [self playSound:pressedButton.tag];
    
    NSString *intString = [NSString stringWithFormat:@"%d", pressedButton.tag];

  
    
    self.phoneNumberString = [self.phoneNumberString stringByAppendingString:intString];
    intString=nil;
    
    [self displayPhoneNumber];
}

-(IBAction)deleteButtonPressed:(UIButton *)pressedButton
{
     [self playSound:pressedButton.tag];
    
    if([self.phoneNumberString length] > 0)
    {
        self.phoneNumberString = [self.phoneNumberString substringToIndex:([self.phoneNumberString length] - 1)];
    }
    
    [self displayPhoneNumber];
}

-(IBAction)dialButtonPressed:(UIButton *)pressedButton
{
    
    
    NSString *phoneLinkString = [NSString stringWithFormat:@"tel:%@", self.phoneNumberString];
    NSURL *phoneLinkURL = [NSURL URLWithString:phoneLinkString];
    [[UIApplication sharedApplication] openURL:phoneLinkURL];
}

-(IBAction)contactsButtonPressed:(UIButton *)pressedButton
{
    
 //NSLog(@"contactsButtonPressed"); 
     [self playSound:pressedButton.tag];
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    picker.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	
	
	picker.displayedProperties = displayedItems;
	// Show the picker 
	[self presentModalViewController:picker animated:YES];
    [picker release];	

}

-(IBAction)infoButtonPressed:(UIButton *)pressedButton
{
    [self playSound:pressedButton.tag];
    InfoViewController *infoView = [[InfoViewController alloc] init] ;
    [self presentModalViewController:infoView animated:YES];
    [infoView release];
    //NSLog(@"infoButtonPressed");    
}

- (IBAction)addButtonPressed:(UIButton *)pressedButton 
{
    [self playSound:pressedButton.tag];
    
     if([self.phoneNumberString length] != 0)
        
    {
        
        
        ABRecordRef newPerson = ABPersonCreate();
        CFErrorRef error = NULL;
        
        
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        ABMultiValueAddValueAndLabel(multiPhone, phoneNumberString, kABPersonPhoneMainLabel, NULL);
        
        
        
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
        CFRelease(multiPhone);
        
        
        NSAssert( ! error, @"Something bad happened here." );
        
        
        ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
        [view setDisplayedPerson:newPerson];
        
        
        view.newPersonViewDelegate = self;
        
        
        
        
        UINavigationController *newNavigationController = [[UINavigationController alloc]
                                                           
                                                           initWithRootViewController:view];
        
        [self presentModalViewController:newNavigationController
         
                                animated:YES];
        
        
        
        [view release];
        
        [newNavigationController release];
        CFRelease(newPerson);
        
    } 
    
    
    
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissModalViewControllerAnimated:YES];
    
}



-(void)playSound: (int) index
{
   
    SystemSoundID toneSSID = toneSSIDs[index];
    AudioServicesPlaySystemSound(toneSSID);  
    
}



#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	return YES;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
    ABMultiValueRef container = ABRecordCopyValue(person, property);
    CFStringRef contactData = ABMultiValueCopyValueAtIndex(container, identifier);
    CFRelease(container);
    NSString *contactString = [NSString stringWithString:(NSString *)contactData];
    CFRelease(contactData);
    NSLog(@"phone: %@",contactString  );
    //[self peoplePickerNavigationControllerDidCancel:peoplePicker];
    
    //self.phoneNumberString = contactString;
    
    //[self displayPhoneNumber];

    
    
    
	return YES;
}


// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissModalViewControllerAnimated:YES];
}



-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration 
{
	[UIView beginAnimations: @"Fade Out" context:nil];
	
	// wait for time before begin
	//[UIView setAnimationDelay:wait];
	
	// druation of animation
	[UIView setAnimationDuration:duration];
	viewToDissolve.alpha = 0.0;
	[UIView commitAnimations];
}




@end
