//
//  EmployeeTableViewController.h
//  CoreDataAssignment
//
//  Created by paradigm creatives on 9/25/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface EmployeeTableViewController : UITableViewController<NSFetchedResultsControllerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) NSFetchedResultsController *fetchedresultcontroller;
@property(nonatomic,strong) NSManagedObjectContext *managedobjectcontext;


@end
