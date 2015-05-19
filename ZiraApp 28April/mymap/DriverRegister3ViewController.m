//
//  DriverRegister3ViewController.m
//  mymap
//
//  Created by vikram on 24/11/14.
//

#import "DriverRegister3ViewController.h"
#import "Base64.h"


@interface DriverRegister3ViewController ()

@end

@implementation DriverRegister3ViewController

@synthesize Register2ViewDict;
@synthesize comingFrom,userRecordArray;


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    flag=0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            ScrollView.contentSize = CGSizeMake(320, 600);

        }
        else
        {
            ScrollView.contentSize = CGSizeMake(320, 568);

        }
    }

    
    if ([comingFrom isEqualToString:@"DriverView"])
    {
        NSLog(@"%@",userRecordArray);
        //vechicle Image View
        NSString *VechImageUrl=[userRecordArray valueForKey:@"vechile_img_location"];
        
        if (![VechImageUrl isKindOfClass:[NSNull class]])
        {
            if (![VechImageUrl isEqualToString:@""])
            {
                UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                objactivityindicator.center = CGPointMake((VechicleImageView.frame.size.width/2),(VechicleImageView.frame.size.height/2));
                [VechicleImageView addSubview:objactivityindicator];
                [objactivityindicator startAnimating];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    NSURL *imageURL=[NSURL URLWithString:[VechImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                    UIImage *imgData=[UIImage imageWithData:tempData];
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                       {
                                           [VechicleImageView setImage:imgData];
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                       else
                                       {
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                   });
                });
            }
        }

        
        //RC Image View
        NSString *RcImageUrl=[userRecordArray valueForKey:@"rc_img_location"];
        if (![RcImageUrl isKindOfClass:[NSNull class]])
        {
            if (![RcImageUrl isEqualToString:@""])
            {
                UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                objactivityindicator.center = CGPointMake((RCLImageView.frame.size.width/2),(RCLImageView.frame.size.height/2));
                [RCLImageView addSubview:objactivityindicator];
                [objactivityindicator startAnimating];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    NSURL *imageURL=[NSURL URLWithString:[RcImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                    UIImage *imgData=[UIImage imageWithData:tempData];
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                       {
                                           [RCLImageView setImage:imgData];
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                       else
                                       {
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                   });
                });
            }

        }
        //DL Image View
        NSString *DLImageUrl=[userRecordArray valueForKey:@"license_img_location"];
        if (![DLImageUrl isKindOfClass:[NSNull class]])
        {
            if (![DLImageUrl isEqualToString:@""])
            {
                UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                objactivityindicator.center = CGPointMake((DLImageView.frame.size.width/2),(DLImageView.frame.size.height/2));
                [DLImageView addSubview:objactivityindicator];
                [objactivityindicator startAnimating];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    NSURL *imageURL=[NSURL URLWithString:[DLImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                    UIImage *imgData=[UIImage imageWithData:tempData];
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                       {
                                           [DLImageView setImage:imgData];
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                       else
                                       {
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                   });
                });
            }
        }

        //MC Image View
        NSString *MCImageUrl=[userRecordArray valueForKey:@"medicalcertificate_img_location"];
        if (![MCImageUrl isKindOfClass:[NSNull class]])
        {
            if (![MCImageUrl isEqualToString:@""])
            {
                UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                objactivityindicator.center = CGPointMake((MedicalImageView.frame.size.width/2),(MedicalImageView.frame.size.height/2));
                [MedicalImageView addSubview:objactivityindicator];
                [objactivityindicator startAnimating];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    NSURL *imageURL=[NSURL URLWithString:[MCImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                    UIImage *imgData=[UIImage imageWithData:tempData];
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                       {
                                           [MedicalImageView setImage:imgData];
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                       else
                                       {
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                   });
                });
            }
        }

        
    }

   // self.title=@"DOCUMENT UPLOAD";
    

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
  //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];
     
}

#pragma mark - Choose RCL Image Button Action

- (IBAction)ChooseRCLImage:(id)sender
{
    ImageType=@"RCL";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
  
}

#pragma mark - Choose  Vechicle Image Button Action

