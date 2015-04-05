//
//  ViewController.m
//  TroyStoryFour
//
//  Created by Sherrie Jones on 4/5/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "WarriorListViewController.h"
#import "AppDelegate.h"

@interface WarriorListViewController () <UITableViewDataSource, UITableViewDelegate>
@property NSManagedObjectContext *moc;
@property NSArray *warriors;
@property (strong, nonatomic) IBOutlet UITableView *warriorsTableView;
@property BOOL toggled;
@end

@implementation WarriorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
    [self load];
}

- (IBAction)addWarrior:(UITextField *)sender {
    NSManagedObject *warrior = [NSEntityDescription insertNewObjectForEntityForName:@"Warrior" inManagedObjectContext:self.moc];

    int rand = arc4random()%10;

    [warrior setValue:sender.text forKey:@"name"];
    [warrior setValue:[NSNumber numberWithInteger:rand] forKey:@"prowess"];
    [self.moc save:nil];
    [self load];
    sender.text = @"";

    [sender resignFirstResponder];
}

- (IBAction)prowessToggle:(UIButton *)sender {
    self.toggled = !self.toggled;
    [self load];
}

- (void)load {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Warrior"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"prowess" ascending:YES];

    if (self.toggled) {
        request.predicate = [NSPredicate predicateWithFormat:@"prowess >= 5"];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"prowess < 5"];
    }
    
    request.sortDescriptors = @[sortDescriptor, sortDescriptor2];
    self.warriors = [self.moc executeFetchRequest:request error:nil];
    [self.warriorsTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.warriors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *warrior = self.warriors[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [warrior valueForKey:@"name"];
    cell.detailTextLabel.text = [[warrior valueForKey:@"prowess"] stringValue];

    return cell;
}
@end
