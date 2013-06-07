//
//  LoginViewController.m
//  DiscountHunter
//
//  Created by iMac HS on 07-06-13.
//  Copyright (c) 2013 Happyshop. All rights reserved.
//

#import "LoginViewController.h"
#import "InstagramViewController.h"
#import "ListViewController.h"
#import "MMDrawerController.h"
#import "MMExampleCenterTableViewController.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!currentDataManager.session.isOpen) {
        // create a fresh session object
        currentDataManager.session = [FBSession new];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (currentDataManager.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [currentDataManager.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                //[self updateView];
                [self loadViewControllers];

            }];
        }
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    
    [self loadViewControllers];

    /*
    if (currentDataManager.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [currentDataManager.session closeAndClearTokenInformation];
        
    } else {
        if (currentDataManager.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            currentDataManager.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [currentDataManager.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self loadViewControllers];
        }];
    }
    */
}

- (void)loadViewControllers{
    
    UIViewController * leftSideDrawerViewController = [[MMExampleLeftSideDrawerViewController alloc] init];
    
    ListViewController *lViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    UIViewController * newViewController = [[UINavigationController alloc] initWithRootViewController:lViewController];

    //UIViewController * centerViewController = [[MMExampleCenterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UIViewController * rightSideDrawerViewController = [[MMExampleRightSideDrawerViewController alloc] init];
    
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:newViewController
                                             leftDrawerViewController:leftSideDrawerViewController
                                             rightDrawerViewController:nil];
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
    
        [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    [self presentViewController:drawerController animated:TRUE completion:^{
        
    }];
    
    /*
    InstagramViewController *iViewController = [[InstagramViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:iViewController animated:TRUE completion:^{
        
    }];
     */
}

@end
