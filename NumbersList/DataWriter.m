//
//  DataWriter.m
//  NumbersList
//
//  Created by Юлия on 03.02.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import "DataWriter.h"
#import "ReceivingData.h"
#import "Numbers.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@implementation DataWriter{
    NSMutableArray* tempArray;
}

- (instancetype)init {
    return (DataWriter *) [super init];
}

-(void)saveDataInCoreData:(void (^)())callback{
    ReceivingData* saveData = [[ReceivingData alloc] init];
    //Получение данных по JSON
    [saveData getNumericData:^(NSMutableArray *array) {
        
        
        //Сохранение данных в CoreData
        for (int i = 0; i < array.count; i++) {
            NSLog(@"порядковый номер =  %d",i);
            NSManagedObjectContext* context = [self managedObjectContext];
            // NSManagedObject* newNumbers = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers" inManagedObjectContext:context];
            // [newNumbers setValue:[NSString stringWithFormat:@"%d", i] forKey:@"sequenceNumber"];
            // [newNumbers setValue:[NSString stringWithFormat:@"%@", [array objectAtIndex:i]] forKey:@"number"];
            
            Numbers *newNumber = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers"
                                                               inManagedObjectContext:context];
            
            newNumber.sequenceNumber = [NSString stringWithFormat:@"%d", i];
            newNumber.number = [NSString stringWithFormat:@"%@", [array objectAtIndex:i]];
            
            NSError* error = nil;
            if (![context save: &error]) {
                NSLog(@"Can't save! %@ %@",error, [error localizedDescription]);
            }
            
        }
        callback();
        NSLog(@"arrayarrayarray=%lu",(unsigned long)array.count);
    }];
    

}

-(void)saveDataInCoreData{
    ReceivingData* saveData = [[ReceivingData alloc] init];
    //Получение данных по JSON
    [saveData getNumericData:^(NSMutableArray *array) {
        
        
        //Сохранение данных в CoreData
        for (int i = 0; i < array.count; i++) {
            NSLog(@"порядковый номер =  %d",i);
            NSManagedObjectContext* context = [self managedObjectContext];
            // NSManagedObject* newNumbers = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers" inManagedObjectContext:context];
            // [newNumbers setValue:[NSString stringWithFormat:@"%d", i] forKey:@"sequenceNumber"];
            // [newNumbers setValue:[NSString stringWithFormat:@"%@", [array objectAtIndex:i]] forKey:@"number"];
            
            Numbers *newNumber = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers"
                                                               inManagedObjectContext:context];
            
            newNumber.sequenceNumber = [NSString stringWithFormat:@"%d", i];
            newNumber.number = [NSString stringWithFormat:@"%@", [array objectAtIndex:i]];
            
            NSError* error = nil;
            if (![context save: &error]) {
                NSLog(@"Can't save! %@ %@",error, [error localizedDescription]);
            }
        }
        
        NSLog(@"arrayarrayarray=%lu",(unsigned long)array.count);
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





@end
