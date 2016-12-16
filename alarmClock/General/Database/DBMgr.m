//
//  DBMgr.m
//  chartTest
//
//  Created by tangwei on 16/2/22.
//  Copyright © 2016年 tangwei. All rights reserved.
//

#import "DBMgr.h"
#import "FMDB.h"

#define db_tb_alert_index    @"table_alert"

@interface DBMgr()

@property (nonatomic) NSString  *m_path;

@end

@implementation DBMgr

+ (DBMgr *) sharedInstance
{
    static DBMgr *_dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dbManager = [[self alloc] init];
    });
    return _dbManager;
}

- (id) init
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    self.m_path = [documentDirectory stringByAppendingPathComponent:@"alertCustom.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.m_path];
    
    if (![db open]) {
        NSLog(@"db could not open.");
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }

    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (noticeId text primary key, time text, repeat text, isOpen text, tab text)", db_tb_alert_index];
    if (![db executeUpdate:sql]) {
        if ([db hadError]) {
            NSLog(@"init Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
    }
    
    [db close];
    
    return self;
}

- (void) add_alert_table_data:(NSString *) noticeId time:(NSString *) time repeat:(NSString *) repeat isOpen:(NSString *) open tab:(NSString *) tab
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.m_path];

    if (![db open]) {
        NSLog(@"db could not open. add_day_table_data");
    }

    [db beginTransaction];

    NSString *sql = [NSString stringWithFormat:@"insert into %@ (noticeId, time, repeat, isOpen, tab) values ('%@', '%@', '%@', '%@', '%@')", db_tb_alert_index, noticeId, time, repeat, open, tab];

    if (![db executeUpdate:sql])
    {
        if ([db hadError]) {
            NSLog(@"add_day_table_data Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
    }

    [db commit];
    
    [db close];
}

- (void) update_alert_table_data:(NSString *) noticeId time:(NSString *) time repeat:(NSString *) repeat isOpen:(NSString *) open tab:(NSString *) tab
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.m_path];
    
    if (![db open]) {
        NSLog(@"db could not open. del_day_table_all_data");
    }
    
    [db beginTransaction];
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set time = '%@', repeat = '%@', isOpen = '%@', tab = '%@' where noticeId = '%@'", db_tb_alert_index, time, repeat, open, tab, noticeId];
    
    if (![db executeUpdate:sql])
    {
        if ([db hadError]) {
            NSLog(@"update Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
    }
    
    [db commit];
    
    [db close];
}

- (void) del_table_data:(NSString *) noticeId
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.m_path];

    if (![db open]) {
        NSLog(@"db could not open. del_day_table_all_data");
    }

    [db beginTransaction];

    NSString *sql = [NSString stringWithFormat:@"delete from %@ where noticeId = '%@'", db_tb_alert_index, noticeId];

    if (![db executeUpdate:sql])
    {
        if ([db hadError]) {
            NSLog(@"del_day_table_all_data Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
    }
    
    [db commit];
    
    [db close];
}

- (NSMutableArray *) get_table_data
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.m_path];

    if (![db open]) {
        NSLog(@"db could not open. get_day_table_data");
    }

    NSString *sql = [NSString stringWithFormat:@"select * from %@", db_tb_alert_index];// order by noticeId asc

    NSMutableArray *arrayData = [NSMutableArray array];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSString *noticeId = [rs stringForColumn:@"noticeId"];
        NSString *time = [rs stringForColumn:@"time"];
        NSString *repeat = [rs stringForColumn:@"repeat"];
        NSString *isOpen = [rs stringForColumn:@"isOpen"];
        NSString *tab = [rs stringForColumn:@"tab"];

        [dic setValue:noticeId forKey:@"noticeId"];
        [dic setValue:time forKey:@"noticeTime"];
        [dic setValue:repeat forKey:@"noticeRepeat"];
        [dic setValue:isOpen forKey:@"isOpen"];
        [dic setValue:tab forKey:@"noticeTab"];
        
        [arrayData addObject:dic];
    }

    [rs close];
    [db close];
    
    return arrayData;
}

- (id) string_to_json:(NSString *) _str
{
    if (_str == nil) {
        return nil;
    }
    
    NSData *data = [[_str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonObject;
}

- (NSString *) json_to_string:(id) _data
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *reponse = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return reponse;
}

@end
