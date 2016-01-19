//
//  ViewController.m
//  FMDBSanbox
//
//  Created by Joe on 16/1/18.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (copy, nonatomic) NSString *path;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *createTableBtn = [[UIButton alloc] init];
    [createTableBtn setTitle:@"cretae table" forState:UIControlStateNormal];
    [createTableBtn addTarget:self action:@selector(createTableBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createTableBtn];
    
    [createTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *insertTableBtn = [[UIButton alloc] init];
    [insertTableBtn setTitle:@"insertTableBtn table" forState:UIControlStateNormal];
    [insertTableBtn addTarget:self action:@selector(insertTableBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insertTableBtn];
    
    [insertTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createTableBtn.mas_bottom).offset(20);
        make.left.right.mas_equalTo(createTableBtn);
        make.height.mas_equalTo(createTableBtn.mas_height);
    }];
    
    
    UIButton *queryTableBtn = [[UIButton alloc] init];
    [queryTableBtn setTitle:@"queryTableBtn table" forState:UIControlStateNormal];
    [queryTableBtn addTarget:self action:@selector(queryTableBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryTableBtn];
    
    [queryTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(insertTableBtn.mas_bottom).offset(20);
        make.left.right.mas_equalTo(insertTableBtn);
        make.height.mas_equalTo(insertTableBtn.mas_height);
    }];
    
    UIButton *clearTableBtn = [[UIButton alloc] init];
    [clearTableBtn setTitle:@"clearTableBtn table" forState:UIControlStateNormal];
    [clearTableBtn addTarget:self action:@selector(clearTableBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearTableBtn];
    
    [clearTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(queryTableBtn.mas_bottom).offset(20);
        make.left.right.mas_equalTo(queryTableBtn);
        make.height.mas_equalTo(queryTableBtn.mas_height);
    }];
    
    UIButton *multipleTableBtn = [[UIButton alloc] init];
    [multipleTableBtn setTitle:@"multipleTableBtn table" forState:UIControlStateNormal];
    [multipleTableBtn addTarget:self action:@selector(multipleTableBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:multipleTableBtn];
    
    [multipleTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clearTableBtn.mas_bottom).offset(20);
        make.left.right.mas_equalTo(clearTableBtn);
        make.height.mas_equalTo(clearTableBtn.mas_height);
    }];
    
//    NSString *doc = PATH_OF_DOCUMENT;
    self.path = [@"/Users/Joe/Desktop/P12" stringByAppendingPathComponent:@"users.sqlite"];
}


- (void)createTableBtn {
    debugMethod();
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.path] == NO) {
        FMDatabase *db = [FMDatabase databaseWithPath:self.path];
        if ([db open]) {
            NSString *sql = @"CREATE TABLE 'users'('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'name' VACHAR(32), 'age' VARCHAR(32), 'password' VARCHAR(32))";
            BOOL res = [db executeUpdate:sql];
            if (res) {
                debugLog(@"成功");
            }else {
                debugLog(@"失败");
            }
            [db close];
        } else {
            debugLog(@"打开 db 失败");
        }
    }
}

- (void)insertTableBtn {
   
    FMDatabase *db = [FMDatabase databaseWithPath:self.path];
    if ([db open]) {
        NSString *sql = @"INSERT INTO 'users' ('name', 'age', 'password') values (?, ?, ?)";
        BOOL res = [db executeUpdate:sql, @"test", @"18", @"123"];
        if (!res) {
            NSLog(@"插入数据失败");
        }
        [db close];
    }else {
        NSLog(@"打开数据库失败");
    }
}

- (void)queryTableBtn {
    FMDatabase *db = [FMDatabase databaseWithPath:self.path];
    if ([db open]) {
        NSString *sql = @"SELECT *FROM users";
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            NSLog(@"name %@", [set stringForColumn:@"name"]);
        }
        [db close];
    }
}

- (void)clearTableBtn {
    FMDatabase *db = [FMDatabase databaseWithPath:self.path];
    if ([db open]) {
        NSString *sql = @"delete from users";
        [db executeUpdate:sql];
        [db close];
    }
}

- (void)multipleTableBtn {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", NULL);
    
    static int index = 1;
    
    dispatch_async(queue1, ^{
        for (int i = 0; i < 60; i++) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sql = @"INSERT INTO users ('name', 'age') values (?, ?)";
                NSString *name = [NSString stringWithFormat:@"%d", index++];
                [db executeUpdate:sql, @"test", name];
            }];
        }
    });
    
    dispatch_async(queue2, ^{
        for (int i = 0; i < 60; i++) {
            for (int i = 0; i < 60; i++) {
                [queue inDatabase:^(FMDatabase *db) {
                    NSString *sql = @"INSERT INTO users ('name', 'age') values (?, ?)";
                    NSString *name = [NSString stringWithFormat:@"%d", index++];
                    [db executeUpdate:sql, @"test", name];
                }];
            }
        }
    });
    
    
}

@end
