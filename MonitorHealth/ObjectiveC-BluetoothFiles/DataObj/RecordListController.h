//
//  RecordListController.h
//  AllHealthChoice
//
//  Created by Apple on 06/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarRootViewController1.h"


@interface myTDTableCell : UITableViewCell{
    NSMutableArray *columns;
    NSInteger totalColumnWidth;
    TDSettingData *settingData;
}

@property (nonatomic, retain) TDSettingData *settingData;

- (void) addColumn:(CGFloat)position;
- (void) addColumnWithText:(NSMutableArray*) textArrayString width: (NSInteger) columnWidth needColor:(BOOL)need index: (int) index;

- (void) addColumnWithType:(NSMutableArray *)textArrayString dataValueArray:(NSMutableArray *)dataArrayString  indexOrder:(int) oroderIndex width:(NSInteger)columnWidth needColor:(BOOL)need;

- (void) addColumnWithButton:(NSMutableArray *) textArrayString index: (int) index width: (NSInteger) columnWidth height: (NSInteger) columnHeight needColor:(BOOL)need needUnderLine:(BOOL)underLine needSetAction:(BOOL) needSetAction maxShowRow: (int)maxShowRow isCategoryType:(BOOL)isCategoryType needCheckHILOW:(BOOL)checkHILOW;

- (void) clearColumns;

@end

@interface RecordListController : UIViewController<UITableViewDelegate, UIScrollViewDelegate>
{
    TabBarRootViewController1 *rootView;
    TDSettingData *settingData;
    NSMutableArray *measureDatas;
    NSMutableArray *arrayCellDataValue;
    NSMutableArray *arrayCellType;
    
    
    int totalCount;
    UITableView *tableview;
    TDRecordData *recordData;
    NSInteger iStart;
    NSInteger iCount;
    BOOL okToloadData;
    
    //UI For Pop-up View
    UIView *popupView;
    UIImageView *imgType;
    UIImageView *imgPulse;
    UIImageView *imgUploadStatus;
    UIImageView *imgLine;
    
    UIButton *btnAll;
    
    int currentID;
    NSMutableArray *noteList;
    int currentlocation;
}

@property(nonatomic, retain) TabBarRootViewController1 *rootView;
@property (nonatomic, retain) TDSettingData *settingData;
@property(nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSMutableArray *measureDatas;
@property (nonatomic, retain) TDRecordData *recordData;
@property (nonatomic, readwrite) NSInteger iStart;
@property (nonatomic, readwrite) NSInteger iCount;

//code for Pop-up View
@property(nonatomic, retain) IBOutlet UIView *popupView;
@property(nonatomic, retain) IBOutlet UIImageView *imgType;
@property(nonatomic, retain) IBOutlet UIImageView *imgPulse;
@property(nonatomic, retain) IBOutlet UIImageView *imgUploadStatus;
@property(nonatomic, retain) IBOutlet UIImageView *imgLine;
@property(nonatomic, retain) IBOutlet UIImageView *imgBGType;

@property(nonatomic, retain) IBOutlet UIButton *btnAll;

- (void) getDataFromDB:(int)type;


@end
