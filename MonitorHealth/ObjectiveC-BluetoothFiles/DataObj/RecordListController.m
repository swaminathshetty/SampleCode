 //
//  RecordListController.m
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import "RecordListController.h"
#import "TDDataContentProvider.h"
#import "TDSettingContentProvider.h"
#import "TDBPDataContentProvider.h"

#define TD_TABLE_CELL_HEIGHT 45
#define TD_TABLE_CELL_LABEL_HEIGHT 45.5
#define TD_TABLE_CELL_TYPE_COLUMN_WIDTH 40.5
#define TD_TABLE_CELL_VALUE_COLUMN_WIDTH 180.5

#define TD_TABLE_CELL_STATUS_COLUMN_WIDTH 30
#define TD_SHOW_RECORDS_IN_TABLE  8

#define VALUETYPE_GEN 0
#define VALUETYPE_AC 1
#define VALUETYPE_PC 2

@interface myTDTableCell(PrivateMethod)

- (NSInteger) getTotalColumnWidth;

@end

@implementation myTDTableCell(PrivateMethod)

- (NSInteger) getTotalColumnWidth
{
    NSInteger totalWidth = 0;
    for (int i=0; i<[columns count]; i++) {
        totalWidth += [(NSNumber *) [columns objectAtIndex:i] intValue];
    }
    
    return totalWidth;
}

@end

@implementation myTDTableCell
@synthesize settingData;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
    {
        columns = [[NSMutableArray alloc] init];
        totalColumnWidth = 0;
        settingData = [[TDSettingData alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [columns release];
    
    [super dealloc];
}

- (void) clearColumns
{
    totalColumnWidth = 0;
    [columns removeAllObjects];
    
    [self.backgroundView removeFromSuperview];
}

- (void)addColumn:(CGFloat)position
{
    totalColumnWidth += position;
    [columns addObject:[NSNumber numberWithFloat:totalColumnWidth]];
}



- (void) addColumnWithType:(NSMutableArray *)textArrayString dataValueArray:(NSMutableArray *)dataArrayString  indexOrder:(int) oroderIndex width:(NSInteger)columnWidth needColor:(BOOL)need
{
    NSLog(@"dataArrayString : %@",dataArrayString);

    if (textArrayString == nil || [textArrayString count] == 0)
    {
        return;
    }
    
    
    UILabel *theLabel;
    
    theLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalColumnWidth + 35, 10, 50, 24)];
    [theLabel setTextColor:[UIColor whiteColor]];
    
    switch ([[textArrayString objectAtIndex:0] integerValue]) {
        case 1: //BG
            [theLabel setText:@"BG"];
            [self.contentView addSubview:theLabel];
            break;
            
        case 2: //BP
            [theLabel setText:@"BP"];
            [self.contentView addSubview:theLabel];
            break;
            
        case 60: //TP
            [theLabel setText:@"TEMP"];
            [self.contentView addSubview:theLabel];
            break;
            
        case 7: //SPO2
            [theLabel setText:@"SPO2"];
            [self.contentView addSubview:theLabel];
            break;
            
        case 8: //WS
            [theLabel setText:@"WS"];
            [self.contentView addSubview:theLabel];
            break;
            
        default:
            break;
    }
    
    [theLabel release];
    
    // add a column
    //Swami
    //[self addColumn:columnWidth];
}






