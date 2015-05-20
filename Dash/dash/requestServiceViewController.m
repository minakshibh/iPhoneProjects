//
//  requestServiceViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/27/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "requestServiceViewController.h"

@interface requestServiceViewController ()

@end

@implementation requestServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [dateTimePickr addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    locationArray = [[NSMutableArray alloc] initWithObjects:@"Mohali",@"Chandigarh",@"Others", nil];
     serviceTpeArray= [[NSMutableArray alloc] initWithObjects:@"Exterior Only",@"Exterior & Interior", nil];
    serviceTimeArray= [[NSMutableArray alloc] initWithObjects:@"Now",@"Later", nil];
    specialRequirmentTxt.layer.borderColor = [UIColor grayColor].CGColor;
    specialRequirmentTxt.layer.borderWidth = 1.0;
    specialRequirmentTxt.layer.cornerRadius = 4.0;
    [specialRequirmentTxt setClipsToBounds:YES];
    
    modeltxt.layer.borderColor = [UIColor grayColor].CGColor;
    modeltxt.layer.borderWidth = 1.0;
    modeltxt.layer.cornerRadius = 4.0;
    [modeltxt setClipsToBounds:YES];
    
    maketxt.layer.borderColor = [UIColor grayColor].CGColor;
    maketxt.layer.borderWidth = 1.0;
    maketxt.layer.cornerRadius = 4.0;
    [maketxt setClipsToBounds:YES];
    
    vehicleNumberTxt.layer.borderColor = [UIColor grayColor].CGColor;
    vehicleNumberTxt.layer.borderWidth = 1.0;
    vehicleNumberTxt.layer.cornerRadius = 4.0;
    [vehicleNumberTxt setClipsToBounds:YES];
    
    colorTxt.layer.borderColor = [UIColor grayColor].CGColor;
    colorTxt.layer.borderWidth = 1.0;
    colorTxt.layer.cornerRadius = 4.0;
    [colorTxt setClipsToBounds:YES];
    
    selectLocationBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectLocationBtn.layer.borderWidth = 1.0;
    selectLocationBtn.layer.cornerRadius = 4.0;
    [selectLocationBtn setClipsToBounds:YES];
    
    selectServiceTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectServiceTimeBtn.layer.borderWidth = 1.0;
    selectServiceTimeBtn.layer.cornerRadius = 4.0;
    [selectServiceTimeBtn setClipsToBounds:YES];
    
    selectServiceTypeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectServiceTypeBtn.layer.borderWidth = 1.0;
    selectServiceTypeBtn.layer.cornerRadius = 4.0;
    [selectServiceTypeBtn setClipsToBounds:YES];
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

- (IBAction)uploadImageBtnAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (IBAction)getMapLocationBtnAction:(id)sender {
}

- (IBAction)selectLocationBtnAction:(id)sender {
    serviceLocationTableView.hidden = NO;
    
    serviceLocationTableView.layer.borderColor = [UIColor grayColor].CGColor;
    serviceLocationTableView.layer.borderWidth = 1.0;
    serviceLocationTableView.layer.cornerRadius = 4.0;
    [serviceLocationTableView setClipsToBounds:YES];
    
    locationTxt.layer.borderColor = [UIColor grayColor].CGColor;
    locationTxt.layer.borderWidth = 1.0;
    locationTxt.layer.cornerRadius = 4.0;
    [locationTxt setClipsToBounds:YES];
    
    [self.view bringSubviewToFront:serviceLocationTableView];
    [serviceLocationTableView reloadData];
}

- (IBAction)selectServiceTimeBtnAction:(id)sender {
    selectTimeTableView.hidden = NO;
    
    selectTimeTableView.layer.borderColor = [UIColor grayColor].CGColor;
    selectTimeTableView.layer.borderWidth = 1.0;
    selectTimeTableView.layer.cornerRadius = 4.0;
    [selectTimeTableView setClipsToBounds:YES];
    
    selectTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectTimeBtn.layer.borderWidth = 1.0;
    selectTimeBtn.layer.cornerRadius = 4.0;
    [selectTimeBtn setClipsToBounds:YES];
    
    selectDateBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectDateBtn.layer.borderWidth = 1.0;
    selectDateBtn.layer.cornerRadius = 4.0;
    [selectDateBtn setClipsToBounds:YES];
    
    [self.view bringSubviewToFront:serviceLocationTableView];
    [selectTimeTableView reloadData];
}

- (IBAction)selectDateBtnAction:(id)sender {
    NSString *dateEnd;
    if (![selectDateBtn.titleLabel.text isEqualToString:@"     Select Date"]) {
        dateEnd =selectDateBtn.titleLabel.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date2 = [formatter dateFromString:dateEnd];
        dateTimePickr.date=date2;
    }
    
   timeSelectionType =@"Date";
    
    pickerBackView.hidden=NO;
    [self.view bringSubviewToFront:pickerBackView];
    dateTimePickr.datePickerMode=UIDatePickerModeDate;
}

- (IBAction)selectTimeBtnAction:(id)sender {
    NSString *dateEnd;
    if (![selectTimeBtn.titleLabel.text isEqualToString:@"    Select Time"]) {
        dateEnd =selectDateBtn.titleLabel.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm a"];
        NSDate *date2 = [formatter dateFromString:dateEnd];
        dateTimePickr.date=date2;
    }
    
    timeSelectionType =@"Date";
    
    pickerBackView.hidden=NO;
    [self.view bringSubviewToFront:pickerBackView];
    dateTimePickr.datePickerMode=UIDatePickerModeTime;
}

- (IBAction)selectserviceTypeBtnAction:(id)sender {
    selectTypeTableView.hidden = NO;
    
    selectTypeTableView.layer.borderColor = [UIColor grayColor].CGColor;
    selectTypeTableView.layer.borderWidth = 1.0;
    selectTypeTableView.layer.cornerRadius = 4.0;
    [selectTypeTableView setClipsToBounds:YES];
    
//    se.layer.borderColor = [UIColor grayColor].CGColor;
//    locationTxt.layer.borderWidth = 1.0;
//    locationTxt.layer.cornerRadius = 4.0;
//    [locationTxt setClipsToBounds:YES];
    
    [self.view bringSubviewToFront:selectTypeTableView];
    [selectTypeTableView reloadData];
}

- (IBAction)submitBtnAction:(id)sender {
}

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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    uploadImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == serviceLocationTableView) {
        return [locationArray count];

    }else if (tableView == selectTypeTableView){
        return [serviceTpeArray count];
    }else if (tableView == selectTimeTableView){
        return [serviceTimeArray count];
    }
    return 0;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *cellBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        [cellBackground setImage:[UIImage imageNamed:@"list-bg.png"]];
        [cell.contentView addSubview:cellBackground];
    }
    if (tableView == serviceLocationTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[locationArray objectAtIndex:indexPath.row]];
    }
    else if (tableView == selectTypeTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[serviceTpeArray objectAtIndex:indexPath.row]];
    }
    else if (tableView == selectTimeTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[serviceTimeArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == serviceLocationTableView) {
        serviceLocationTableView.hidden = YES;
        selectServiceLocationLbl.text = [NSString stringWithFormat:@"%@",[locationArray objectAtIndex:indexPath.row]];
        if ([selectServiceLocationLbl.text isEqualToString:@"Others"]) {
            getMapLocationBtn.hidden = NO;
            locationTxt.hidden = NO;
            [selectServiceLocationView setFrame:CGRectMake(selectServiceLocationView.frame.origin.x, selectServiceLocationView.frame.origin.y, selectServiceLocationView.frame.size.width, selectServiceLocationView.frame.size.height)];
            [serviceTypeView setFrame:CGRectMake(serviceTypeView.frame.origin.x,serviceTypeView.frame.origin.y+35,serviceTypeView.frame.size.width, serviceTypeView.frame.size.height)];
            [selectTypeTableView setFrame:CGRectMake(selectTypeTableView.frame.origin.x,selectTypeTableView.frame.origin.y+35,selectTypeTableView.frame.size.width, selectTypeTableView.frame.size.height)];
            [selectTimeTableView setFrame:CGRectMake(selectTimeTableView.frame.origin.x,selectTimeTableView.frame.origin.y+35,selectTimeTableView.frame.size.width, selectTimeTableView.frame.size.height)];
        }else{
            
        }
    }
    else if (tableView == selectTypeTableView) {
        selectTypeTableView.hidden = YES;
        selectServiceTypeLbl.text = [NSString stringWithFormat:@"%@",[serviceTpeArray objectAtIndex:indexPath.row]];
        
    }else if (tableView == selectTimeTableView) {
        selectTimeTableView.hidden = YES;
        selectServiceTimeLbl.text = [NSString stringWithFormat:@"%@",[serviceTimeArray objectAtIndex:indexPath.row]];
        if ([selectServiceTimeLbl.text isEqualToString:@"Later"]) {
            selectTimeBtn.hidden = NO;
            selectDateBtn.hidden = NO;
            calenderImg.hidden = NO;
            clockImg.hidden = NO;
            [submitBtn setFrame:CGRectMake(submitBtn.frame.origin.x, submitBtn.frame.origin.y+35, submitBtn.frame.size.width, submitBtn.frame.size.height)];
            [serviceTimeView setFrame:CGRectMake(serviceTimeView.frame.origin.x,serviceTimeView.frame.origin.y,serviceTimeView.frame.size.width, serviceTimeView.frame.size.height)];
        }
    }
}
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([timeSelectionType  isEqualToString:@"Date"] )
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else
    {
        [dateFormatter setDateFormat:@"HH:mm a"];
    }
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    dateSelected=strDate;
}
- (IBAction)doneDateSelectionBttn:(id)sender
{
    if ([timeSelectionType  isEqualToString:@"Date"])
    {
        selectDateBtn.titleLabel.text=dateSelected;
        
        // startBtn.titleLabel.text = dateSelected;
    }
    else
    {
        selectTimeBtn.titleLabel.text=dateSelected;
        // endBtn.titleLabel.text = dateSelected;
    }
    pickerBackView.hidden=YES;
    
}

- (IBAction)cancelDateSelectionBttn:(id)sender {
    dateSelected=@"";
    pickerBackView.hidden=YES;
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
