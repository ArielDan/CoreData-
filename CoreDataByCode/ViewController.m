//
//  ViewController.m
//  CoreDataByCode
//
//  Created by csip on 16/2/13.
//  Copyright © 2016年 ariel. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Person.h"
#import "Salary.h"

@interface ViewController ()

@property (nonatomic,strong) NSManagedObjectContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    
    //添加持久化存储 上下文关联数据库
    //模型文件 描述表结构的文件
    //bundles传nil 会从主bundle加载所有的模型文件,把里面表结构都放在一个数据库文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //持久化存储调用器 ,把数据保存到一个文件，并非内存
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //设置数据库路径、名字
    //NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"company.sqlite"];
    
    //告诉coredate数据存储在一个sqlite文件
    NSError *error = nil;
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
    
    context.persistentStoreCoordinator = store;
    
    _context = context;
    
}
- (IBAction)addInformation:(id)sender {
    //创建员工对象
    //用coredata创建对象不能使用下面的方法
    //Employee *emp = [[Employee alloc] init];
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:_context];
    
    person.name = @"A";
    person.num = @"001";
    
    //保存信息
    NSError *error = nil;
    
    [_context save:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
    NSLog(@"添加信息");
}
- (IBAction)getInformation:(id)sender {
    //创建请求对象，指定查找表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //设置过滤条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",@"A"];
    request.predicate = pre;
    
    //设置排序  //YES代表升序 NO 降序
    //NSSortDescriptor *dataSort = [NSSortDescriptor sortDescriptorWithKey:@"birthday" ascending:NO];
   // request.sortDescriptors = @[dataSort];
    
    //执行请求
    NSError *error = nil;
    
    NSArray *pers = [_context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error");
    }
    
    //遍历
    for (Person *per in pers) {
        NSLog(@"%@ %@",per.num,per.name);
    }
    
    NSLog(@"读取信息");
}
- (IBAction)changeInformation:(id)sender {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //设置过滤条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",@"A"];
    request.predicate = pre;
    
    //执行请求
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    
    //更新
    for (Person *per in emps) {
        per.num = @"100";
    }
    //保存
    NSError *error = nil;
    
    [_context save:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
    
    NSLog(@"更改数据");
}
- (IBAction)deleteInformation:(id)sender {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",@"A"];
    request.predicate = pre;
    
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    
    for (Person *per in emps) {
        [_context deleteObject:per];
    }
    
    //保存
    NSError *error = nil;
    
    [_context save:&error];
    
    NSLog(@"删除数据");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
