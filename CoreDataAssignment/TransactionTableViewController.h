//
//  TransactionTableViewController.h
//  CoreDataAssignment
//
//  Created by paradigm creatives on 9/25/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Employees.h"

@interface TransactionTableViewController : UITableViewController<NSFetchedResultsControllerDelegate,UIAlertViewDelegate>


@property(nonatomic,strong) NSFetchedResultsController *fetchedresultcontroller;
@property(nonatomic,strong) NSManagedObjectContext *managedobjectcontext;

@property(nonatomic,strong)Employees *selectedEmployee;

@end
