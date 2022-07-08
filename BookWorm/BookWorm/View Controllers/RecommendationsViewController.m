//
//  RecommendationsViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "RecommendationsViewController.h"
#import "SceneDelegate.h"
#import "FirstViewController.h"

// Frameworks
#import <FBSDKCoreKit/FBSDKProfile.h>
@interface RecommendationsViewController ()
@property (nonatomic, strong) NSMutableArray *arrayOfBooks;
@end

@implementation RecommendationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [self fetchBooks];
    
    NSURL *url = [NSURL URLWithString:@"https://api.nytimes.com/svc/books/v3/lists/full-overview.json?api-key=YtAgwkllS22d8OMJZPnAE8hUJ167mguo"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);
               
               // Get the results dictionary
               NSDictionary *resultsDictionary = dataDictionary[@"results"];
               
               // Get the array of all the best seller lists
               NSArray *bestSellerListsArray = resultsDictionary[@"lists"];
               
               for (NSDictionary *list in bestSellerListsArray) {
                   // this contains an array of dictionaries. Each dictionary refers to a book
                   NSArray *books = list[@"books"];
                   
                   for (NSDictionary *book in books) {
                       // Now we initialize a Book object with this book dictionary
                   }
               }
           }
       }];
    [task resume];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile * _Nullable profile, NSError * _Nullable error) {
            if (profile) {
                // get users profile name
                self.navigationItem.title = [NSString stringWithFormat:@"Hello %@ %@", profile.firstName, profile.lastName];
            }
        }];
    });
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
