//
//  Transactions.h
//  CoreDataAssignment
//
//  Created by paradigm creatives on 9/26/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Employees;

@interface Transactions : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) Employees *transactionDetails;
@end

@interface Transactions (CoreDataGeneratedAccessors)

- (void)addTransactionDetailsObject:(Employees *)value;
- (void)removeTransactionDetailsObject:(Employees *)value;
- (void)addTransactionDetails:(NSSet *)values;
- (void)removeTransactionDetails:(NSSet *)values;

@end
