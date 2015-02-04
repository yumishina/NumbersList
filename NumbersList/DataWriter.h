//
//  DataWriter.h
//  NumbersList
//
//  Created by Юлия on 03.02.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataWriter : NSObject

-(void)saveDataInCoreData:(void (^)())callback;
@end
