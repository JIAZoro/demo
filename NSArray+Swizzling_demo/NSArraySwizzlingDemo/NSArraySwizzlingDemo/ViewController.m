//
//  ViewController.m
//  NSArraySwizzlingDemo
//
//  Created by jia on 2018/4/14.
//  Copyright © 2018年 jia. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+Swizzling.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"123",@"123", nil];
    NSLog(@"%@--",[array objectAtIndex:3]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
