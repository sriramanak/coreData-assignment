//
//  TransactionTableViewController.m
//  CoreDataAssignment
//
//  Created by paradigm creatives on 9/25/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import "TransactionTableViewController.h"
#import "Transactions.h"
#import "AppDelegate.h"

@interface TransactionTableViewController (){

    AppDelegate *appdel;
}
- (IBAction)addTransaction:(id)sender;

@end

@implementation TransactionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _managedobjectcontext=appdel.managedObjectContext;
    
    _fetchedresultcontroller=[self getfetchedresultcontroller];
    
    NSError *error=nil;
    [_fetchedresultcontroller performFetch:&error];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(NSFetchedResultsController *)getfetchedresultcontroller{
    
    if (_fetchedresultcontroller!=nil) {
        return _fetchedresultcontroller;
    }
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Transactions" inManagedObjectContext:_managedobjectcontext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescript=[[NSSortDescriptor alloc]initWithKey:@"amount" ascending:YES];
    NSArray *descriptArray=[[NSArray alloc] initWithObjects:sortDescript, nil];
    [fetchRequest setSortDescriptors:descriptArray];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"transactionDetails=%@",_selectedEmployee];
    [fetchRequest setPredicate:predicate];

    NSFetchedResultsController *fetchedResultsContrl=[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedobjectcontext sectionNameKeyPath:nil cacheName:nil];
    
    
    
    fetchedResultsContrl.delegate=self;
    return fetchedResultsContrl;
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([_fetchedresultcontroller sections]>0)
    {
        return [[_fetchedresultcontroller sections] count];
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo=[[_fetchedresultcontroller sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondcell" forIndexPath:indexPath];
    Transactions *trans=[_fetchedresultcontroller objectAtIndexPath:indexPath];
    cell.textLabel.text=trans.desc;
    cell.detailTextLabel.text=[trans.amount stringValue];
    return cell;
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        case NSFetchedResultsChangeUpdate:
            if (newIndexPath==nil) {
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationNone];
            }
            else{
                
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView endUpdates];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        Transactions *trans=[NSEntityDescription insertNewObjectForEntityForName:@"Transactions" inManagedObjectContext:_managedobjectcontext];
        
        trans.desc=[alertView textFieldAtIndex:0].text;
        trans.amount=[NSNumber numberWithInt:[[alertView textFieldAtIndex:1].text intValue]];
        trans.transactionDetails=_selectedEmployee;
        
        
        NSError *error;
        
        [_managedobjectcontext save:&error];
    }
    

    
}

- (IBAction)addTransaction:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Add Transaction" message:@"Enter Transaction Details" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    
    UITextField *amountField=[alert textFieldAtIndex:1];
    
    amountField.secureTextEntry=NO;
    
    [alert show];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
