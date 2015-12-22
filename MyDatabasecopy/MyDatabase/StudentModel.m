//
//  Model.m
//  MyDatabase
//
//  Created by 杨京蕾 on 12/10/15.
//  Copyright (c) 2015 yang. All rights reserved.
//
#import "StudentModel.h"
#import "SqliteOperation.h"
#import <sqlite3.h>

@interface StudentModel()
@property sqlite3* MyDatabase;

@end

@implementation StudentModel

/*
-(NSString*)number
{
    return self.number;
}
-(NSString*)name
{
    return self.name;
}
-(NSString*)classnumber
{
    return self.classnumber;
}
-(NSString*)beginTime
{
    return self.beginTime;
}
-(NSString*)endTime
{
    return self.endTime;
}
 */
-(NSString*)table
{
    NSString* table = @"student";
    return table;
}
-(NSMutableDictionary*)Info
{
    NSArray* objects = [NSArray arrayWithObjects:self.number,self.name,self.class,self.startTime,self.endTime, nil];
    NSArray* keys = [NSArray arrayWithObjects:@"number",@"name",@"classnumber",@"startTime",@"endTime", nil];
    NSMutableDictionary* Info = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    return Info;
}

-(sqlite3*)getDatabase
{
    _MyDatabase = [SqliteOperation openDatabaseWithName:@"MyDatabase.db"];
    return _MyDatabase;
}

-(StudentModel*) init
{
    self = [super init];
    if (self) {
        
        self.number = @"NULL";
        self.name = @"NULL";
        self.classnumber = @"NULL";
        self.startTime = @"NULL";
        self.endTime = @"NULL";
    }
    
    return self;
}

-(StudentModel*) initWithNumber:(NSString*)number andName:(NSString*)name andClass:(NSString *)class
{
    self = [super init];
    if (self) {
        self.number = number;
        self.name = name;
        self.classnumber = class;
        self.startTime = @"NULL";
        self.endTime = @"NULL";
        _Info = [self Info];
        _MyDatabase = [self getDatabase];
    }
    return self;
}

-(NSMutableDictionary*)getInfoOfStudent
{
    return self.Info;
}
-(void) updateInfoOfStudent:(StudentModel *)student withColumn:(NSString*)column value:(NSString*)value
{
    NSString* sql = [SqliteOperation queryUpdateColumn:column inTable:[self table] withValue:value using:column ofValue:self.Info[column]];
    [SqliteOperation executeSQLWithDataBase:_MyDatabase WithSQL:sql];
}
-(void)insertStudent:(StudentModel *)student toTable:(NSString *)table
{
    NSString* sql = [SqliteOperation queryInsertIntoTable:[self table] withNumber:self.number andName:student.name andclassnumber:student.classnumber];
    [SqliteOperation executeSQLWithDataBase:_MyDatabase WithSQL:sql];
}
                     
@end
