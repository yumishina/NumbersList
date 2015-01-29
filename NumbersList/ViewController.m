//
//  ViewController.m
//  NumbersList
//
//  Created by Юлия on 26.01.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    UIActivityIndicatorView* indicator;
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
    //[indicator setColor:[UIColor redColor]];
    indicator.frame = CGRectMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2, 10, 10);
    [self.view addSubview:indicator];
    //начать анимацию
    [indicator startAnimating];
    
    //Очищение CoreData
    [self cleanCoreData];
    
    //Чтение JSON
    [self readJSONAndSaveInCoreData];
}

//Чтение JSON
-(void)readJSONAndSaveInCoreData{
    
    NSDate *start = [NSDate date];
    
    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"https://gist.githubusercontent.com/yumishina/5f9d9460a720b4dc3f19/raw/3af83523fb34de34040bad1995f11c06d7660487/numbers"]];
    // NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]; //синхронная загрузка
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               
                               NSArray* tempArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError];
                               NSLog(@"Есть ли массив = %lu",(unsigned long)tempArray.count);////////////
                               
                               //Сохранение данных в CoreData
                               for (int i = 0; i < tempArray.count; i++) {
                                   NSLog(@"порядковый номер =  %d",i);
                                   NSManagedObjectContext* context = [self managedObjectContext];
                                   NSManagedObject* newNumbers = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers" inManagedObjectContext:context];
                                   [newNumbers setValue:[NSString stringWithFormat:@"%d", i] forKey:@"sequenceNumber"];
                                   [newNumbers setValue:[NSString stringWithFormat:@"%@", [tempArray objectAtIndex:i]] forKey:@"number"];
                                   
                                   NSError* error = nil;
                                   if (![context save: &error]) {
                                       NSLog(@"Can't save! %@ %@",error, [error localizedDescription]);
                                   }
                               }
                               
                               //Чтение из CoreData readFromCoreData
                               [self readFromCoreData];
                               
                               [self.tableView reloadData];
                               
                               NSTimeInterval timeInterval = [start timeIntervalSinceNow]; //подсчет времени
                               NSString *intervalString = [NSString stringWithFormat:@"%.4f", fabsf(timeInterval)];
                               self.timeLabel.text = intervalString;
                               self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayNumbers.count];
                               
                               // остановить анимацию
                               [indicator stopAnimating];
                               [indicator setHidesWhenStopped:YES];
                           }];
}

//Чтение из CoreData readFromCoreData
-(void)readFromCoreData{
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Numbers"];
    self.arrayNumbers = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"self.arrayNumbers.count = %lu",(unsigned long)self.arrayNumbers.count);
}

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
