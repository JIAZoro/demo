//
//  NSArray+Swizzling.m
//  NSArraySwizzlingDemo
//
//  Created by jia on 2018/4/14.
//  Copyright © 2018年 jia. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import <objc/runtime.h>

@implementation NSArray (Swizzling)
+ (void)load{
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //__NSArrayI 是不可变数组
        //__NSArrayM 是可变数组
        //此处为使用objectAtIndex：方法造成的Crash；例：[array objectAtIndex:3];
        Method fromMethod_I = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method toMethod_I = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(jw_objectAtIndex:));
        method_exchangeImplementations(fromMethod_I, toMethod_I);
        
        //此处为使用array[2]造成的Crash；
        Method fromMethod_I_Sub = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:));
        Method toMethod_I_Sub = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(jw_objectAtIndexedSubscript:));
        method_exchangeImplementations(fromMethod_I_Sub, toMethod_I_Sub);
        
        Method fromMethod_M = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
        Method toMethod_M = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(jw_objectAtIndex_M:));
        method_exchangeImplementations(fromMethod_M, toMethod_M);
        
        Method fromMethod_M_Sub = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndexedSubscript:));
        Method toMethod_M_Sub = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(jw_objectAtIndex_M_Sub:));
        method_exchangeImplementations(fromMethod_M_Sub, toMethod_M_Sub);
    });
}

- (id)jw_objectAtIndex:(NSInteger)index{
    if (index < self.count) {
        return [self jw_objectAtIndex:index];
    }else{
        @try {
            return [self jw_objectAtIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
            return nil;
        }
        return nil;
    }
}
- (id)jw_objectAtIndexedSubscript:(NSInteger)index{
    if (index < self.count) {
        return [self jw_objectAtIndexedSubscript:index];
    }else{
        @try {
            return [self jw_objectAtIndexedSubscript:index];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
            return nil;
        }
        return nil;
    }
}
- (id)jw_objectAtIndex_M:(NSInteger)index{
    if (index < self.count) {
        return [self jw_objectAtIndex_M:index];
    }else{
        @try {
            return [self jw_objectAtIndex_M:index];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
            return nil;
        }
        return nil;
    }
    
}
- (id)jw_objectAtIndex_M_Sub:(NSInteger)index{
    if (index < self.count) {
        return [self jw_objectAtIndex_M_Sub:index];
    }else{
        @try {
            return [self jw_objectAtIndex_M_Sub:index];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
            return nil;
        }
        return nil;
    }
}
@end
