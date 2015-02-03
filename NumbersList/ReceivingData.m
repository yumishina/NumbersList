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






-(NSManagedObjectContext*)managedObjectContext{
    NSManagedObjectContext* context = nil;
    id delegate =[[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

//- (void)getNotificationData:(void (^)(NSMutableArray *array, NSError *error))callback {
//    [[[ManagersFactory sharedInstance] connectionManager] notify_listWithCallback:^(NSMutableDictionary *data, Error *error) {
//        if(!error) {
//            //  NSLog(@"notifications data = %@",data[@"notices"]);
//            NSMutableArray *notices = data[@"notices"];
//            [processor processObjects:notices withCallback:^(NSMutableArray *objects) {
//                callback(objects,nil);
//            }];
//            /*
//             [_converter convertObjects:data update:YES withCallback:^(id data) {
//             callback(data, nil);
//             }];
//             */
//        }else{
//            callback(data,error);
//        }
//    }];



@end
