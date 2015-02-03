//
//  Numbers.h
//  NumbersList
//
//  Created by Юлия on 03.02.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Numbers : NSManagedObject

@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * sequenceNumber;

@end