- (IBAction)ChooseVechicleImage:(id)sender
{
    ImageType=@"ChoseVechicle";

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
  
}

#pragma mark - Choose  DL Image Button Action

- (IBAction)ChooseDLImage:(id)sender
{
    ImageType=@"DL";

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
  
}

#pragma mark - Choose  Medical Image Button Action

- (IBAction)ChooseMedicalImage:(id)sender
{
    ImageType=@"Medical";

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
  
}

#pragma mark - Done Button Action

- (IBAction)DoneButtonAction:(id)sender
{
    NSData *img1Data = UIImageJPEGRepresentation(RCLImageView.image, 1.0);
    NSData *img1Data1 = UIImageJPEGRepresentation(VechicleImageView.image, 1.0);
    NSData *img1Data2 = UIImageJPEGRepresentation(DLImageView.image, 1.0);
    NSData *img1Data3 = UIImageJPEGRepresentation(MedicalImageView.image, 1.0);
    
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"upload-btn.png"], 1.0);
    
    if ([img1Data isEqualToData:img2Data])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Please Upload RCL Photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([img1Data1 isEqualToData:img2Data])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Please Upload Vechicle Photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([img1Data2 isEqualToData:img2Data])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Please Upload Driving Licsence Photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([img1Data3 isEqualToData:img2Data])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Please Upload Medical Certificate Photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSData *blankChkBoxData = UIImageJPEGRepresentation([checkBoxBtn imageForState:UIControlStateNormal], 1.0);
    NSData *blankImageNameData = UIImageJPEGRepresentation([UIImage imageNamed:@"cb_mono_off.png"], 1.0);
    if ([blankChkBoxData isEqualToData:blankImageNameData])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Please Accept Terms & Conditions" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    
    //Hit service
    if ([kappDelegate checkForInternetConnection]==YES)
    {
        [kappDelegate ShowIndicator];
        
        [self RegisterDriver];
    }


}

#pragma mark - Check Box Button Action

- (IBAction)CheckBoxButton:(id)sender
{
    if (flag==0)
    {
        [checkBoxBtn setImage:[UIImage imageNamed:@"cb_mono_on.png"] forState:UIControlStateNormal];
        flag=1;
    }
    else if (flag==1)
    {
        [checkBoxBtn setImage:[UIImage imageNamed:@"cb_mono_off.png"] forState:UIControlStateNormal];
        flag=0;
    }
}

#pragma mark - Action Sheet Delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker
                           animated:YES completion:nil];
    }
    if (buttonIndex==0)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

#pragma mark - Image Picker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(160,160));
    
 //   CGContextRef context = UIGraphicsGetCurrentContext();
    
    [chosenImage drawInRect: CGRectMake(0, 0, 160, 160)];
    
    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if ([ImageType isEqualToString:@"RCL"])
    {
        TriggerValue=@"rc";
        RCLImageView.image = chosenImage;
        [Base64 initialize];
        NSData* data = UIImageJPEGRepresentation(RCLImageView.image, 0.6f);
        NSString *RclImageBase64 = [Base64 encode:data];
        [self PostImageToServer:RclImageBase64];
 
    }
    else if ([ImageType isEqualToString:@"ChoseVechicle"])
    {
        TriggerValue=@"vehicle";
        VechicleImageView.image = chosenImage;
        [Base64 initialize];
        NSData* data1 = UIImageJPEGRepresentation(VechicleImageView.image, 0.6f);
        NSString *VechicleImageBase64 = [Base64 encode:data1];
        [self PostImageToServer:VechicleImageBase64];
    }
    else if ([ImageType isEqualToString:@"DL"])
    {
        TriggerValue=@"drivinglicense";
        DLImageView.image = chosenImage;
        
        [Base64 initialize];
        NSData* data2 = UIImageJPEGRepresentation(DLImageView.image, 0.6f);
        NSString *DLImageBase64 = [Base64 encode:data2];
        [self PostImageToServer:DLImageBase64];
        
    }
    else if ([ImageType isEqualToString:@"Medical"])
    {
        TriggerValue=@"medicalcertificate";
        MedicalImageView.image = chosenImage;
        
        [Base64 initialize];
        NSData* data3 = UIImageJPEGRepresentation(MedicalImageView.image, 0.6f);
        NSString *MedicalImageBase64 = [Base64 encode:data3];
        [self PostImageToServer:MedicalImageBase64];
    }

    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [viewController.navigationItem setTitle:@""];
    
}

