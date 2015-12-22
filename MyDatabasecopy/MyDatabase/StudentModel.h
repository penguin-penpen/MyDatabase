//
//  Model.h
//  MyDatabase
//
//  Created by 杨京蕾 on 12/10/15.
//  Copyright (c) 2015 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface StudentModel : NSObject

#pragma mark number
@property NSString* number;

#pragma mark name
@property (nonatomic) NSString* name;

#pragma classnumber
@property (nonatomic) NSString* classnumber;

#pragma mark timeofbegin
@property (nonatomic) NSString* startTime;

#pragma mark timeofend
@property (nonatomic) NSString* endTime;

@property (nonatomic)  NSMutableDictionary* Info;
/*
-(NSString*)number;
-(NSString*)name;
-(NSString*)classnumber;
-(NSString*)startTime;
-(NSString*)endTime;
 */
-(StudentModel*) init;
-(NSMutableDictionary*)getInfoOfStudent;
-(StudentModel*) initWithNumber:(NSString*)number andName:(NSString*)name andClass:(NSString*)class;
-(void) updateInfoOfStudent:(StudentModel*)student withColumn:(NSString*)column value:(NSString*)value;
-(void) insertStudent:(StudentModel*)student toTable:(NSString*)table;
//-(void) deleteStudent:(StudentModel*)student fromTable:(NSString*)table;
@end
