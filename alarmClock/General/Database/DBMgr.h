//
//  DBMgr.h
//  chartTest
//
//  Created by tangwei on 16/2/22.
//  Copyright © 2016年 tangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBMgr : NSObject

//单例
+ (DBMgr *) sharedInstance;

- (void) add_alert_table_data:(NSString *) noticeId time:(NSString *) time repeat:(NSString *) repeat isOpen:(NSString *) open tab:(NSString *) tab;

- (void) update_alert_table_data:(NSString *) noticeId time:(NSString *) time repeat:(NSString *) repeat isOpen:(NSString *) open tab:(NSString *) tab;

- (void) del_table_data:(NSString *) noticeId;

- (NSMutableArray *) get_table_data;

@end
