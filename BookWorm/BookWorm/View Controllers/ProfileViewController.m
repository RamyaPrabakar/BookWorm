//
//  ProfileViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "PFImageView.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *currUser = [PFUser currentUser];
    NSString *fullUsername = [@"@" stringByAppendingString:currUser[@"username"]];
    self.username.text = fullUsername;
    self.profileImage.file = currUser[@"profilePicture"];
    [self.profileImage loadInBackground];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
    self.profileImage.layer.masksToBounds = YES;
    self.fullName.text = currUser[@"fullName"];
    self.bioTextView.text = currUser[@"bio"];
    
    [[self.bioTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.bioTextView layer] setBorderWidth:2.3];
    [[self.bioTextView layer] setCornerRadius:15];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)choosePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    NSLog(@"We will use photo library instead");
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender {
    PFUser *currUser = [PFUser currentUser];
    currUser[@"fullName"] = self.fullName.text;
    currUser[@"bio"] = self.bioTextView.text;
    [currUser saveInBackground];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.profileImage.image = editedImage;
    
    PFUser *currUser = [PFUser currentUser];
    currUser[@"profilePicture"] = [self getPFFileFromImage:self.profileImage.image];
    [currUser saveInBackground];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.jpeg" data:imageData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
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
