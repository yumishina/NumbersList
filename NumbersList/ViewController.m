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
    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
     [self.navigationController.navigationBar setTranslucent:NO]; // отключаем свойство полупрозрачности панели навигации
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"customCell"];
    // Do any additional setup after loading the view, typically from a nib.
    self.arrayNumbers = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21"];
}

//Количество строк tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayNumbers.count;
}

//Заполнение данными tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //удаление выделения ячейки
    cell.textLabel.text = [self.arrayNumbers objectAtIndex:indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end