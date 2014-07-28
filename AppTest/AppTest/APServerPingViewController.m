//
//  APServerPingViewController.m
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "APServerPingViewController.h"
#import "mach/mach_time.h"

static NSString* PING_URL = @"http://ec2-54-243-205-92.compute-1.amazonaws.com/Tests/ping.php";
static NSString* PING_SUCCESS_MESSAGE = @"Success!";
static NSString* PING_PARAMETERS = @"Password=EGOT";

@interface APServerPingViewController ()
{
    NSMutableData *_responseData;
    
    uint64_t startTime;
    uint64_t endTime;
    uint64_t elapsedTimeNano;
    mach_timebase_info_data_t timeBaseInfo;
}

@end

@implementation APServerPingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set View title
    self.title = @"Server Ping";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // response received; initialize
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append new data to _responseData
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *text;
    
    // if decoded response data equals success message, update label with timing
    if([[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] isEqualToString:PING_SUCCESS_MESSAGE])
    {
        endTime = mach_absolute_time();
        
        elapsedTimeNano = (endTime - startTime) * timeBaseInfo.numer / timeBaseInfo.denom;
        
        text = [NSString stringWithFormat:@"%.02f", elapsedTimeNano / 1000000.00];
        
        NSLog(@"elapsed milliseconds = %.02f", elapsedTimeNano / 1000000.00);
    }
    else
    {
        text = @":( Try again";
    }
    
    _pingResultsLabel.text = text;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *alertTitle = @"Something went wrong";
    NSString *alertText = [NSString stringWithFormat:@"Please retry. Error message: %@", error];
    [[[UIAlertView alloc] initWithTitle:alertTitle
                                message:alertText
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

# pragma mark - Instance Methods

- (IBAction)pingServer:(id)sender
{
    // set label text
    _pingResultsLabel.text = @"Pinging...";
    
    // create request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:PING_URL]];
    
    // set as post request
    [request setHTTPMethod:@"POST"];
    
    // set parameters
    NSString *postString = PING_PARAMETERS;
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // create url connection
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // initialize timer
    startTime = mach_absolute_time();
    endTime = 0;
    elapsedTimeNano = 0;
    mach_timebase_info(&timeBaseInfo);
    
    // fire request
    [connection start];
}

@end
