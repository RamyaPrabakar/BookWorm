//
//  MyBooksViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "MyBooksViewController.h"
#import "Parse/Parse.h"
#import "GoogleBook.h"

@interface MyBooksViewController ()
@property (weak, nonatomic) IBOutlet UIButton *toReadButton;
@property (weak, nonatomic) IBOutlet UIButton *readingButton;
@property (weak, nonatomic) IBOutlet UIButton *readButton;
@property (weak, nonatomic) IBOutlet UITableView *readingTableView;
@property (weak, nonatomic) IBOutlet UITableView *toReadTableView;
@property (weak, nonatomic) IBOutlet UITableView *readTableView;
@property (nonatomic, strong) NSMutableArray *readBooks;
@property (nonatomic, strong) NSMutableArray *readingBooks;
@property (nonatomic, strong) NSMutableArray *toReadBooks;
@end

@implementation MyBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // initializing the list arrays
    self.readBooks = [[NSMutableArray alloc] init];
    self.readingBooks = [[NSMutableArray alloc] init];
    self.toReadBooks = [[NSMutableArray alloc] init];
    
    // setting up the readingTableView
    self.readingTableView.delegate = self;
    self.readingTableView.dataSource = self;
    self.readingTableView.hidden = YES;
    
    // setting up the toReadTableview
    self.toReadTableView.delegate = self;
    self.toReadTableView.dataSource = self;
    self.toReadTableView.hidden = YES;
    
    // setting up the readTableView
    self.readTableView.delegate = self;
    self.readTableView.dataSource = self;
    self.readTableView.hidden = YES;
    
    [self fetchFromParse];
    
    NSLog(@"COUNTS");
    NSLog(@"%lu", (unsigned long)[self.toReadBooks count]);
    NSLog(@"%lu", (unsigned long)[self.readBooks count]);
    NSLog(@"%lu", (unsigned long)[self.readingBooks count]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // NSLog(@"Do I get here?");
    if (tableView == self.readingTableView) {
        // NSLog(@"%lu", (unsigned long)self.readingBooks.count);
        if ([self.readingBooks count] == 0) {
            return 1;
        }
        return [self.readingBooks count];
    } else if (tableView == self.readTableView) {
        // NSLog(@"%lu", (unsigned long)self.readBooks.count);
        if ([self.readBooks count] == 0) {
            return 1;
        }
        return [self.readBooks count];
    } else if (tableView == self.toReadTableView) {
        // NSLog(@"%lu", (unsigned long)self.toReadBooks.count);
        if ([self.toReadBooks count] == 0) {
            return 1;
        }
        return [self.toReadBooks count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    // NSLog(@"Did I atleast get here");
    
    if (tableView == self.readingTableView) {
        // NSLog(@"I got here");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if ([self.readingBooks count] == 0) {
            cell.textLabel.text = @"No books in your reading list";
            return cell;
        }
        cell.textLabel.text = self.readingBooks[indexPath.row][@"title"];
    } else if (tableView == self.readTableView) {
        // NSLog(@"I got here too");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if ([self.readBooks count] == 0) {
            cell.textLabel.text = @"No books in your read list";
            return cell;
        }
        cell.textLabel.text = self.readBooks[indexPath.row][@"title"];
    } else if (tableView == self.toReadTableView) {
        // NSLog(@"I got here yay");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if ([self.toReadBooks count] == 0) {
            cell.textLabel.text = @"No books in your to read list";
            return cell;
        }
        cell.textLabel.text = self.toReadBooks[indexPath.row][@"title"];
    }
    
    return cell;
}

- (IBAction)toReadButtonPressed:(id)sender {
    if (self.toReadTableView.hidden == YES) {
        self.toReadTableView.hidden = NO;
    } else {
        self.toReadTableView.hidden = YES;
    }
}

- (IBAction)readingButtonPressed:(id)sender {
    if (self.readingTableView.hidden == YES) {
        self.readingTableView.hidden = NO;
    } else {
        self.readingTableView.hidden = YES;
    }
}

- (IBAction)readButtonPressed:(id)sender {
    if (self.readTableView.hidden == YES) {
        self.readTableView.hidden = NO;
    } else {
        self.readTableView.hidden = YES;
    }
}

- (void) fetchFromParse {
    PFUser *currUser = [PFUser currentUser];
    
    // Fetching books from the user's "reading" list
    for (GoogleBook * obj in currUser[@"Reading"]) {
        [obj fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Came to reading");
                NSLog(@"%@", obj);
                [self.readingBooks addObject:obj];
                NSLog(@"Count reading");
                NSLog(@"%lu", (unsigned long)[self.readingBooks count]);
                [self.readingTableView reloadData];
            }
        }];
        
    }
    
    // Fetching books from the user's "read" list
    for (GoogleBook * obj in currUser[@"Read"]) {
        [obj fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Came to read");
                NSLog(@"%@", obj);
                [self.readBooks addObject:obj];
                NSLog(@"Count read");
                NSLog(@"%lu", (unsigned long)[self.readingBooks count]);
                [self.readTableView reloadData];
            }
        }];
    }
    
    // Fetching books from the user's "to read" list
    for (GoogleBook * obj in currUser[@"ToRead"]) {
        [obj fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Came to to read");
                NSLog(@"%@", obj);
                [self.toReadBooks addObject:obj];
                NSLog(@"Count to read");
                NSLog(@"%lu", (unsigned long)[self.readingBooks count]);
                [self.toReadTableView reloadData];
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
