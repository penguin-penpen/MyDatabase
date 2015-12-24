//
//  ViewController.m
//  MyDatabase
//
//  Created by 杨京蕾 on 12/13/15.
//  Copyright (c) 2015 yang. All rights reserved.
//

#import <AFNetworking.h>
#import <sqlite3.h>

#import "ViewController.h"
#import "StudentModel.h"
#import "SqliteOperation.h"

static NSString* const BaseURLString = @"http://www.raywenderlich.com/demos/weather_sample/";
@interface ViewController()
{
    NSArray* columnID;
    NSMutableArray* studentsInTable;
}
@property NSMutableArray* nameArray;
@property NSMutableArray* classnumberArray;
@property NSMutableArray* startTimeArray;
@property NSMutableArray* endTimeArray;
@property NSMutableArray* numberArray;
@property (assign, nonatomic) sqlite3* database;
@property NSString* table;
@property (strong, nonatomic) NSMutableArray* datasource;
@property NSArray* attributeNameArray;


@property (weak) IBOutlet NSTextField *NumberInputTextField;
@property (weak) IBOutlet NSTextField *NameInputTextField;
@property (weak) IBOutlet NSTextField *ClassnumberInputTextField;
@property (weak) IBOutlet NSTextField *RegistraitionTextField;

@property (unsafe_unretained) IBOutlet NSMatrix *StartOrEndMatrix;
@property (unsafe_unretained) IBOutlet NSMatrix *NameOrNumberMatrix;


//AFNetworking Test
@property NSDictionary* weather;
@end
@implementation ViewController

@synthesize InfoTable;



- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    studentsInTable = [[NSMutableArray alloc] init];
    _database = [SqliteOperation openDatabaseWithName:@"MyDatabase.db"];
    [self loadDatasourceAndFillTableArray:_database];
    NSLog(@"done");
    [self initColumnArray];
    NSLog(@"done3");
    self.table = @"student";
    self.attributeNameArray = [[NSArray alloc] initWithObjects:@"stuNumber",@"stuName",@"class",@"classBeginAt",@"classEndAt", nil];

 /*   columnID = [NSArray arrayWithObjects:@"number",@"name",@"classnumber",@"startTime",@"endTime", nil];
  */
    //NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    self.InfoTable.dataSource = self;
    self.InfoTable.delegate = self;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_datasource count];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger row;
    row = [self.InfoTable selectedRow];
    
    if (row == -1) {
        return;
    }else{
        self.NumberInputTextField.stringValue = [studentsInTable[row] number];
        self.NameInputTextField.stringValue = [studentsInTable[row] name];
        self.ClassnumberInputTextField.stringValue = [studentsInTable[row] classnumber];
        
        if ([[[self.NameOrNumberMatrix selectedCell] title] isEqualToString:@"按姓名"]) {
            self.RegistraitionTextField.stringValue = _datasource[row][1];
        }else{
            self.RegistraitionTextField.stringValue = _datasource[row][0];
        }
    }
}

/*
-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTextField* result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    
    if (result == nil) {
        result = [[NSTextField alloc] init];
        
        result.identifier = @"MyView";
    }
    result.stringValue = [self.studentsInTable objectAtIndex:row];
    return result;
}
*/
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([[tableColumn identifier] isEqualToString:@"number"]) {
        //NSLog(@"number,%ld",row);
        return [_numberArray objectAtIndex:row];
    }else if ([[tableColumn identifier] isEqualToString:@"name"]){
        //NSLog(@"name,%ld",row);
        return [_nameArray objectAtIndex:row];
    }else if ([[tableColumn identifier] isEqualToString:@"classnumber"]){
        //NSLog(@"classnumber,%ld",row);
        return [_classnumberArray objectAtIndex:row];
    }else if ([[tableColumn identifier] isEqualToString:@"startTime"]){
        //NSLog(@"startTime,%ld",row);
        return [_startTimeArray objectAtIndex:row];
    }else if([[tableColumn identifier] isEqualTo:@"endTime"]){
        //NSLog(@"endTime,%ld",row);
        return [_endTimeArray objectAtIndex:row];
    }
    return 0;
    
}