- (void) addColumnWithText:(NSMutableArray*) textArrayString width: (NSInteger) columnWidth needColor:(BOOL)need index:(int)index
{
    NSLog(@"textArrayString : %@",textArrayString);
    if (textArrayString == nil)
    {
        return;
    }
    
    // add a label
    for (int i=0; i< [textArrayString count]; i++)
    {
        UILabel *label = [[UILabel	alloc] initWithFrame:CGRectMake(TD_TABLE_CELL_TYPE_COLUMN_WIDTH + 10,  TD_TABLE_CELL_LABEL_HEIGHT * i, columnWidth - 5, TD_TABLE_CELL_LABEL_HEIGHT)];
        label.tag = index;
        label.font = [UIFont fontWithName:@"Arial" size:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor blackColor];
        [label setBackgroundColor:[UIColor clearColor]];
        
        if (need)
        {
            label.text = [textArrayString objectAtIndex:i];
        }else{
            label.text = [NSString stringWithFormat:@"%@", (NSString *) [textArrayString objectAtIndex:i]];
            self.contentView.backgroundColor = [UIColor clearColor];
        }
        
        [self.contentView addSubview:label];
        [label release];
    }
    
    // add a column
    //Swami
    //[self addColumn:columnWidth];
}



- (void) addColumnWithButton:(NSMutableArray *) textArrayString index: (int) index width: (NSInteger) columnWidth height: (NSInteger) columnHeight needColor:(BOOL)need needUnderLine:(BOOL)underLine needSetAction:(BOOL) needSetAction maxShowRow: (int)maxShowRow isCategoryType:(BOOL)isCategoryType needCheckHILOW:(BOOL)checkHILOW
{
    if (textArrayString == nil)
    {
        return;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    // add a button
    for (int i=0; i< [textArrayString count]; i++)
    {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        myButton = [[UIButton alloc] initWithFrame:CGRectMake(TD_TABLE_CELL_TYPE_COLUMN_WIDTH-20,  (TD_TABLE_CELL_LABEL_HEIGHT * i), columnWidth - 1, columnHeight)];
        myButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.0];
        
        NSArray *strSplit = [[textArrayString objectAtIndex:i] componentsSeparatedByString:@" / "];
        if ([strSplit count] >= 3) { //BP
            
            float systolicValue = [[strSplit objectAtIndex:0] floatValue];
            float diastoicValue = [[strSplit objectAtIndex:1] floatValue];
            float pluseValue = [[strSplit objectAtIndex:2] floatValue];
            
            
            [formatter setFormatWidth:3];
            [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
            [formatter setPaddingCharacter:@" "];
            [formatter setMinimumFractionDigits:0];
            if (systolicValue == 0 && diastoicValue == 0) {
                [myButton setTitle:@"  -- /   --" forState:UIControlStateNormal];
            }else if (systolicValue == 0 && diastoicValue > 0) {
                [myButton setTitle:[NSString stringWithFormat:@"  -- / %@" , [formatter stringFromNumber:[NSNumber numberWithDouble:diastoicValue]]] forState:UIControlStateNormal];
            }else if (diastoicValue == 0 && systolicValue > 0) {
                [myButton setTitle:[NSString stringWithFormat:@"%@ /   --" , [formatter stringFromNumber:[NSNumber numberWithDouble:systolicValue]]] forState:UIControlStateNormal];
            }else{
                [myButton setTitle:[NSString stringWithFormat:@"%@ / %@", [formatter stringFromNumber:[NSNumber numberWithDouble:systolicValue]] , [formatter stringFromNumber:[NSNumber numberWithDouble:diastoicValue]]] forState:UIControlStateNormal];
            }
            
            
            NSString *finalTitle = [[myButton titleLabel] text];
            [myButton setTitle:[NSString stringWithFormat:@"%@   %.0f", finalTitle  ,pluseValue] forState:UIControlStateNormal];
            
            
        }
        else if ([strSplit count] >= 2) {//SPO2
            float pulseValue = [[strSplit objectAtIndex:0] floatValue];
            float SPO2Value = [[strSplit objectAtIndex:1] floatValue];
            [formatter setFormatWidth:3];
            [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
            [formatter setPaddingCharacter:@" "];
            [formatter setMinimumFractionDigits:0];
            if (pulseValue == 0 && SPO2Value == 0) {
                [myButton setTitle:@"  -- /   --" forState:UIControlStateNormal];
            }else if (SPO2Value == 0 && pulseValue > 0) {
                [myButton setTitle:[NSString stringWithFormat:@"  -- / %@" , [formatter stringFromNumber:[NSNumber numberWithDouble:pulseValue]]] forState:UIControlStateNormal];
            }else if (pulseValue == 0 && SPO2Value > 0) {
                [myButton setTitle:[NSString stringWithFormat:@"%@ /   --" , [formatter stringFromNumber:[NSNumber numberWithDouble:SPO2Value]]] forState:UIControlStateNormal];
            }else{
                [myButton setTitle:[NSString stringWithFormat:@"%@ / %@", [formatter stringFromNumber:[NSNumber numberWithDouble:SPO2Value]] , [formatter stringFromNumber:[NSNumber numberWithDouble:pulseValue]]] forState:UIControlStateNormal];
                //NSLog(@"SPO2Value/pulseValue : %@/%@",[formatter stringFromNumber:[NSNumber numberWithDouble:SPO2Value]],[formatter stringFromNumber:[NSNumber numberWithDouble:pulseValue]]);
            }
            NSString *finalTitle = [[myButton titleLabel] text];
            [myButton setTitle:[NSString stringWithFormat:@"%@", finalTitle] forState:UIControlStateNormal];
            //NSLog(@"SPO2Value/pulseValue : %@",finalTitle);

        }
        else if ([strSplit count] == 1) {//BG, WS
            strSplit = [[textArrayString objectAtIndex:i] componentsSeparatedByString:@", "];
            if ([strSplit count] == 2) {
                float fValue = 0;
                switch ([[strSplit objectAtIndex:1] intValue]) {
                    case 1: //BG
                        fValue = [[strSplit objectAtIndex:0] floatValue];
                        [myButton setTitle:[TD_Check_Glu_HI_LOW Get_GluValue_DISPLAY:fValue valueType:settingData] forState:UIControlStateNormal];
                        break;
                        
                    case 60: //Temp
                        fValue = [[strSplit objectAtIndex:0] floatValue];
                        [myButton setTitle:[TD_check_Tmp_HI_LOW Get_TmpValue_HI_LO_DISPLAY:fValue valueType:settingData] forState:UIControlStateNormal];
                        break;
                        
                    case 8: //WS
                    {
                        NSMutableString *mstring = [NSMutableString stringWithString:[strSplit objectAtIndex:0]];
                        NSRange wholeShebang = NSMakeRange(0, [[strSplit objectAtIndex:0] length]);
                        [mstring replaceOccurrencesOfString:@"," withString:@"." options:0 range: wholeShebang];
                        
                        fValue = [mstring floatValue];
                        
                        [formatter setMinimumFractionDigits:1];
                        if (fValue <= 0) {
                            [myButton setTitle:[NSString stringWithFormat:@"--"] forState:UIControlStateNormal];
                        }else{
                            [myButton setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:fValue]]] forState:UIControlStateNormal];
                        }
                        
                        break;
                    }
                    default:
                        break;
                }
            }
        }
        
        myButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        myButton.backgroundColor = [UIColor clearColor];
        
        [myButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        myButton.userInteractionEnabled = NO;
        
        if (!need)
        {
            myButton.backgroundColor = [UIColor clearColor];
            
        }
        [self.contentView addSubview:myButton];
        [myButton release];
    }
    
    [formatter release];
    
    // add a column
    //Swami
    //[self addColumn:columnWidth];
}