#pragma mark - Register to Driver

-(void)RegisterDriver
{
   // Get values from dictionary
    NSString *vehicle_make=[Register2ViewDict valueForKey:@"ChoseVechicleMake"];
    NSString *vehicle_model=[Register2ViewDict valueForKey:@"ChoseVechicleModel"];
    NSString *vehicle_year=[Register2ViewDict valueForKey:@"ChoseVechicleYear"];
    NSString *licensePlateNumber=[Register2ViewDict valueForKey:@"ChoseVechiclePlateNo"];
    NSString *licensePlateCountry=[Register2ViewDict valueForKey:@"ChoseLicsencePlateCntry"];
    NSString *licensePlateState=[Register2ViewDict valueForKey:@"ChoseLicsencePlateState"];
    
    NSString *licensePlateCountryID=[Register2ViewDict valueForKey:@"ChoseLicsencePlateCntryID"];
    NSString *licensePlateStateID=[Register2ViewDict valueForKey:@"ChoseLicsencePlateStateID"];
    NSString *vehicle_modelID=[Register2ViewDict valueForKey:@"ChoseVechicleModelID"];

    
    
    NSString *address1=[Register2ViewDict valueForKey:@"Address1"];
    NSString *address2=[Register2ViewDict valueForKey:@"Address2"];
    NSString *city=[Register2ViewDict valueForKey:@"City"];
    NSString *state=[Register2ViewDict valueForKey:@"State"];
    NSString *stateID=[Register2ViewDict valueForKey:@"StateID"];
    NSString *cityID=[Register2ViewDict valueForKey:@"cityId"];

    NSString *zipcode=[Register2ViewDict valueForKey:@"ZipCode"];
    NSString *drivingLicenseNumber=[Register2ViewDict valueForKey:@"DrivingLicsenceNo"];
    NSString *drivingLicenseState=[Register2ViewDict valueForKey:@"DrivingLicsenceState"];
    NSString *drivingLicenseStateID=[Register2ViewDict valueForKey:@"DrivingLicsenceStateID"];

    NSString *drivingLicenseExpirationDate=[Register2ViewDict valueForKey:@"DrivingLicsenceExpDate"];
    NSString *dateofbirth=[Register2ViewDict valueForKey:@"DOB"];
    NSString *socialSecurityNumber=[Register2ViewDict valueForKey:@"SocialSecurityNo"];

    webservice=1;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderid",vehicle_make,@"vehicle_make",vehicle_modelID,@"vehicle_model",vehicle_year,@"vehicle_year",licensePlateNumber,@"licensePlateNumber",licensePlateCountryID,@"licensePlateCountry",licensePlateStateID,@"licensePlateState",address1,@"address1",address2,@"address2",cityID,@"city",stateID,@"state",zipcode,@"zipcode",drivingLicenseNumber,@"drivingLicenseNumber",drivingLicenseStateID,@"drivingLicenseState",drivingLicenseExpirationDate,@"drivingLicenseExpirationDate",dateofbirth,@"dateofbirth",socialSecurityNumber,@"socialSecurityNumber",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/DriverRegistration",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Post Image To Server

-(void)PostImageToServer:(NSString*)Base64Str
{
    [kappDelegate ShowIndicator];

    webservice=2;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"RiderId",Base64Str,@"Image",TriggerValue,@"Trigger",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/UploadImage",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Post JSON Web Service

-(void)postWebservices
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}

#pragma mark - Response Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    UIAlertView *alert;
    alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Network Connection lost, Please Check your internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  //  [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];
      
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];

    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (webservice==1)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue ];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:messageStr delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag=2;
                [alert show];

            }
        }
        
    }
    else  if (webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue ];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
            }
        }
    }

}

#pragma mark - UIAlert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2)
    {
        if (buttonIndex==0)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
        }
        
    }
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
