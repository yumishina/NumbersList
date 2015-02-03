//
//  ViewController.m
//  NumbersList
//
//  Created by Юлия on 26.01.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import "ViewController.h"
//#import "ReceivingData.h"
//#import "Numbers.h"
#import "DataWriter.h"
#import "DataCleaner.h"
#import "DataReader.h"


@interface ViewController ()

@end

@implementation ViewController{
    UIActivityIndicatorView* indicator;
    //  ReceivingData* getData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Настройки tableView
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    [self.navigationController.navigationBar setTranslucent:NO]; // отключаем свойство полупрозрачности панели навигации
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"customCell"];
    self.countLabel.layer.borderWidth = 1;
    self.countLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.timeLabel.layer.borderWidth = 1;
    self.timeLabel.layer.borderColor = [UIColor grayColor].CGColor;
    
    //Индикатор загрузки
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setColor:[UIColor redColor]];
    indicator.frame = CGRectMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2, 10, 10);
    [self.view addSubview:indicator];
    //начать анимацию
    [indicator startAnimating];
    
    //Очищение CoreData
    DataCleaner* dataCleaner = [[DataCleaner alloc] init];
    [dataCleaner cleanCoreData];
    
    
    //Сохранение данных в CoreData
    DataWriter* dataWriter = [[DataWriter alloc] init];
    NSDate *start = [NSDate date]; // Начало отсчета времени
    [dataWriter saveDataInCoreData:^() {
        
        //Чтение из CoreData readFromCoreData
        DataReader* dataReader = [[DataReader alloc] init];
        [dataReader readFromCoreData:^(NSMutableArray *array) {
            self.arrayNumbers = array;
        }];
        NSLog(@"self.arrayNumbers.count = %lu",(unsigned long)self.arrayNumbers.count);
        
        [self.tableView reloadData];
        
        NSDate* end = [[NSDate alloc] init];
        NSTimeInterval timeInterval = [end timeIntervalSinceDate:start]; //Окончание отсчета времени
        // NSTimeInterval timeInterval = [start timeIntervalSinceNow]; //подсчет времени
        
        NSString *intervalString = [NSString stringWithFormat:@"%f", timeInterval];
        self.timeLabel.text = intervalString;
        self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayNumbers.count];
        
        // остановить анимацию
        [indicator stopAnimating];
        [indicator setHidesWhenStopped:YES];
        
    }];
    
    
    
    //Чтение JSON
    //    NSDate *start = [NSDate date];
    
    //     getData = [[ReceivingData alloc] init];
    //    [getData getNumericData:^(NSMutableArray *array) {
    //
    //
    //        //Сохранение данных в CoreData
    //        for (int i = 0; i < array.count; i++) {
    //            NSLog(@"порядковый номер =  %d",i);
    //            NSManagedObjectContext* context = [self managedObjectContext];
    //           // NSManagedObject* newNumbers = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers" inManagedObjectContext:context];
    //           // [newNumbers setValue:[NSString stringWithFormat:@"%d", i] forKey:@"sequenceNumber"];
    //           // [newNumbers setValue:[NSString stringWithFormat:@"%@", [array objectAtIndex:i]] forKey:@"number"];
    //
    //            Numbers *newNumber = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers"
    //                                          inManagedObjectContext:context];
    //
    //            newNumber.sequenceNumber = [NSString stringWithFormat:@"%d", i];
    //            newNumber.number = [NSString stringWithFormat:@"%@", [array objectAtIndex:i]];
    //
    //            NSError* error = nil;
    //            if (![context save: &error]) {
    //                NSLog(@"Can't save! %@ %@",error, [error localizedDescription]);
    //            }
    //        }
    //
    //
    //        NSLog(@"arrayarrayarray=%lu",(unsigned long)array.count);
    //
    
    //    }];
    
    
    //    //Чтение JSON
    //    [self readJSONAndSaveInCoreData];
    
}


////Чтение JSON
//-(void)readJSONAndSaveInCoreData{
//
//    NSDate *start = [NSDate date];
//
//    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"https://gist.githubusercontent.com/yumishina/5f9d9460a720b4dc3f19/raw/3af83523fb34de34040bad1995f11c06d7660487/numbers"]];
//    // NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]; //синхронная загрузка
//
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response,
//                                               NSData *data,
//                                               NSError *connectionError) {
//
//                               NSArray* tempArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError];
//                               NSLog(@"Есть ли массив = %lu",(unsigned long)tempArray.count);////////////
//
//                               //Сохранение данных в CoreData
//                               for (int i = 0; i < tempArray.count; i++) {
//                                   NSLog(@"порядковый номер =  %d",i);
//                                   NSManagedObjectContext* context = [self managedObjectContext];
//                                   NSManagedObject* newNumbers = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers" inManagedObjectContext:context];
//                                   [newNumbers setValue:[NSString stringWithFormat:@"%d", i] forKey:@"sequenceNumber"];
//                                   [newNumbers setValue:[NSString stringWithFormat:@"%@", [tempArray objectAtIndex:i]] forKey:@"number"];
//
//                                   NSError* error = nil;
//                                   if (![context save: &error]) {
//                                       NSLog(@"Can't save! %@ %@",error, [error localizedDescription]);
//                                   }
//                               }
//
//                               //Чтение из CoreData readFromCoreData
//                               [self readFromCoreData];
//
//                               [self.tableView reloadData];
//
//                               NSTimeInterval timeInterval = [start timeIntervalSinceNow]; //подсчет времени
//                               NSString *intervalString = [NSString stringWithFormat:@"%.4f", fabsf(timeInterval)];
//                               self.timeLabel.text = intervalString;
//                               self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayNumbers.count];
//
//                               // остановить анимацию
//                               [indicator stopAnimating];
//                               [indicator setHidesWhenStopped:YES];
//                           }];
//}


////Чтение из CoreData readFromCoreData
//-(void)readFromCoreData{
//    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
//    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Numbers"];
//    self.arrayNumbers = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    NSLog(@"self.arrayNumbers.count = %lu",(unsigned long)self.arrayNumbers.count);
//}


//-(NSManagedObjectContext*)managedObjectContext{
//    NSManagedObjectContext* context = nil;
//    id delegate =[[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}

//Количество строк tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayNumbers.count;
}

//Заполнение данными tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //удаление выделения ячейки
    NSManagedObject* number = [self.arrayNumbers objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[number valueForKey:@"number"]];
    //cell.textLabel.text = [self.arrayNumbers objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
