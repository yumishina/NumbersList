//
//  Numbers+Actions.m
//  NumbersList
//
//  Created by Юлия on 04.02.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import "Numbers+Actions.h"
#import "ReceivingData.h"

@implementation Numbers (Actions)


//Очищение CoreData
+(void)cleanCoreData{
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
+(void) deleteAllObjects: (NSString *) entityDescription  {
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

 //Сохранение данных в CoreData
+(void)saveDataInCoreData:(void (^)())callback{
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
            
            if (i % 500 == 0 || i == array.count-1) {
                NSLog(@"iiiii = %d",i);
                NSError* error = nil;
                if (![context save: &error]) {
                    NSLog(@"Can't save! %@ %@",error, [error localizedDescription]);
                }
            }
            
        }
        callback();
        NSLog(@"arrayarrayarray=%lu",(unsigned long)array.count);
    }];
}


//Чтение из CoreData
+(NSFetchedResultsController*)readFromCoreData{ //вернуть nsfetchresultcontroller не надо callback
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    
   // NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Numbers"];
   // NSMutableArray* tempArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
   
    //Создание запроса
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Numbers" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity: entity];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sequenceNumber" ascending:YES]];
    
    //[fetchRequest setFetchBatchSize:500];
    
    //Создание Controller запросов
    NSFetchedResultsController* theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *error;
    if (![theFetchedResultsController performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    NSLog(@"self.arrayNumbers.count = %lu",(unsigned long)theFetchedResultsController.fetchedObjects.count);
    return theFetchedResultsController;
}


////Чтение из CoreData
//+(void)readFromCoreData:(void (^)(NSMutableArray *array))callback{ //вернуть nsfetchresultcontroller не надо callback
//    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
//    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Numbers"];
//    NSMutableArray* tempArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    NSLog(@"self.arrayNumbers.count = %lu",(unsigned long)tempArray.count);
//    callback(tempArray);
//}


+(NSManagedObjectContext*)managedObjectContext{
    NSManagedObjectContext* context = nil;
    id delegate =[[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end
