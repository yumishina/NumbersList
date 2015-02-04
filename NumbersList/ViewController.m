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
