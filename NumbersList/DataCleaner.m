//
//  DataCleaner.m
//  NumbersList
//
//  Created by Юлия on 03.02.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import "DataCleaner.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@implementation DataCleaner

//Очищение CoreData
-(void)cleanCoreData{
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Numbers" inManagedObjectContext:managedObjectContext]];
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&err];
    if(count > 0) {
        [self deleteAllObjects:@"Numbers"];
    }
}

//Удаление данных из CoreData
- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
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
