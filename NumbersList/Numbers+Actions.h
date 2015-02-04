//
//  Numbers+Actions.h
//  NumbersList
//
//  Created by Юлия on 04.02.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import "Numbers.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface Numbers (Actions)

+(void)cleanCoreData;//Очищение данных
+(void)saveDataInCoreData:(void (^)())callback; //сохранение
//+(void)readFromCoreData:(void (^)(NSMutableArray *array))callback; //чтение данных
+(NSFetchedResultsController*)readFromCoreData;
@end
