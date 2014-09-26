//
//  EmployeeTableViewController.m
//  CoreDataAssignment
//
//  Created by paradigm creatives on 9/25/14.
//  Copyright (c) 2014 Paradigm Creatives. All rights reserved.
//

#import "EmployeeTableViewController.h"
#import "AppDelegate.h"
#import "Employees.h"
#import "TransactionTableViewController.h"

@interface EmployeeTableViewController ()
{
    AppDelegate *appdelegate;
    
}
- (IBAction)addEmployee:(id)sender;

@end

@implementation EmployeeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    _managedobjectcontext=[appdelegate managedObjectContext];
    _fetchedresultcontroller=[self getfetchedresultcontroller];
    
    NSError *error=nil;
    [_fetchedresultcontroller performFetch:&error];
    
}


    -(NSFetchedResultsController *)getfetchedresultcontroller{
        
        if (_fetchedresultcontroller!=nil) {
            return _fetchedresultcontroller;
        }
        
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"Employees" inManagedObjectContext:_managedobjectcontext];
        
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescript=[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
        NSArray *descriptArray=[[NSArray alloc] initWithObjects:sortDescript, nil];
        [fetchRequest setSortDescriptors:descriptArray];
        
        
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
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo=[[_fetchedresultcontroller sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstcell" forIndexPath:indexPath];
    
    Employees *employee=[_fetchedresultcontroller objectAtIndexPath:indexPath];
    
    cell.textLabel.text=employee.name;
    cell.detailTextLabel.text=[employee.empid stringValue];
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"Transaction"])
    {
        UINavigationController *nav=[segue destinationViewController];
        TransactionTableViewController *transaction=[nav.viewControllers objectAtIndex:0];
        //transaction.managedobjectcontext=_managedobjectcontext;
        
        NSIndexPath *selectedIndexPath=[self.tableView indexPathForSelectedRow];
       transaction.selectedEmployee=[_fetchedresultcontroller objectAtIndexPath:selectedIndexPath];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
        Employees *employee=[NSEntityDescription insertNewObjectForEntityForName:@"Employees" inManagedObjectContext:_managedobjectcontext];
        
        employee.name=[alertView textFieldAtIndex:0].text;
        employee.empid=[NSNumber numberWithInt:[[alertView textFieldAtIndex:1].text intValue]];
        
        NSError *error;
        
        [_managedobjectcontext save:&error];
    }
    
    
}


- (IBAction)addEmployee:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Add Employee" message:@"Enter Employee Details" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    
    UITextField *amountField=[alert textFieldAtIndex:1];
    
    amountField.secureTextEntry=NO;
    
    [alert show];
}
@end