//Draw Grid line
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    //CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.4);
    // Add the vertical lines
    CGContextSetLineWidth(context, 0.5);
    
    CGContextMoveToPoint(context, (TD_TABLE_CELL_TYPE_COLUMN_WIDTH+TD_TABLE_CELL_VALUE_COLUMN_WIDTH - 15 +0.5), 9);
    CGContextAddLineToPoint(context, (TD_TABLE_CELL_TYPE_COLUMN_WIDTH+TD_TABLE_CELL_VALUE_COLUMN_WIDTH - 15 +0.5), rect.size.height-9);
    
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 1, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width - 1, rect.size.height);
    CGContextStrokePath(context);
}

@end

#pragma mark -
#pragma mark implementation RecordListController

@interface RecordListController ()

@end

@implementation RecordListController

@synthesize rootView;
@synthesize measureDatas;
@synthesize tableview;
@synthesize recordData;
@synthesize iStart;
@synthesize iCount;
@synthesize settingData;


//popup view
@synthesize popupView;
@synthesize imgType;
@synthesize imgPulse;
@synthesize imgLine;
@synthesize imgBGType;
@synthesize imgUploadStatus;

@synthesize btnAll;


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
    [rootView release];
    [measureDatas release];
    [tableview release];
    [recordData release];
    [settingData release];
    [popupView release];
    [imgType release];
    [imgPulse release];
    [imgLine release];
    [imgUploadStatus release];
    [imgBGType release];
    
    [btnAll release];
    
    [arrayCellDataValue release];
    [arrayCellType release];
    
    
    [super dealloc];
}

