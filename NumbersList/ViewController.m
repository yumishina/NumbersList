//
//  ViewController.m
//  NumbersList
//
//  Created by Юлия on 26.01.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import "ViewController.h"
#import "Numbers.h"
#import "DataWriter.h"
#import "DataCleaner.h"
#import "DataReader.h"


@interface ViewController ()

@end

@implementation ViewController{
    NSDate *start ;
    NSTimeInterval timeInterval ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Настройки tableView
    // self.tableView.delegate = self;
    //self.tableView.dataSource =  self;
    [self.navigationController.navigationBar setTranslucent:NO]; // отключаем свойство полупрозрачности панели навигации
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"customCell"];
    self.countLabel.layer.borderWidth = 1;
    self.countLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.timeLabel.layer.borderWidth = 1;
    self.timeLabel.layer.borderColor = [UIColor grayColor].CGColor;
    
    //Индикатор загрузки
    [self.indicator setColor:[UIColor redColor]];
    //начать анимацию
    [self.indicator startAnimating];
    
    //Очищение CoreData
    [Numbers cleanCoreData];
    
    //Сохранение данных в CoreData
     start = [NSDate date]; // Начало отсчета времени
    
    self.fetchedResultsController = [Numbers readFromCoreData];
    self.fetchedResultsController.delegate = self;
    NSLog(@"fetchedResultsController = %lu", self.fetchedResultsController.fetchedObjects.count);
    [Numbers saveDataInCoreData:^{
        
    }];
   
}

//Количество строк tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fetchedResultsController.fetchedObjects.count;
}

//Заполнение данными tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //удаление выделения ячейки
   // Numbers* number = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
   // cell.textLabel.text = number.number;
     [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            

            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
         break;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    FailedBankInfo *info = [_fetchedResultsController objectAtIndexPath:indexPath];
//    cell.textLabel.text = info.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
//                                 info.city, info.state];
    Numbers* number = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = number.number;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
    NSDate* end = [[NSDate alloc] init];
     timeInterval = [end timeIntervalSinceDate:start]; //Окончание отсчета времени
    // NSTimeInterval timeInterval = [start timeIntervalSinceNow]; //подсчет времени
    
    NSString *intervalString = [NSString stringWithFormat:@"%f", timeInterval];
    self.timeLabel.text = intervalString;
    self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.fetchedResultsController.fetchedObjects.count];
    // остановить анимацию
    [self.indicator stopAnimating];
    [self.indicator setHidesWhenStopped:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
