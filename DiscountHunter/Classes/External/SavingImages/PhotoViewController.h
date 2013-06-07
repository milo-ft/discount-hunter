//
//  ViewController.h
//  SavingImagesTutorial
//
//  Created by Sidwyn Koh on 29/1/12.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PF_MBProgressHUD.h>
#include <stdlib.h> 

// For math functions including arc4random (a number randomizer)

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, PF_MBProgressHUDDelegate>
{
    IBOutlet UIScrollView *photoScrollView;
    NSMutableArray *allImages;
    
    PF_MBProgressHUD *HUD;
    PF_MBProgressHUD *refreshHUD;
}

- (IBAction)refresh:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (void)setUpImages:(NSArray *)images;
- (void)buttonTouched:(id)sender;

@end
