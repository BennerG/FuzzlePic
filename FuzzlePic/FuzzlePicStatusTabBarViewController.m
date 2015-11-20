////
////  FuzzlePicStatusViewController.m
////  FuzzlePic
////
////  Created by Benjamin Thomas Gurrola on 10/28/15.
////  Copyright © 2015 Benjamin Thomas Gurrola. All rights reserved.
////
//
//#import "FuzzlePicStatusTabBarViewController.h"
//#import "WorkingFuzzlePicCollectionViewController.h"
//
//@interface FuzzlePicStatusTabBarViewController ()
//
//@end
//
//@implementation FuzzlePicStatusTabBarViewController
//
//- (void)loadView {
//    self.delegate = self;
//    [super loadView];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.delegate = self;
//    NSLog(@"%@", @(self.selectedIndex));
//    // Do any additional setup after loading the view.
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"%@", self.selectedViewController);
//    UINavigationController *navController = (UINavigationController *)self.selectedViewController;
//    WorkingFuzzlePicCollectionViewController *picController = navController.viewControllers.firstObject;
//    picController.isWorkingCollection = YES;
////    ((FuzzlePicCollectionViewController *)((UINavigationController *)self.selectedViewController).viewControllers.firstObject).isWorkingCollection = YES;
//}
//
//- (void)setWorkingStatusForSelectedController {
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-( void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    NSLog(@"did select %@", viewController);
//}
//
//
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"called?");
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//
//
//@end
