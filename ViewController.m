//
//  ViewController.m
//  动态3D Touch
//
//  Created by jie wang on 15/12/23.
//  Copyright © 2015年 jie wang. All rights reserved.
//

#import "ViewController.h"
#import "PeekViewController.h"
#import "ChooseFirstViewController.h"
#import "ChooseSecondViewController.h"

#define Row_Height 50

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) CGRect sourceRect;   // 用户手势点 对应需要突出显示的rect
@property (nonatomic, strong) NSIndexPath *indexPath;  // 用户手势点 对应的indexPath

@end

@implementation ViewController

- (NSMutableArray *)dataArr{

    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i<10; i++) {
            [_dataArr addObject:[NSString stringWithFormat:@"我是第%ld行",i]];
        }
    }
    return _dataArr;
}

- (void)addSfortcutItem{
    NSArray *titleArr = @[@"选择第一",@"选择第二"];
    NSMutableArray *itemArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i<titleArr.count; i++) {
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:[NSString stringWithFormat:@"%ld",i] localizedTitle:[titleArr objectAtIndex:i] localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd]  userInfo:nil];
        
        [itemArr addObject:item];
    }
    [UIApplication sharedApplication].shortcutItems = itemArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self addSfortcutItem];
    
    // 处理shortCutItem 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoChooseViewCtrl:) name:@"gotoChooseViewCtrl" object:nil];
    
    // 注册Peek和Pop方法
    [self registerForPreviewingWithDelegate:self sourceView:self.view];
}

#pragma mark NSNotification

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gotoChooseViewCtrl:(NSNotification *)noti {
    NSString *type = noti.userInfo[@"type"];
    UIViewController *chooseVc;
    
    switch (type.integerValue) {
        case 0:
            chooseVc = [[ChooseFirstViewController alloc] init];
            break;
        case 1:
            chooseVc = [[ChooseSecondViewController alloc] init];
            break;

        default:
            break;
    }

    //如果当前viewCtl是否已经presented
    if (self.presentedViewController) {
        [self.presentedViewController removeFromParentViewController];
        [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];;
    }
    [self presentViewController:chooseVc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}


#pragma mark - UIViewControllerPreviewingDelegate

/** peek手势  */
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{

    PeekViewController *viewCtl = [[PeekViewController alloc] init];
    // 获取用户手势点所在cell的下标。同时判断手势点是否超出tableView响应范围。
    if (![self getShouldShowRectAndIndexPathWithLocation:location]) return nil;
    previewingContext.sourceRect = self.sourceRect;
    
    viewCtl.titleStr = _dataArr[self.indexPath.row];
    
    return viewCtl;

}

/** pop手势  */
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{

    [self showViewController:viewControllerToCommit sender:self];
}


/** 获取用户手势点所在cell的下标。同时判断手势点是否超出tableView响应范围。*/
- (BOOL)getShouldShowRectAndIndexPathWithLocation:(CGPoint)location {
//    NSLog(@"X:%f  Y:%f",location.x,location.y);
    NSInteger row = (location.y - 20)/Row_Height;
    self.sourceRect = CGRectMake(0, row * Row_Height, self.tableView.frame.size.width, Row_Height);
    self.indexPath = [NSIndexPath indexPathForItem:row inSection:0];
    // 如果row越界了，返回NO 不处理peek手势
    return row >= self.dataArr.count ? NO : YES;
}



@end
