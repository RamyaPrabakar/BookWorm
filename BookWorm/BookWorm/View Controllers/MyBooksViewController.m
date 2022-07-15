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
}

- (void)viewWillAppear:(BOOL)animated {
    [self.readingBooks removeAllObjects];
    [self.readBooks removeAllObjects];
    [self.toReadBooks removeAllObjects];
    [self fetchFromParse];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (tableView == self.readingTableView) {
        if ([self.readingBooks count] == 0) {
            return 1;
        }
        return [self.readingBooks count];
    } else if (tableView == self.readTableView) {
        if ([self.readBooks count] == 0) {
            return 1;
        }
        return [self.readBooks count];
    } else if (tableView == self.toReadTableView) {
        if ([self.toReadBooks count] == 0) {
            return 1;
        }
        return [self.toReadBooks count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (tableView == self.readingTableView) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if ([self.readingBooks count] == 0) {
            cell.textLabel.text = @"No books in your reading list";
            return cell;
        }
        cell.textLabel.text = self.readingBooks[indexPath.row][@"title"];
    } else if (tableView == self.readTableView) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if ([self.readBooks count] == 0) {
            cell.textLabel.text = @"No books in your read list";
            return cell;
        }
        cell.textLabel.text = self.readBooks[indexPath.row][@"title"];
    } else if (tableView == self.toReadTableView) {
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
    for (GoogleBook * book in currUser[@"Reading"]) {
        [book fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                [self.readingBooks addObject:book];
                [self.readingTableView reloadData];
            }
        }];
        
    }
    
    // Fetching books from the user's "read" list
    for (GoogleBook * book in currUser[@"Read"]) {
        [book fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                [self.readBooks addObject:book];
                [self.readTableView reloadData];
            }
        }];
    }
    
    // Fetching books from the user's "to read" list
    for (GoogleBook * book in currUser[@"ToRead"]) {
        [book fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                [self.toReadBooks addObject:book];
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
