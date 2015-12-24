//
//  ViewController.h
//  MyDatabase
//
//  Created by 杨京蕾 on 12/13/15.
//  Copyright (c) 2015 yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StudentModel.h"
#import <AFNetworking.h>

@interface ViewController : NSViewController <NSTableViewDelegate,NSTableViewDataSource>



@property sqlite3* MyDatabase;
@property (weak) IBOutlet NSTableView *InfoTable;

- (IBAction)addToSqlButton:(id)sender;

@end