-(void)fullDataToStudentInTable
{
    int i = 0;
    NSString* text;
    for (i = 0; i < [_datasource count]; i++) {
        StudentModel* newStudent = [[StudentModel alloc] init];
        
        newStudent.number = @"NULL";
        newStudent.name = @"NULL";
        newStudent.classnumber = @"NULL";
        newStudent.startTime = @"NULL";
        newStudent.endTime = @"NULL";
        
         
        text = [NSString stringWithFormat:_datasource[i][0]];
        newStudent.number = text;
        text = [NSString stringWithFormat:_datasource[i][1]];
        newStudent.name = text;
        
        text = [NSString stringWithFormat:_datasource[i][2]];
        newStudent.classnumber = text;
        
        text = [NSString stringWithFormat:_datasource[i][3]];
        newStudent.startTime = text;
        
        text = [NSString stringWithFormat:_datasource[i][4]];
        newStudent.endTime = text;
        
        [studentsInTable addObject:newStudent];
        
        //[self.InfoTable scrollRowToVisible:[_studentsInTable count] - 1];
    }
    
}
/*
加载datasource并加载StudentInTable
 */
-(void) loadDatasourceAndFillTableArray:(sqlite3*)database
{
    NSString* queryInfo = @"SELECT * FROM student";
    _datasource = [SqliteOperation queryInfoWithDataBase:database WithSQL:queryInfo];
    [self fullDataToStudentInTable];

}

-(void)initColumnArray
{
    //[self.numberArray addObject:@"1"];
    _numberArray = [[NSMutableArray alloc] init];
    _nameArray = [[NSMutableArray alloc] init];
    _classnumberArray = [[NSMutableArray alloc] init];
    _startTimeArray = [[NSMutableArray alloc] init];
    _endTimeArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<[studentsInTable count]; i++) {
        [_numberArray addObject:[studentsInTable[i] number]];
        [_nameArray addObject:[studentsInTable[i] name]];
        [_classnumberArray addObject:[studentsInTable[i] classnumber]];
        [_startTimeArray addObject:[studentsInTable[i] startTime]];
        [_endTimeArray addObject:[studentsInTable[i] endTime]];
    }
    NSLog(@"done2");
}

