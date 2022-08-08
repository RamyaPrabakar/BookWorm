//
//  MyBooksViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "MyBooksViewController.h"
#import "Parse/Parse.h"
#import "GoogleBook.h"
#import "MarkingCell.h"

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
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"paper.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // A little trick for removing the cell separators
    self.readingTableView.separatorColor = [UIColor clearColor];
    self.readTableView.separatorColor = [UIColor clearColor];
    self.toReadTableView.separatorColor = [UIColor clearColor];
    
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
    
    // making sure that fetching from Parse occurs whenever this view appears
    [self fetchFromParse];
    [self.readTableView reloadData];
    [self.readingTableView reloadData];
    [self.toReadTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (tableView == self.readingTableView) {
        if ([self.readingBooks count] == 0) {
            // returning 1 when there are no reading books
            // This one row says "No books in reading list"
            return 1;
        }
        return [self.readingBooks count];
    } else if (tableView == self.readTableView) {
        if ([self.readBooks count] == 0) {
            // returning 1 when there are no read books
            // This one row says "No books in read list"
            return 1;
        }
        return [self.readBooks count];
    } else if (tableView == self.toReadTableView) {
        if ([self.toReadBooks count] == 0) {
            // returning 1 when there are no toRead books
            // This one row says "No books in to read list"
            return 1;
        }
        return [self.toReadBooks count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Setting up the markingCell that is returned
    MarkingCell *markingCell = [tableView dequeueReusableCellWithIdentifier:@"MarkingCell"];
    if (tableView == self.readingTableView) {
        if ([self.readingBooks count] == 0) {
            markingCell.bookTitle.text = @"No books in your reading list";
            markingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return markingCell;
        }
        markingCell.bookTitle.text = self.readingBooks[indexPath.row][@"title"];
    } else if (tableView == self.readTableView) {
        if ([self.readBooks count] == 0) {
            markingCell.bookTitle.text = @"No books in your read list";
            markingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return markingCell;
        }
        markingCell.bookTitle.text = self.readBooks[indexPath.row][@"title"];
    } else if (tableView == self.toReadTableView) {
        if ([self.toReadBooks count] == 0) {
            markingCell.bookTitle.text = @"No books in your to read list";
            markingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return markingCell;
        }
        markingCell.bookTitle.text = self.toReadBooks[indexPath.row][@"title"];
    }
    markingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return markingCell;
}

- (IBAction)toReadButtonPressed:(id)sender {
    // Hiding and unhiding the toRead table view
    if (self.toReadTableView.hidden == YES) {
        self.toReadTableView.hidden = NO;
    } else {
        self.toReadTableView.hidden = YES;
    }
}

- (IBAction)readingButtonPressed:(id)sender {
    // Hiding and unhiding the reading table view
    if (self.readingTableView.hidden == YES) {
        self.readingTableView.hidden = NO;
    } else {
        self.readingTableView.hidden = YES;
    }
}

- (IBAction)readButtonPressed:(id)sender {
    // Hiding and unhiding the read table view
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

@end
