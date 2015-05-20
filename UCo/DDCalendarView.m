
//
//  DDCalendarView.m
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DDCalendarView.h"
//#import "TutorFirstViewController.h"
//TutorFirstViewController*tutorFirstViewObj;


NSMutableArray *Dayarray;

@implementation DDCalendarView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate
{
	if ((self = [super initWithFrame:frame])) {
        PeriodsDetailsDict=[[NSMutableDictionary alloc] init];
        MonthValueFromDatabaseDict=[[NSMutableDictionary alloc] init];
        Dayarray=[[NSMutableArray alloc] init];
        [Dayarray addObject:@"27-03-2015"];
        [Dayarray addObject:@"21-03-2015"];
        [Dayarray addObject:@"12-04-2015"];
        [Dayarray addObject:@"10-04-2015"];

        OvolutionDict=[[NSMutableDictionary alloc] init];
        heartRecordArray=[[NSMutableArray alloc] init];
        
        [self getHeartRecords];
        
        coountDaysNextMonth=0;
        
		self.delegate = theDelegate;
        
		
		//Initialise vars
        calendarFontName = fontName;
		calendarWidth = frame.size.width;
		calendarHeight = frame.size.height;
		cellWidth = frame.size.width / 7.0f;
		cellHeight = frame.size.height / 8.0f;
		
		//View properties
        UIColor *bgPatternImage= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg-2-2.png"]];
            
        
		self.backgroundColor = bgPatternImage;
		[bgPatternImage release];
		
		//Set up the calendar header
		UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[prevBtn setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
        prevBtn.frame = CGRectMake(0, 5, cellWidth, cellHeight);
            
        
		[prevBtn addTarget:self action:@selector(prevBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[nextBtn setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
      
        nextBtn.frame = CGRectMake(calendarWidth - cellWidth, 5, cellWidth, cellHeight);
        
		[nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect monthLabelFrame = CGRectMake(cellWidth, 5, calendarWidth - 2*cellWidth, cellHeight);
            
        
        
        CGRect backLabelFrame;

        backLabelFrame = CGRectMake(0, 0, calendarWidth , cellHeight+8);

        
        UILabel*backLbl=[[UILabel alloc] initWithFrame:backLabelFrame];
        backLbl.backgroundColor = [UIColor colorWithRed:15/255.0f green:32/255.0f blue:58/255.0f alpha:1.0];

		monthLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
		//monthLabel.font = [UIFont fontWithName:calendarFontName size:20];
        // monthLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        
		monthLabel.textAlignment = NSTextAlignmentCenter;
		monthLabel.backgroundColor = [UIColor clearColor];
		monthLabel.textColor = [UIColor blackColor];
        
        // SETTING CUSTOM FONTS //
        UIFont *font= [UIFont fontWithName:@"Lovelo" size:15];
        monthLabel.font=font;
        monthLabel.textColor = [UIColor whiteColor];
        monthLabel.shadowColor = [UIColor blackColor];
        //   monthLabel.shadowOffset = CGSizeMake(1, 1);
        ////
        
		
		//Add the calendar header to view
        [self addSubview:backLbl];
		[self addSubview: prevBtn];
		[self addSubview: nextBtn];
		[self addSubview: monthLabel];
		
		//Add the day labels to the view
		char *days[7] = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
		for(int i = 0; i < 7; i++) {
			CGRect dayLabelFrame = CGRectMake(i*cellWidth, cellHeight+5, cellWidth, cellHeight);
			UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
            
            // SETTING CUSTOM FONTS //
            UIFont *font= [UIFont fontWithName:@"Lovelo" size:11];
            dayLabel.font=font;
      
			dayLabel.text = [NSString stringWithFormat:@"%s", days[i]];
			dayLabel.textAlignment = NSTextAlignmentCenter;
			dayLabel.backgroundColor = [UIColor clearColor];
            [dayLabel setTextColor:[UIColor darkGrayColor]];

			[self addSubview:dayLabel];
			[dayLabel release];
		}
		[self drawDayButtons];
		
		//Set the current month and year and update the calendar
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		
		NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
		NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
		currentMonth = [dateParts month];
		currentYear = [dateParts year];
        [self getdataFromSqlite];
        
		[self updateCalendarForMonth:currentMonth forYear:currentYear];
    }
    return self;
}

- (void)drawDayButtons
{
    int getCount;
	dayButtons = [[NSMutableArray alloc] initWithCapacity:42];
	for (int i = 0; i < 6; i++)
    {
		for(int j = 0; j < 7; j++) {
			CGRect buttonFrame = CGRectMake(j*cellWidth, (i+2)*cellHeight, cellWidth, cellHeight);
			DayButton *dayButton = [[DayButton alloc] buttonWithFrame:buttonFrame];
			dayButton.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13];
			dayButton.delegate = self;
            dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            getCount=[dayButtons count];
            
			[dayButtons addObject:dayButton];
            
			//[dayButton release];
			
			[self addSubview:[dayButtons lastObject]];
		}
	}
    
}

- (void)updateCalendarForMonth:(int)month forYear:(int)year {
    
    char *months[12] = {"January", "Febrary", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"};
    monthLabel.text = [NSString stringWithFormat:@"%s %d", months[month - 1], year];
    
    //Get the first day of the month
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
    [dateParts release];
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
    int weekdayOfFirst = [weekdayComponents weekday];
    
    //Map first day of month to a week starting on Monday
    //as the weekday component defaults to 1->Sun, 2->Mon...
    if(weekdayOfFirst == 1) {
        weekdayOfFirst = 7;
    } else {
        --weekdayOfFirst;
    }
    
    int numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                        inUnit:NSMonthCalendarUnit
                                       forDate:dateOnFirst].length;
    
    NSDate *d = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"dd"];
   
    int monthStr = [[formatter stringFromDate:[NSDate date]]intValue];
    int yearStr = [[formatter1 stringFromDate:[NSDate date]]intValue];
    int dateStr = [[formatter2 stringFromDate:[NSDate date]]intValue];

    int day = 1;
    for (int i = 0; i < 6; i++) {
        for(int j = 0; j < 7; j++) {
            int buttonNumber = i * 7 + j;
            
            DayButton *button = [dayButtons objectAtIndex:buttonNumber];
            [button setBackgroundColor:[UIColor clearColor]];
            button.enabled = NO; //Disable buttons by default
            [button setTitle:nil forState:UIControlStateNormal]; //Set title label text to nil by default
            [button setButtonDate:nil];
            
            if(buttonNumber >= (weekdayOfFirst - 1) && day <= numDaysInMonth) {
                [button setTitle:[NSString stringWithFormat:@"%d", day]
                        forState:UIControlStateNormal];
                
                NSDateComponents *dateParts = [[NSDateComponents alloc] init];
                [dateParts setMonth:month];
                [dateParts setYear:year];
                [dateParts setDay:day];
                NSDate *buttonDate = [calendar dateFromComponents:dateParts];
                [dateParts release];
                if (year ==yearStr && month==monthStr && day== dateStr)
                {
                   //[button setBackgroundColor:[UIColor darkGrayColor]];
                }
                
                
                for (int j=0; j<Dayarray.count; j++)
                {
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                    NSDate *selectedDate = [[NSDate alloc] init];
                    NSString*dateString=[Dayarray objectAtIndex:j];
                    selectedDate=[dateFormatter dateFromString:dateString];

                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"MM"];
                    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                    [formatter1 setDateFormat:@"yyyy"];
                    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
                    [formatter2 setDateFormat:@"dd"];
                    
                   int yearValue = [[formatter1 stringFromDate:selectedDate]intValue];
                   int monthValue = [[formatter stringFromDate:selectedDate]intValue];
                   int dateValue = [[formatter2 stringFromDate:selectedDate]intValue];
                    
                    
                    if (year ==yearValue && month==monthValue && day== dateValue)
                    {
                        //[button setBackgroundColor:[UIColor blueColor]];
                    }
                }
                
                [button setButtonDate:buttonDate];
                
                button.enabled = YES;
                ++day;
            }
        }
    }
}


- (void)prevBtnPressed:(id)sender {
    if(currentMonth == 1) {
        currentMonth = 12;
        --currentYear;
    } else {
        --currentMonth;
    }
    
    [self updateCalendarForMonth:currentMonth forYear:currentYear];
    
    if ([self.delegate respondsToSelector:@selector(prevButtonPressed)]) {
        [self.delegate prevButtonPressed];
    }
}

- (void)nextBtnPressed:(id)sender {
    if(currentMonth == 12) {
        currentMonth = 1;
        ++currentYear;
    } else {
        ++currentMonth;
    }
    
    [self updateCalendarForMonth:currentMonth forYear:currentYear];
    
    if ([self.delegate respondsToSelector:@selector(nextButtonPressed)]) {
        [self.delegate nextButtonPressed];
    }
}




- (void)dayButtonPressed:(id)sender
{
	DayButton *dayButton = (DayButton *) sender;
	[self.delegate dayButtonPressed:dayButton];
    
}

#pragma mark - Get Data from database to show in textfilds

-(void)getdataFromSqlite
{
//    sqlite3 * database;
//    
//    NSString *databasename=@"PeriodsTracker.db";  // Your database Name.
//    
//    NSArray * documentpath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
//    
//    NSString * DocDir=[documentpath objectAtIndex:0];
//    
//    NSString * databasepath=[DocDir stringByAppendingPathComponent:databasename];
//    
//    if(sqlite3_open([databasepath UTF8String], &database) == SQLITE_OK)
//    {
//        const char *sqlStatement = "SELECT * FROM PeriodsDetails";  // Your Tablename
//        
//        sqlite3_stmt *compiledStatement;
//        
//        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
//        {
//            [PeriodsDetailsDict removeAllObjects];
//            
//            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
//            {
//                // [PeriodsDetailsArray addObject:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 0)]];
//                [PeriodsDetailsDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 1)] forKey:@"date"];
//                [PeriodsDetailsDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 2)] forKey:@"AvgPeriodDuration"];
//                [PeriodsDetailsDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 3)] forKey:@"AvgPeriodCycle"];
//                
//            }
//        }
//        sqlite3_finalize(compiledStatement);
//    }
//    sqlite3_close(database);
}
#pragma mark - Update Date, Perioda duration, Cycles to database

-(void)UpdateRecordsToDataBase
{
//    sqlite3_stmt *updateStmt=nil;
//    NSString *docsDir;
//    NSArray *dirPaths;
//    
//    // Get the documents directory
//    dirPaths = NSSearchPathForDirectoriesInDomains(
//                                                   NSDocumentDirectory, NSUserDomainMask, YES);
//    docsDir = dirPaths[0];
//    _databasePath = [[NSString alloc]
//                     initWithString: [docsDir stringByAppendingPathComponent:
//                                      @"PeriodsTracker.db"]];
//    const char *dbpath = [_databasePath UTF8String];
//    if(sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
//    {
//        const char *sql = "update MonthTable Set month = ?,year = ? Where id=1";
//        if(sqlite3_prepare_v2(_contactDB, sql, -1, &updateStmt, NULL)==SQLITE_OK)
//        {
//            sqlite3_bind_text(updateStmt, 1, [[NSString stringWithFormat:@"%ld",(long)currentMonth] UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(updateStmt, 2, [[NSString stringWithFormat:@"%ld",(long)currentYear] UTF8String], -1, SQLITE_TRANSIENT);
//            
//        }
//    }
//    char* errmsg;
//    sqlite3_exec(_contactDB, "COMMIT", NULL, NULL, &errmsg);
//    
//    if(SQLITE_DONE != sqlite3_step(updateStmt)){
//       // NSLog(@"Error while updating. %s", sqlite3_errmsg(_contactDB));
//    }
//    else
//    {
//        
//    }
//    sqlite3_finalize(updateStmt);
//    sqlite3_close(_contactDB);
    
}
#pragma mark - Get Month Value

-(void)GetMonthValue
{
//    sqlite3 * database;
//    
//    NSString *databasename=@"PeriodsTracker.db";  // Your database Name.
//    
//    NSArray * documentpath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
//    
//    NSString * DocDir=[documentpath objectAtIndex:0];
//    
//    NSString * databasepath=[DocDir stringByAppendingPathComponent:databasename];
//    
//    if(sqlite3_open([databasepath UTF8String], &database) == SQLITE_OK)
//    {
//        const char *sqlStatement = "SELECT * FROM MonthTable";  // Your Tablename
//        
//        sqlite3_stmt *compiledStatement;
//        
//        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
//        {
//            
//            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
//            {
//                [MonthValueFromDatabaseDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 1)] forKey:@"month"];
//                [MonthValueFromDatabaseDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 2)] forKey:@"year"];
//                
//                
//            }
//        }
//        sqlite3_finalize(compiledStatement);
//    }
//    sqlite3_close(database);
}

#pragma mark - Get Ovolution days form database

-(void)getOvolutionDays
{
//    sqlite3 * database;
//    
//    NSString *databasename=@"PeriodsTracker.db";  // Your database Name.
//    
//    NSArray * documentpath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
//    
//    NSString * DocDir=[documentpath objectAtIndex:0];
//    
//    NSString * databasepath=[DocDir stringByAppendingPathComponent:databasename];
//    
//    if(sqlite3_open([databasepath UTF8String], &database) == SQLITE_OK)
//    {
//        const char *sqlStatement = "SELECT * FROM Ovolution";  // Your Tablename
//        
//        sqlite3_stmt *compiledStatement;
//        
//        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
//        {
//            [OvolutionDict removeAllObjects];
//            
//            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
//            {
//                // [PeriodsDetailsArray addObject:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 0)]];
//                [OvolutionDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 1)] forKey:@"days"];
//            }
//        }
//        sqlite3_finalize(compiledStatement);
//    }
//    sqlite3_close(database);
}


#pragma mark - Get Heart Records From Database

-(void)getHeartRecords
{
//    sqlite3 * database;
//    
//    NSString *databasename=@"PeriodsTracker.db";  // Your database Name.
//    
//    NSArray * documentpath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
//    
//    NSString * DocDir=[documentpath objectAtIndex:0];
//    
//    NSString * databasepath=[DocDir stringByAppendingPathComponent:databasename];
//    
//    if(sqlite3_open([databasepath UTF8String], &database) == SQLITE_OK)
//    {
//        const char *sqlStatement = "SELECT * FROM Heart";  // Your Tablename
//        
//        sqlite3_stmt *compiledStatement;
//        
//        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
//        {
//            
//            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
//            {
//                // [PeriodsDetailsArray addObject:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 0)]];
//                NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
//                
//                [tempDict removeAllObjects];
//                
//                [tempDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 1)] forKey:@"type"];
//                [tempDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 2)] forKey:@"day"];
//                [tempDict setValue:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 3)] forKey:@"month"];
//
//                [heartRecordArray addObject:tempDict];
//                
//            }
//        }
//        sqlite3_finalize(compiledStatement);
//    }
//    sqlite3_close(database);
}
#pragma mark - Touch view delegates

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self performSelector:@selector(longTap) withObject:nil afterDelay:1.0];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                             selector:@selector(longTap) object:nil];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                             selector:@selector(longTap) object:nil];
//}
//-(void)longTap
//{
//}



- (void)dealloc {
	[calendar release];
	[dayButtons release];
    [super dealloc];
}


@end
