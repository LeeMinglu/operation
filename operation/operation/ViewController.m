//
//  ViewController.m
//  operation
//
//  Created by 李明禄 on 16/1/3.
//  Copyright © 2016年 SocererGroup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSOperationQueue *queue;

@end


@implementation ViewController

//懒加载
- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return _queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self opDemo01];
//    [self opBlock];
    
    //线程间通信
//    [self thread_communication];
    
    //设置依赖
    [self dependcy];
   
}

- (void)dependcy {
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"登录");
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"付费");
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载");
    }];
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"通知");
    }];
    
    [op2 addDependency:op1];
    [op3 addDependency:op2];
    [op4 addDependency:op3];
    
    // waitUntilFinished NO 异步 YES 同步,不能将最后一个操作添加到操作数组中
    [self.queue addOperations:@[op1, op2, op3] waitUntilFinished:NO];
    
    [[NSOperationQueue mainQueue] addOperation:op4];
}



//线程间通信
- (void)thread_communication {
    [self.queue addOperationWithBlock:^{
        NSLog(@"耗时的操作");
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"更新UI %@", [NSThread currentThread]);
        }];
    }];
}

//nsBlockOperation
- (void)opBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    for (int i = 0; i < 10; i++) {
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"%@, %d", [NSThread currentThread], i);
        }];
        
        [queue addOperation:op];
    }
    
    
}



//NSInvocationOperation
- (void)opDemo01 {
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(demo:) object:@"hahah"];
    
//    当异步执行的时候取消start操作
//    [op start];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:op];
    
    
}

- (void)demo:(id)obj {
    NSLog(@"%@ , %@", [NSThread currentThread],  obj);
}

@end