-(void)updateColumnArray
{
    int originCount = _numberArray.count;
    int newCount = studentsInTable.count;
    for (int i = originCount; i < newCount; i++) {
        [_numberArray addObject:[studentsInTable[i] number]];
        [_nameArray addObject:[studentsInTable[i] name]];
        [_classnumberArray addObject:[studentsInTable[i] classnumber]];
        [_startTimeArray addObject:[studentsInTable[i] startTime]];
        [_endTimeArray addObject:[studentsInTable[i] endTime]];

    }
    NSLog(@"done4");
}
-(void)updateColumnArrayNamed:(NSString*)name atIndex:(NSInteger)changedColumn withValue:(NSString*)value
{
    if ([name isEqualToString:@"stuNumber"]) {
        _numberArray[changedColumn] = value;
    }else if ([name isEqualToString:@"stuName"]){
        _nameArray[changedColumn] = value;
    }else if ([name isEqualToString:@"class"]){
        _classnumberArray[changedColumn] = value;
    }else if ([name isEqualToString:@"classBeginAt"]){
        _startTimeArray[changedColumn] = value;
    }else{
        _endTimeArray[changedColumn] = value;
    }
}
-(void)deleteStudentFromColumnArrayAtIndex:(NSInteger)index
{
    
    [self.numberArray removeObjectAtIndex:index];
    [self.nameArray removeObjectAtIndex:index];
    [self.classnumberArray removeObjectAtIndex:index];
    [self.startTimeArray removeObjectAtIndex:index];
    [self.endTimeArray removeObjectAtIndex:index];
    
    
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

-(IBAction)addToSqlButton:(id)sender
{
    StudentModel* addedStudent = [[StudentModel alloc] initWithNumber:[self.NumberInputTextField stringValue] andName:[self.NameInputTextField stringValue] andClass:[self.ClassnumberInputTextField stringValue]];
    
    [studentsInTable addObject:addedStudent];
    [self insertStudentToSqlite:_database toTable:self.table];
    
    
    
    //NSLog(@"%@",);
}


- (IBAction)updateSqlButton:(id)sender
{
    NSString* fixedString = @"";
    NSInteger index = [self.InfoTable selectedRow];
    //弹出对话框，选择修改的项
    NSAlert* dialog = [[NSAlert alloc] init];
    
   
    [dialog setMessageText:@"请选择要修改的项目"];
    [dialog setInformativeText:@"注意！修改学生信息前请在表格中选中要修改的学生，再在相应文本框中修改！若未执行该操作，将出现错误！"];
    [dialog addButtonWithTitle:@"学号"];
    [dialog addButtonWithTitle:@"姓名"];
    [dialog addButtonWithTitle:@"班级"];
    [dialog addButtonWithTitle:@"取消"];
    [dialog setDelegate:self];
    
    enum {
        NSAlertFirstButtonReturn  = 0,
        NSAlertSecondButtonReturn  = 1,
        NSAlertThirdButtonReturn  = 2,
    };

    NSInteger result = [dialog runModal];
    
    if (result == 1000) {//number
        fixedString = [self.NumberInputTextField stringValue];
        
        [self updateStudentInSqlite:_database table:self.table atChangedColumn:0 withOriginValue:[self.NameInputTextField stringValue] atIndex:1 andNewString:fixedString];
        [self updateColumnArrayNamed:self.attributeNameArray[0] atIndex:index withValue:fixedString];
        _datasource[index][0] = fixedString;
    }else if (result == 1001){
        //NSLog(@"1");
        
        fixedString = [self.NameInputTextField stringValue];
        [self updateStudentInSqlite:_database table:self.table atChangedColumn:1 withOriginValue:[self.NumberInputTextField stringValue] atIndex:0 andNewString:fixedString];
        NSLog(@"doneChange");
        [self updateColumnArrayNamed:self.attributeNameArray[1] atIndex:index withValue:fixedString];
        _datasource[index][1] = fixedString;
        
    }else if(result == 1002){
        fixedString = [self.ClassnumberInputTextField stringValue];
        [self updateStudentInSqlite:_database table:self.table atChangedColumn:2 withOriginValue:[self.NumberInputTextField stringValue] atIndex:0 andNewString:fixedString];
        
        
        
        [self updateColumnArrayNamed:self.attributeNameArray[2] atIndex:index withValue:fixedString];
        _datasource[index][2] = fixedString;
    }
    
    [self fullDataToStudentInTable];
    [InfoTable reloadData];
}

- (IBAction)deleteSqlButton:(id)sender
{
    if (![[self.NumberInputTextField stringValue]isEqualToString:@""]) {
        [self deleteByNumber:[self.NumberInputTextField stringValue]];
    }else if(![[self.NameInputTextField stringValue] isEqualToString:@""]){
        [self deleteByName:[self.NameInputTextField stringValue]];
    }else{
        NSLog(@"Error");
    }
}

- (IBAction)RegistrationButton:(id)sender
{
    NSInteger changedColumn = 0;
    NSInteger Index = 0;
    NSInteger row = 0;
    //NSInteger selectedRowIndex = self.InfoTable.selectedRow;
  
    //Which column to change
    if ([[self.StartOrEndMatrix.selectedCell title] isEqualToString:@"上课"]) {
        changedColumn = 3;
    }else if([[self.StartOrEndMatrix.selectedCell title] isEqualToString:@"下课"]){
        changedColumn = 4;
    }
    
    if ([[self.NameOrNumberMatrix.selectedCell title] isEqualToString:@"按姓名"]) {
        Index = 1;
        row = [self.nameArray indexOfObject:[self.RegistraitionTextField stringValue]];
    }else if ([[self.NameOrNumberMatrix.selectedCell title] isEqualToString:@"按学号"]){
        Index = 0;
        row = [self.numberArray indexOfObject:[self.RegistraitionTextField stringValue]];
    }
    
    NSString* whereString = [[NSString alloc] initWithString:[self.RegistraitionTextField stringValue]];
    NSString* data = [self presentTime];
    
    [self updateStudentInSqlite:_database table:self.table atChangedColumn:changedColumn withOriginValue:whereString atIndex:Index andNewString:data];
    
    [self updateColumnArrayNamed:self.attributeNameArray[changedColumn] atIndex:changedColumn withValue:data];
    
    [self fullDataToStudentInTable];
    _datasource[row][changedColumn] = data;
    [self.InfoTable reloadData];
}
- (IBAction)conductButton:(id)sender {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://example.com/resources.json" parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {
        failure:NSLog(@"JSON:%@", responseObject);
    } failure:^(AFHTTPRequestOperation* operation, NSError* error){
        NSLog(@"Error: %@", error);
    }];
}


