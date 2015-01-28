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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Настройки tableView
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    self.tableView.backgroundColor = [UIColor yellowColor];
     [self.navigationController.navigationBar setTranslucent:NO]; // отключаем свойство полупрозрачности панели навигации
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"customCell"];
    
    //Чтение JSON
    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"https://gist.githubusercontent.com/yumishina/5f9d9460a720b4dc3f19/raw/3af83523fb34de34040bad1995f11c06d7660487/numbers"]];
    NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]; //синхронная загрузка
   // [NSURLConnection sendAsynchronousRequest:<#(NSURLRequest *)#> queue:<#(NSOperationQueue *)#> completionHandler:<#^(NSURLResponse *response, NSData *data, NSError *connectionError)handler#>]
    NSError* jsonParsingError = nil;
    NSArray* tempArray = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    NSLog(@"Есть ли массив = %lu",(unsigned long)tempArray.count);////////////
    
    //Сохранение данных в CoreData
    for (int i = 0; i < tempArray.count; i++) {
        NSLog(@"1");
        NSManagedObjectContext* context = [self managedObjectContext];
        NSLog(@"2");
       // NSEntityDescription * entityDescription = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers" inManagedObjectContext:context];
        NSLog(@"3");
       // NSManagedObject *newNumbers =  [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        NSLog(@"4");
        
        NSManagedObject* newNumbers = [NSEntityDescription insertNewObjectForEntityForName:@"Numbers" inManagedObjectContext:context];
         NSLog(@"5");
        [newNumbers setValue:[NSString stringWithFormat:@"%d", i] forKey:@"sequenceNumber"];
        [newNumbers setValue:[NSString stringWithFormat:@"%@", [tempArray objectAtIndex:i]] forKey:@"number"];
        
        NSError* error = nil;
        if (![context save: &error]) {
            NSLog(@"Can't save! %@ %@",error, [error localizedDescription]);
        }
    }
    
    //Чтение из CoreData
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Numbers"];
    self.arrayNumbers = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"self.arrayNumbers.count = %lu",(unsigned long)self.arrayNumbers.count);
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayNumbers.count];
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
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
