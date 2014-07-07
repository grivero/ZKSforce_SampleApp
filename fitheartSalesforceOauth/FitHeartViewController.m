//
//  FitHeartViewController.m
//  fitheartSalesforceOauth
//
//  Created by grivero on 7/3/14.
//  Copyright (c) 2014 grivero. All rights reserved.
//

#import "FitHeartViewController.h"
#import "ZKSforce.h"

@interface FitHeartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *connectToSalesforceButton;

@end

@implementation FitHeartViewController

// Salesforce Oauth Info
static NSString * const client_id     = @"3MVG9sLbBxQYwWqsE4vzTWzE4BS4007eXSUK0Ieb0fGTilipiGg3iklrW0jdjq.WiqEfniuTV2WmkAzwmVvMI";
static NSString * const client_secret = @"1641254344913232322";
static NSString * const username      = @"fitheart.mobile.api@fitheart.com.dev";
static NSString * const password      = @"fitheartmobileapi149z7gMQq5pR5hMp5ythBYwrKEh";

- (void)viewDidLoad{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectToSalesforceAction:(UIButton *)sender {
    
    // alert for user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Salesforce is connecting"
                                                    message:@"Please check the Logs in order to see results" delegate:nil cancelButtonTitle:@"Gotcha" otherButtonTitles:nil, nil];
    [alert show];
    
    // hide button
    self.connectToSalesforceButton.enabled = NO;
    
    NSLog(@"Connection to FitHeart Dev Sandbox Started ...");
    
    // connection
    ZKSforceClient *sforce = [[ZKSforceClient alloc] init];
    [sforce setLoginProtocolAndHost:@"https://test.salesforce.com"];
    [sforce login:username password:password];
    
    NSLog(@"Connection granted and about to create a Participant ...");
    
    int randomStudyID = arc4random() % 666000;
    
    // object preparation
    ZKSObject *participant = [ZKSObject withType:@"FitHeart_Participant__c"];
    [participant setFieldValue:[NSString stringWithFormat:@"%i", randomStudyID] field:@"study_id__c"];
    
    // object creation
    NSArray *results = [sforce create:[NSArray arrayWithObject:participant]];
    ZKSaveResult *sr = [results objectAtIndex:0];
    
    if ([sr success]){
        
        NSLog(@"New Participant ID %@", [sr id]);
        NSLog(@"Now creating Sections for the Participant with ID:%@", [sr id]);
        
        ZKSObject *section_fitness = [ZKSObject withType:@"FitHeart_Section__c"];
        [section_fitness setFieldValue:[NSString stringWithFormat:@"%@", [sr id]] field:@"Participant__c"];
        [section_fitness setFieldValue:@"1" field:@"section_id__c"];
        results = [sforce create:[NSArray arrayWithObject:section_fitness]];
        
        ZKSObject *section_health = [ZKSObject withType:@"FitHeart_Section__c"];
        [section_health setFieldValue:[NSString stringWithFormat:@"%@", [sr id]] field:@"Participant__c"];
        [section_health setFieldValue:@"2" field:@"section_id__c"];
        results = [sforce create:[NSArray arrayWithObject:section_health]];
        
        ZKSObject *section_mood = [ZKSObject withType:@"FitHeart_Section__c"];
        [section_mood setFieldValue:[NSString stringWithFormat:@"%@", [sr id]] field:@"Participant__c"];
        [section_mood setFieldValue:@"3" field:@"section_id__c"];
        results = [sforce create:[NSArray arrayWithObject:section_mood]];
        
        NSLog(@"Sections created for the Participant!");
        NSLog(@"-------------------------------------");
        
        NSLog(@"Query all Participants and show result");
        ZKQueryResult *qr = [sforce query:@"SELECT Id, study_id__c FROM FitHeart_Participant__c"];
        for (ZKSObject *o in [qr records]) {
            NSLog(@"Study ID: %@, Salesforce ID: %@", [o fieldValue:@"study_id__c"], [o fieldValue:@"Id"]);
        }
        
    }else
        NSLog(@"error creating participant %@ %@", [sr statusCode], [sr message]);
    
}

@end