- (void) getDataFromDB:(int)type
{
    TDDataContentProvider *provider = [[TDDataContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    
    totalCount = (int)[provider getDataCounts:type];
    self.measureDatas = [[NSMutableArray alloc] initWithArray: [provider getDataLimitCounts:0 andCounts:totalCount whichType:type]];
    [provider release];
    
    // reset vars
    [arrayCellDataValue removeAllObjects];
    [arrayCellType removeAllObjects];
    
    // prepare datas of table
    NSMutableArray *colType;
    NSMutableArray *colDataValue;
    
    // body
    if (totalCount > 0) {
        TDRecordData *data = nil;
        for(int i=0; i<totalCount ; i++)
        {
            colType = [[NSMutableArray alloc] init];
            colDataValue = [[NSMutableArray alloc] init];
            
            data = [self.measureDatas objectAtIndex:i];
            
            [colType addObject:[NSString stringWithFormat:@"%d",data.mType]];
            
            switch (data.mType) {
                case 1: //BG
                    [colDataValue addObject:[NSString stringWithFormat:@"%.0f, %d- BloodGlucose",data.value1, data.mType]];
                    break;
                    
                case 2: //BP
                    [colDataValue addObject:[NSString stringWithFormat:@"%.0f / %.0f / %.0f / %.0f- BP", data.value1, data.value2,data.value3,data.value6]];//value = ihb
                    NSLog(@"Initial BP Values : %.0f / %.0f / %.0f / %.0f",data.value1, data.value2,data.value3,data.value6);

                    break;
                    
                case 60: //Temp
                    [colDataValue addObject:[NSString stringWithFormat:@"%f, %d- Temp", data.value1, data.mType]];
                    NSLog(@"Initial Temp Values : %f / %d",data.value1, data.mType);
                    break;
                    
                case 7: //SO2
                    [colDataValue addObject:[NSString stringWithFormat:@"%.0f / %.0f- SPO2", data.value1, data.value3]];
                    NSLog(@"Initial SO2 Values : %.0f / %.0f",data.value1, data.value3);
                    break;
                    
                case 8: //WS
                    [colDataValue addObject:[NSString stringWithFormat:@"%f, %d- Weight", data.value1, data.mType]];
                    break;
                    
                default:
                    break;
            }
            
            
            [arrayCellType addObject:colType];
            [arrayCellDataValue addObject:colDataValue];
            
            [colType release];
            [colDataValue release];
        }
        
        [self performSelectorOnMainThread:@selector(reloadTabelData) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(reloadTabelData) withObject:nil waitUntilDone:NO];
    }
}

- (void) reloadTabelData
{
    NSLog(@"arrayCellDataValue : %@",arrayCellDataValue);
    
    okToloadData = YES;
    [self.tableview reloadData];
    int padcount = TD_TABLE_CELL_HEIGHT - ((int)tableview.contentOffset.y % TD_TABLE_CELL_HEIGHT);
    
    if (padcount < TD_TABLE_CELL_HEIGHT) {
        [tableview setContentOffset: CGPointMake(0, 0) animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (totalCount > 0) {
        [self performSelectorInBackground:@selector(getDataFromDB:) withObject:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    okToloadData = NO;
    currentlocation = 1;
    
    TDSettingContentProvider *settingProvider = [[TDSettingContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    self.settingData = [settingProvider getSettingData];
    [settingProvider release];
    
    TDDataContentProvider *provider = [[TDDataContentProvider alloc] initWithDatabaseName:@"TDLink.db"];
    
    totalCount = (int)[provider getDataCounts:0];
    [provider release];
    
    // init arrays
    arrayCellDataValue = [[NSMutableArray alloc] init];
    arrayCellType = [[NSMutableArray alloc] init];
    [self.tableview reloadData];
    
    // Turn off the tableView's default lines because we are drawing them all ourself
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IS_IPHONE_5) {
        NSLog(@"IS_IPHONE_5");
        if (totalCount > 9) {
            return totalCount;
        }else {
            return 9;
        }
    }else{
        NSLog(@"NOT IPHONE_5");

        if (totalCount > 7) {
            return totalCount;
        }else {
            return 7;
        }
    }
    
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TD_TABLE_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *kSourceCellID = @"mySourceCellID";
    
    UITableViewCell * cell = (UITableViewCell *)[self.tableview dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    
    NSString * value;
    if (indexPath.row < arrayCellDataValue.count)
    {
        NSLog(@"Array count : %@",[arrayCellDataValue objectAtIndex:indexPath.row]);
        if ([[arrayCellDataValue objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
        {
            NSLog(@"String Type ");
        }
        else if ([[arrayCellDataValue objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"NSDictionary Type ");
        }
        else if ([[arrayCellDataValue objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]])
        {
            NSLog(@"NSArray Type ");
            NSArray * arrayValue = [arrayCellDataValue objectAtIndex:indexPath.row];
            NSLog(@"arrayValue count : %lu",(unsigned long)arrayValue.count);
            value = [arrayValue objectAtIndex:0];
            NSLog(@"value : %@",value);
        }
        NSLog(@"value : %@",value);

        cell.textLabel.text = [NSString stringWithFormat:@"%@",value];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
        
    /*cell.settingData = self.settingData;
    
    //if (indexPath.row % 2 == 0) {
    cell.contentView.backgroundColor = [UIColor clearColor];
    //}
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (totalCount > 0 && indexPath.row < totalCount && okToloadData) {
        
        NSLog(@"Cell arrayCellDataValue : %@",[arrayCellDataValue objectAtIndex:indexPath.row]);

        
        [cell addColumnWithButton:[arrayCellDataValue objectAtIndex:indexPath.row] index:0 width:TD_TABLE_CELL_VALUE_COLUMN_WIDTH height:TD_TABLE_CELL_HEIGHT needColor:YES needUnderLine:NO needSetAction:YES maxShowRow:2 isCategoryType:NO needCheckHILOW:YES];
        
        [cell addColumnWithType:[arrayCellType objectAtIndex:indexPath.row] dataValueArray:[arrayCellDataValue  objectAtIndex:indexPath.row] indexOrder:(int)indexPath.row width:TD_TABLE_CELL_TYPE_COLUMN_WIDTH needColor:NO];
    }*/
    
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        int padcount = TD_TABLE_CELL_HEIGHT - ((int)tableview.contentOffset.y % TD_TABLE_CELL_HEIGHT);
        
        if (padcount < TD_TABLE_CELL_HEIGHT) {
            [tableview setContentOffset: CGPointMake(0, tableview.contentOffset.y + padcount) animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int padcount = TD_TABLE_CELL_HEIGHT - ((int)tableview.contentOffset.y % TD_TABLE_CELL_HEIGHT);
    
    if (padcount < TD_TABLE_CELL_HEIGHT) {
        [tableview setContentOffset: CGPointMake(0, tableview.contentOffset.y + padcount) animated:YES];
    }
}


@end