-(void)insertStudentToSqlite:(sqlite3*)database toTable:(NSString*)table
{
    NSString* preStatment = [[NSString alloc] initWithFormat:@"INSERT INTO %@ VALUES(?,?,?,?,?)",table];
    
    int counter = studentsInTable.count - 1;
    //NSInteger numberID = [[studentsInTable[counter] getInfoOfStudent][@"number"] integerValue];
    
    NSArray* dataToInsert = @[[self.NumberInputTextField stringValue],[self.NameInputTextField stringValue],[self.ClassnumberInputTextField stringValue],@"NULL",@"NULL"];
    
    BOOL result = [SqliteOperation insertDataWithDataBase:_database WithSQL:preStatment WithParameter:dataToInsert];
    if (result) {
        [self queryInfoNoValuesWithSqlite:_database];
    }else{
        NSLog(@"Insertion Failed");
    }
    [self updateColumnArray];
    [self.InfoTable reloadData];
    [self.InfoTable scrollRowToVisible:[studentsInTable count] - 1];
}


-(void)updateStudentInSqlite:(sqlite3*)database table:(NSString*)table atChangedColumn:(NSInteger)changedColumn withOriginValue:(NSString*)whereString atIndex:(NSInteger)index andNewString:(NSString*)data
{
    NSString* changedColumnString = [[NSString alloc] initWithString:self.attributeNameArray[changedColumn]];
    NSString* where = [[NSString alloc] initWithString:self.attributeNameArray[index]];
    NSString* preStatement = [[NSString alloc] initWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",table,changedColumnString,where];
    
    NSArray* dataArray = @[data,whereString];
    
    bool result = [SqliteOperation updateDataWithDataBase:_database WithSQL:preStatement WithParameter:dataArray];
    if (result) {
        [self queryInfoNoValuesWithSqlite:_database];
    }else{
        NSLog(@"Update Failed");
    }
}

-(void)deleteByNumber:(NSString*)number
{
    NSInteger index = 0;
    index = [self.numberArray indexOfObjectIdenticalTo:number];
    
    [self deleteStudentInSqlite:_database toTable:self.table ByNumber:number];
    [self deleteStudentFromColumnArrayAtIndex:index];
    [self fullDataToStudentInTable];
    [self.InfoTable reloadData];
    
}

-(void)deleteByName:(NSString*)name
{
    NSInteger index = [self.nameArray indexOfObject:name];
    [self deleteByName:name];
    [self deleteStudentFromColumnArrayAtIndex:index];
    [self fullDataToStudentInTable];
    [self.InfoTable reloadData];
}
-(void)deleteStudentInSqlite:(sqlite3*)database toTable:(NSString*)table ByNumber:(NSString*)number
{
    NSString* preStatement = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE stuNumber = ?",table];
    NSArray* data = @[number];
    BOOL result = [SqliteOperation deleteDataWithDataBase:database WithSQL:preStatement WithParameter:data];
    if (result) {
        [self queryInfoNoValuesWithSqlite:database];
    }else{
        NSLog(@"Delete Failed");
    }
    
}
-(void)deleteStudentInSqlite:(sqlite3*)database toTable:(NSString*)table ByName:(NSString*)name
{
    NSString* preStatement = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE stuName = ?",table];
    NSArray* data = @[name];
    BOOL result = [SqliteOperation deleteDataWithDataBase:database WithSQL:preStatement WithParameter:data];
    if (result) {
        [self queryInfoNoValuesWithSqlite:database];
    }else{
        NSLog(@"Delete Failed");
    }

}
- (void) queryInfoNoValuesWithSqlite: (sqlite3 *) database{
    NSString * qureyInfo = @"SELECT * FROM student";
    
    _datasource = [SqliteOperation queryInfoWithDataBase:database WithSQL:qureyInfo];
    
    [self.InfoTable reloadData];
}
-(NSString*)presentTime
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [DateFormatter stringFromDate:[NSDate date]];
}
@end


