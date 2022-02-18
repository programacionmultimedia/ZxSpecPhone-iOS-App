//
//  InfoViewController.m
//  ZxSpecPhone
//
//  Created by Raúl Flores on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"



@implementation InfoViewController
@synthesize outputLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
     NSLog(@"infoView Dealloc"); 
    [outputLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.outputLabel setFont:[UIFont fontWithName:@"ZXSpectrum" size:11]];
    outputLabel.text = NSLocalizedString(@"texto1",@"") ;
    outputLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    outputLabel.numberOfLines = 0;
    CGSize constraintSize = CGSizeMake(outputLabel.frame.size.width, MAXFLOAT);
    CGSize labelSize = [[outputLabel text] sizeWithFont:[outputLabel font] constrainedToSize:constraintSize lineBreakMode:outputLabel.lineBreakMode];
    outputLabel.frame = CGRectMake( outputLabel.frame.origin.x, outputLabel.frame.origin.y, outputLabel.frame.size.width, labelSize.height);
    
   
        NSString *toneFilename = [NSString stringWithFormat:@"DTMF_11"];
        
        NSURL *toneURLRef = [[NSBundle mainBundle] URLForResource:toneFilename
                                                    withExtension:@"wav"];
    
        
        SystemSoundID toneSSID = 0;
        
        AudioServicesCreateSystemSoundID(
                                         (CFURLRef) toneURLRef,
                                         &toneSSID
                                         );
        toneSSIDs[0] = toneSSID;
        
  
   
    

}

- (void)viewDidUnload
{
    [self setOutputLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)playSound: (int) index
{
    
    SystemSoundID toneSSID = toneSSIDs[index];
    AudioServicesPlaySystemSound(toneSSID);  
    
}


- (IBAction)dismissView:(id)sender {
    
   
    [self playSound: [sender tag]];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)enviarMail:(id)sender
{
     [self playSound: [sender tag]];
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    
    mail.mailComposeDelegate = self;
    
    if ([MFMailComposeViewController canSendMail]) {
        
        //Setting up the Subject, recipients, and message body.
        
        [mail setToRecipients:[NSArray arrayWithObjects:@"correo.flores@gmail.com",nil]];
        
        [mail setSubject: NSLocalizedString(@"subject",@"") ];
        
        //NSString *mensaje = [NSString stringWithFormat: @"Contacto desde iphone por el artículo: "];
        
        //[mail setMessageBody:mensaje isHTML:YES];
        
        //Present the mail view controller
        
        [self presentModalViewController:mail animated:YES];
        
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message: NSLocalizedString(@"noemail",@"") delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    
    //release the mail
    
    [mail release];
    
    
    


    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    switch (result) {
        case MFMailComposeResultCancelled:
            alert.message =  NSLocalizedString(@"cancelled",@"");
            break;
        case MFMailComposeResultSaved:
            alert.message =  NSLocalizedString(@"saved",@"");
            break;
        case MFMailComposeResultSent:
            alert.message = NSLocalizedString(@"send",@"");
            break;
        case MFMailComposeResultFailed:
            alert.message =  NSLocalizedString(@"fail",@"");
            break;
        default:
            alert.message = NSLocalizedString(@"defaulFail",@"");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
    
    
    [alert show];
    
    [alert release];
    
    
    
}



@end
