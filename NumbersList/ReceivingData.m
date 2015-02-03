//
//  ReceivingData.m
//  NumbersList
//
//  Created by Юлия on 03.02.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import "ReceivingData.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@implementation ReceivingData{
    NSMutableArray* tempArray;
}

- (instancetype)init {
    return (ReceivingData *) [super init];
}


//Чтение JSON
-(void)getNumericData:(void (^)(NSMutableArray *array))callback{
    
    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"https://gist.githubusercontent.com/yumishina/5f9d9460a720b4dc3f19/raw/3af83523fb34de34040bad1995f11c06d7660487/numbers"]];
    // NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]; //синхронная загрузка
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               
                               tempArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError];
                               NSLog(@"Есть ли массив = %lu",(unsigned long)tempArray.count);////////////
                               callback(tempArray);
                           }];
}


@end
