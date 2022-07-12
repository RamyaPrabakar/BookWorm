//
//  RecommendationsViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "RecommendationsViewController.h"
#import "SceneDelegate.h"
#import "FirstViewController.h"
#import "Book.h"
#import "BookCell.h"
#import "UIImageView+AFNetworking.h"
#import "RecommendationsDetailViewController.h"

// Frameworks
#import <FBSDKCoreKit/FBSDKProfile.h>
@interface RecommendationsViewController ()
@property (nonatomic, strong) NSMutableArray *arrayOfBooks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RecommendationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    [self getBooks];
    self.arrayOfBooks = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile * _Nullable profile, NSError * _Nullable error) {
            if (profile) {
                // get users profile name
                self.navigationItem.title = [NSString stringWithFormat:@"Hello %@ %@", profile.firstName, profile.lastName];
            }
        }];
    });
}

- (void) getBooks {
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: @"NYtimesAPIKey"];
    NSString *baseURL = @"https://api.nytimes.com/svc/books/v3/lists/full-overview.json?api-key=";
    NSString *urlString = [baseURL stringByAppendingString:key];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               // NSLog(@"%@", dataDictionary);
               
               // Get the results dictionary
               NSDictionary *resultsDictionary = dataDictionary[@"results"];
               
               // Get the array of all the best seller lists
               NSArray *bestSellerListsArray = resultsDictionary[@"lists"];
               
               for (NSDictionary *list in bestSellerListsArray) {
                   // this contains an array of dictionaries. Each dictionary refers to a book
                   NSArray *books = list[@"books"];
                   
                   for (NSDictionary *bookDictionary in books) {
                       // Now we initialize a Book object with this book dictionary
                       Book *book = [[Book alloc]initWithDictionary:bookDictionary];
                       
                       if([book.bookImageLink isEqual:[NSNull null]]) {
                           //do something if object is equals to [NSNull null]
                           break;
                       }
                       // NSString *text = book.title;
                       // NSLog(@"%@", text);
                       
                       [self.arrayOfBooks addObject:book];
                   }
               }
           }
        // Reload your table view data
        [self.tableView reloadData];
       }];
    [task resume];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
    
    // Configuring the BookCell
    Book *book = self.arrayOfBooks[indexPath.row];
    cell.title.text = book.title;
    cell.author.text = book.author;
    cell.bookDescription.text = book.bookDescription;

    NSURL *bookPosterURL = [NSURL URLWithString:book.bookImageLink];
    [cell.bookImage setImageWithURL:bookPosterURL placeholderImage:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu", (unsigned long)self.arrayOfBooks.count);
    return self.arrayOfBooks.count;
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FirstViewController *firstViewController = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    sceneDelegate.window.rootViewController = firstViewController;
}


#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     
     Book *bookToPass = self.arrayOfBooks[[self.tableView indexPathForCell:sender].row];
     RecommendationsDetailViewController *detailsVC = [segue destinationViewController];
     detailsVC.bookPassed = bookToPass;
 }

@end
