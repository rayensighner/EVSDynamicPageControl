//
//  PageViewController.m
//  DynamicPageControl
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 com.dynamicPageControl. All rights reserved.
//

#import "PageViewController.h"
#import "EdeePageControl.h"

@interface PageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property(nonatomic ,strong)NSMutableArray *newsArray;

@property(nonatomic ,assign)NSUInteger count;

@property(nonatomic ,assign)NSUInteger currentPage;

@property(nonatomic ,strong)NSString *startPage;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"newsPageViewController"];
    
    self.pageViewController.dataSource = self;
    
    self.pageViewController.delegate = self;
    
    self.newsArray = [[NSMutableArray alloc]init];
    
    _count = 20;

    self.startPage = @"5";
    
    [self addBasicData];
    
    [self firstPageSetting];
    
    //init page control view by setting 
    UIView* pcView = [[EdeePageControl EPageControlShareInstance] initialPageControlView:CGRectMake(0, self.view.frame.size.height-10, self.view.frame.size.width, 10) VisibleAreaPoint:10 DotRadiusSize:10 DotColor:[UIColor redColor] StartPosition:5 TotalPoints:_count];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:pcView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePage:) name:@"changePage" object:nil];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addBasicData{
    //data construct
    for (int i = 0; i < _count  ; i++) {
        NSString *unitStr = [NSString stringWithFormat:@"%lu",(unsigned long)i];
        [self.newsArray addObject:unitStr];
    }
}

-(void)firstPageSetting{
    NSUInteger pageIndex = [self.newsArray indexOfObject:self.startPage];

    // page controle current page index set here
    [[EdeePageControl EPageControlShareInstance] updateCurrentPage:pageIndex];
    
    //set content
    [self setContentPage:pageIndex];
    
 
}

-(void) setContentPage:(NSUInteger)pageIndex{
    
    ContentViewController *startingViewController = [self viewControllerAtIndex:pageIndex];
    
    NSArray *viewControllers;
    
    viewControllers  = @[startingViewController];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Change the size of page view controller
    CGRect pageViewControllerFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-10);
    
    if (@available(iOS 11.0,*)) {
        if ([UIScreen mainScreen].nativeBounds.size.height==2436) {
            pageViewControllerFrame.size.height -= 20;
        }
    }
    
    self.pageViewController.view.frame = pageViewControllerFrame;
    
    [self addChildViewController:self.pageViewController];
    
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController didMoveToParentViewController:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
  
    ContentViewController *pageContentViewController = [[ContentViewController alloc] init];
    pageContentViewController.pageIndex = index;

    return pageContentViewController;
}




#pragma mark - Page View Controller Data Source -

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    NSUInteger index;
    
    index =  ((ContentViewController*)viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    NSUInteger index;
    //左右換頁時會做的 method
    index =  ((ContentViewController*)viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.newsArray count]) {
        return nil;
    }
    
    
    return [self viewControllerAtIndex:index];
}

- (void)changePage:(NSNotification *)notification {
    
    
    NSNumber *showBool =[notification object];
    
    UIPageViewControllerNavigationDirection direction;
    
    if ([showBool intValue]==0) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }else{
        direction = UIPageViewControllerNavigationDirectionForward;
        
    }
    
    
    NSUInteger pageIndex = ((ContentViewController *) [self.pageViewController.viewControllers objectAtIndex:0]).pageIndex;
    
    if (direction == UIPageViewControllerNavigationDirectionForward) {
        pageIndex++;
    }
    else {
        pageIndex--;
    }
    
    ContentViewController *viewController = [self viewControllerAtIndex:pageIndex];
    
    if (viewController == nil) {
        return;
    }
  
    
    [self.pageViewController setViewControllers:@[viewController]
                                      direction:direction
                                       animated:YES
                                     completion:nil];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    
    //update current Page index
    NSUInteger index =[(ContentViewController *)[pendingViewControllers objectAtIndex:0] pageIndex];
    [[EdeePageControl EPageControlShareInstance] updateCurrentPage:index] ;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (completed) {
        //draw page control

       [[EdeePageControl EPageControlShareInstance]  drawPoint];
        
    }
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//
//}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return YES;
}

- (void)updateFocusIfNeeded {
    
}

@end
