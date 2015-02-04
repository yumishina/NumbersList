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
    
    Numbers* actionNumber = [[Numbers alloc] init];
    
    //Очищение CoreData
    [actionNumber cleanCoreData];
    
    //Сохранение данных в CoreData
     NSDate *start = [NSDate date]; // Начало отсчета времени
    [actionNumber saveDataInCoreData:^{
        
        //Чтение из CoreData
        [actionNumber readFromCoreData:^(NSMutableArray *array) {
            self.arrayNumbers = array;
            [self.tableView reloadData];
            NSLog(@"self.arrayNumbers.count = %lu",(unsigned long)self.arrayNumbers.count);
            
            NSDate* end = [[NSDate alloc] init];
            NSTimeInterval timeInterval = [end timeIntervalSinceDate:start]; //Окончание отсчета времени
            // NSTimeInterval timeInterval = [start timeIntervalSinceNow]; //подсчет времени
            
            NSString *intervalString = [NSString stringWithFormat:@"%f", timeInterval];
            self.timeLabel.text = intervalString;
            self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrayNumbers.count];
            
            // остановить анимацию
            [self.indicator stopAnimating];
            [self.indicator setHidesWhenStopped:YES];
        }];
    }];
}

//Количество строк tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayNumbers.count;
}

//Заполнение данными tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //удаление выделения ячейки
    Numbers* number = [self.arrayNumbers objectAtIndex:indexPath.row];
    cell.textLabel.text = number.number;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
