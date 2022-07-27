//
//  SearchViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/8/22.
//

#import "SearchViewController.h"
#import "BookCell.h"
#import "GoogleBook.h"
#import "UIImageView+AFNetworking.h"
#import "SearchDetailsViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTitle;
@property (weak, nonatomic) IBOutlet UITextField *searchAuthor;
@property (weak, nonatomic) IBOutlet UITextField *searchPublisher;
@property (weak, nonatomic) IBOutlet UITextField *searchISBN;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfBooks;
@property (nonatomic, strong) NSMutableArray *autocompleteTitles;
@property (weak, nonatomic) IBOutlet UITableView *titleTableView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.arrayOfBooks = [[NSMutableArray alloc] init];
    self.autocompleteTitles = [[NSMutableArray alloc] init];
    self.searchTitle.delegate = self;
    
    self.titleTableView.dataSource = self;
    self.titleTableView.delegate = self;
    self.titleTableView.scrollEnabled = YES;
    self.titleTableView.hidden = YES;
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)checkMarkPressed:(id)sender {
    self.titleTableView.hidden = YES;
}

// If the text field changes, we trigger the autocomplete function
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
     
    if (textField == self.searchTitle) {
        NSString *substring = [NSString stringWithString:self.searchTitle.text];
        substring = [substring
          stringByReplacingCharactersInRange:range withString:string];
        [self searchAutocompleteEntriesWithSubstring:substring];
    }
    
  return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    [self.autocompleteTitles removeAllObjects];
    NSString *baseURL = @"https://www.googleapis.com/books/v1/volumes?q=";
    NSString *titleString;
    if ([self.searchTitle.text length] != 0) {
        titleString = [baseURL stringByAppendingFormat:@"%@%@", @"+intitle:", [self splitSearchWords:self.searchTitle.text]];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *googleKey = [dict objectForKey: @"GoogleBooksAPIKey"];
    NSString *finalURL = [titleString stringByAppendingFormat:@"%@%@", @"&key=", googleKey];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               [self.autocompleteTitles removeAllObjects];
               NSArray *itemsArray = dataDictionary[@"items"];
               
               for (NSDictionary *item in itemsArray) {
                   NSString *title = item[@"volumeInfo"][@"title"];
                   if (title != nil && [title hasPrefix:substring]) {
                       [self.autocompleteTitles addObject:item[@"volumeInfo"][@"title"]];
                   }
               }
           }
        
        // Reload your table view data
        if ([self.autocompleteTitles count] > 0) {
            self.titleTableView.hidden = NO;
            [self.titleTableView reloadData];
        }
    }];
    [task resume];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.titleTableView) {
        UITableViewCell *cell = [self.titleTableView cellForRowAtIndexPath:indexPath];
        self.searchTitle.text = cell.textLabel.text;
        self.titleTableView.hidden = YES;
    }
}

- (IBAction)clear:(id)sender {
    self.searchTitle.text = @"";
    self.searchAuthor.text = @"";
    self.searchISBN.text = @"";
    self.searchPublisher.text = @"";
    self.titleTableView.hidden = YES;
}

- (IBAction)clickedSearch:(id)sender {
    NSString *baseURL = @"https://www.googleapis.com/books/v1/volumes?q=";
    NSString *titleString;
    NSString *authorString;
    NSString *publisherString;
    NSString *isbnString;
    
    if ([self.searchTitle.text length] != 0) {
        titleString = [baseURL stringByAppendingFormat:@"%@%@", @"+intitle:", [self splitSearchWords:self.searchTitle.text]];
    } else {
        titleString = [baseURL stringByAppendingString:@""];
    }
    
    if ([self.searchAuthor.text length] != 0) {
        authorString = [titleString stringByAppendingFormat:@"%@%@", @"+inauthor:", [self splitSearchWords:self.searchAuthor.text]];
    } else {
        authorString = [titleString stringByAppendingString:@""];
    }
    
    
    if ([self.searchPublisher.text length] != 0) {
        publisherString = [authorString stringByAppendingFormat:@"%@%@", @"+inpublisher:", [self splitSearchWords:self.searchPublisher.text]];
    } else {
        publisherString = [authorString stringByAppendingString:@""];
    }
    
    if ([self.searchISBN.text length] != 0) {
        isbnString = [publisherString stringByAppendingFormat:@"%@%@", @"+isbn:", [self splitSearchWords:self.searchISBN.text]];
    } else {
        isbnString = [publisherString stringByAppendingString:@""];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *googleKey = [dict objectForKey: @"GoogleBooksAPIKey"];
    NSString *finalURL = [isbnString stringByAppendingFormat:@"%@%@", @"&key=", googleKey];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               [self.arrayOfBooks removeAllObjects];
               NSArray *itemsArray = dataDictionary[@"items"];
               
               for (NSDictionary *item in itemsArray) {
                   // Get the volumeInfo dictionary
                   GoogleBook *googleBook = [[GoogleBook alloc]initWithDictionary:item];
                   [self.arrayOfBooks addObject:googleBook];
               }
           }
        
        // Reload your table view data
        [self.tableView reloadData];
       }];
    [task resume];
}

-(NSString *)splitSearchWords:(NSString *)wordsToSplit{
    NSArray *array = [wordsToSplit componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    
    NSString *result = @"";
    
    for (NSString *word in array) {
        result = [result stringByAppendingString:word];
        result = [result stringByAppendingString:@"+"];
    }
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
        // Configuring the BookCell
        GoogleBook *book = self.arrayOfBooks[indexPath.row];
        cell.title.text = book.title;
        
        NSString *authors = @"";
        int i;
        
        for (i = 0; i < [book.authors count] - 1; i++) {
            authors = [authors stringByAppendingFormat:@"%@%@", [book.authors objectAtIndex:i], @", "];
        }
        
        authors = [authors stringByAppendingFormat:@"%@", [book.authors objectAtIndex:i]];
        
        cell.author.text = authors;
        cell.bookDescription.text = book.subtitle;

        NSURL *bookPosterURL = [NSURL URLWithString:book.bookImageLink];
        [cell.bookImage setImageWithURL:bookPosterURL placeholderImage:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (tableView == self.titleTableView) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (self.autocompleteTitles.count == 0) {
            return cell;
        }
        cell.textLabel.text = self.autocompleteTitles[indexPath.row];
        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        return self.arrayOfBooks.count;
    } else if (tableView == self.titleTableView) {
        return self.autocompleteTitles.count;
    }
    
    return 0;
}

#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     
     if ([[segue identifier] isEqualToString:@"searchDetailsSegue"]) {
         GoogleBook *bookToPass = self.arrayOfBooks[[self.tableView indexPathForCell:sender].row];
         SearchDetailsViewController *detailsVC = [segue destinationViewController];
         detailsVC.bookPassed = bookToPass;
     }
 }

@end
