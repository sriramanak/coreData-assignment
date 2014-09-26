//
//  Employees.h
//  CoreDataAssignment
//
//  Created by paradigm creatives on 9/26/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employees : NSManagedObject

@property (nonatomic, retain) NSNumber * empid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *employeeDetails;

@end
