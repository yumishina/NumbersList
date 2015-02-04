//
//  DataReader.h
//  NumbersList
//
//  Created by Юлия on 03.02.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataReader : NSObject //Назвать класс NetworkManager

-(void)readFromCoreData:(void (^)(NSMutableArray *array))callback;

@end
