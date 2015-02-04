//
//  DataReader.m
//  NumbersList
//
//  Created by Юлия on 03.02.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import "DataReader.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@implementation DataReader{
    NSMutableArray* tempArray;
}

//Чтение из CoreData
-(void)readFromCoreData:(void (^)(NSMutableArray *array))callback{
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Numbers"];
    tempArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"self.arrayNumbers.count = %lu",(unsigned long)tempArray.count);
    callback(tempArray);
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
