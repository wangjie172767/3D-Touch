//
//  ChooseSecondViewController.m
//  动态3D Touch
//
//  Created by jie wang on 16/1/29.
//  Copyright © 2016年 jie wang. All rights reserved.
//

#import "ChooseSecondViewController.h"

@interface ChooseSecondViewController ()

@end

@implementation ChooseSecondViewController
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
