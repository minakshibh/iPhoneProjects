//
//  requestSongViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_1 on 11/25/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "requestSongViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

@interface requestSongViewController ()

@end

@implementation requestSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.activityIndicatorObject.center = CGPointMake(160, 190);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        self.activityIndicatorObject.center = CGPointMake(160, 190);
        // this is iphone 4 xib
    }
    else
    {
        self.activityIndicatorObject.center = CGPointMake(374, 412);
    }
    self.activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:self.activityIndicatorObject];
    [[self.requestSongsTxtView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.requestSongsTxtView layer] setBorderWidth:1.0];
    [[self.requestSongsTxtView layer] setCornerRadius:5];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)requestSongBtn:(id)sender {
    [self requestSong];
}

-(void)requestSong
{
    [self disabled];
    [self.activityIndicatorObject startAnimating];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/RequestSong",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSString *user_email;
    NSString *username;
    NSString *songName;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (songName == nil)
        songName = [NSString stringWithFormat:@"%@",self.requestSongsTxtView.text];
        songName = [songName stringByReplacingOccurrencesOfString:@" " withString:@""];
    [request setPostValue:songName forKey:@"SongName"];
   
    if(user_email==nil)
        user_email = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Email"]];
    [request setPostValue:user_email forKey:@"User_email"];
    
    if(username==nil)
        username = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Username"]];
    [request setPostValue:username forKey:@"UserName"];
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.activityIndicatorObject stopAnimating];
    [self enable];
     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Downloading Failed" message:@"Kindly check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    
        [self.activityIndicatorObject stopAnimating];
        [self enable];
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString = [request responseString];
    NSLog(@"response%@", responseString);
    NSData *responseData = [request responseData];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}
- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI
  qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict
{

        if ([elementName isEqualToString:@"Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Message"]){
            tempString = [[NSMutableString alloc] init];
        }
        
    
    
}



//---when the text in an element is found---
- (void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    [tempString appendString:string];
}
//---when the end of element is found---
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
        if ([elementName isEqualToString:@"Result"]){
            message = [NSString stringWithFormat:@"%@", tempString];
            NSLog(@"Message %@",message);
            if ([message isEqualToString:@"0"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Your request was sent successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                self.requestedSongTxt.text = @"";
            [alert show];
            }
        }
    
    [self.activityIndicatorObject stopAnimating];
    [self enable];
}

- (void) disabled
{
    self.view.userInteractionEnabled = NO;
    self.disabledImgView.hidden = NO;
}
- (void) enable
{
    self.view.userInteractionEnabled = YES;
    self.disabledImgView.hidden = YES;
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.placeHolderLbl.hidden = YES;
    return YES;
}

@end
