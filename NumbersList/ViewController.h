//
//  ViewController.h
//  NumbersList
//
//  Created by Юлия on 26.01.15.
//  Copyright (c) 2015 YuliaMishina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) NSArray* arrayNumbers;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

