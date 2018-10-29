//
//  EdeePageControl.m
//  DynamicPageControl
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 com.dynamicPageControl. All rights reserved.
//

#import "EdeePageControl.h"

@interface EdeePageControl()

@property(nonatomic, assign)CGRect pageControllerUnderViewFrame;
//@property(nonatomic, assign)CGFloat visibleAreaP;
//@property(nonatomic, assign)NSUInteger totalP;

//@property(nonatomic, assign)CGFloat dotRadiusS;
//@property(nonatomic, assign)CGFloat startPos;
//@property(nonatomic, strong)UIColor *dotC;

@property(nonatomic, strong)UIScrollView* dotScrollView;
@property(nonatomic, strong)NSMutableArray *tabViews;
@property(nonatomic, strong)UIView *contentView;


@end

@implementation EdeePageControl
@synthesize currentPage,lastCurrentPage;

+ (id)EPageControlShareInstance {
    static EdeePageControl *EdeePageControlInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        EdeePageControlInstance = [[self alloc] init];
    });
    return EdeePageControlInstance;
}

-(UIView*) initialPageControlView:(CGRect)frame VisibleAreaPoint:(CGFloat)visibleAreaPoint DotRadiusSize:(CGFloat)dotRadiusSize DotColor:(UIColor*)dotColor StartPosition:(CGFloat) startPosition TotalPoints:(NSUInteger)totalPoints{
    //123
    _pageControllerUnderViewFrame = frame;
    _visibleAreaP                 = visibleAreaPoint;
    _totalP                       = totalPoints;
    _dotRadiusS                   = dotRadiusSize;
    _dotC                         = dotColor;
    _startPos                     = startPosition;
    lastCurrentPage               = 9999;
    currentPage                   = _startPos;
    //要幾個點，點多大，點的顏色
    
    self.pageControllerUnderView = [[UIView alloc] initWithFrame:_pageControllerUnderViewFrame];
    
    CGFloat width = 100;
    if (_visibleAreaP < 10) {
        width = _visibleAreaP * 10;
    }
    
    self.dotScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.pageControllerUnderView.frame.size.width/3, 0, width, self.pageControllerUnderView.frame.size.height)];
    self.dotScrollView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.dotScrollView.frame.size.height/2);
    [self initWithScrollVIew:self.dotScrollView];
    [self.pageControllerUnderView addSubview:self.dotScrollView];
    return self.pageControllerUnderView;
}


-(UIView*)pageControllerUnderView{
 
    if (!_pageControllerUnderView) {
        [_pageControllerUnderView setBackgroundColor:[UIColor blackColor]];
    }
    return _pageControllerUnderView;
}

-(UIScrollView*)dotScrollView{
    
    if (!_dotScrollView) {
        [_dotScrollView setBackgroundColor:[UIColor blackColor]];
    }
    return _dotScrollView;
}

- (void) initWithScrollVIew: (UIScrollView * )scrollView {
    
    [scrollView setBounces:NO];
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.userInteractionEnabled=NO;
    
    
    self.tabViews = [NSMutableArray array];
    for (int i = 0; i < _totalP; i++){
        UIView *singleView = [[UIView alloc]initWithFrame:CGRectMake(i*10, 0, 10, 10)];
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(1,1,8,8)];
        circleView.layer.cornerRadius = 10;  // half the width/height
        
        circleView.backgroundColor = [UIColor whiteColor];
        
        
        [singleView addSubview:circleView];
        
        [singleView setBackgroundColor:[UIColor blackColor]];
        
        [self.tabViews addObject:singleView];
    }
    
    
    CGFloat width = 10;
    
    for (UIView *view in self.tabViews) {
        width += view.frame.size.width;
    }
    
    [scrollView setContentSize:CGSizeMake(MAX(width, self.pageControllerUnderView.frame.size.width), 10)];
    
    self.contentView = [UIView new];
    [self.contentView setFrame:CGRectMake(0, 0, MAX(width, self.pageControllerUnderView.frame.size.width), 10)];
    
    [self.contentView setBackgroundColor:[UIColor blackColor]];
    
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [scrollView addSubview:self.contentView];
    
    int index = 0;
    
    for (UIView *tab in self.tabViews) {
        
        [self.contentView addSubview:tab];
        
        [tab setTag:index];
        index ++;
    }
    [self drawPoint];
    
}

- (void)drawPoint{

    if (lastCurrentPage == 9999 ) {
        //initial
    }else{
        UIView *singleView = [[UIView alloc]initWithFrame:CGRectMake(lastCurrentPage*10, 0, 10, 10)];
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(1,1,8,8)];
        circleView.layer.cornerRadius = 10;  // half the width/height
        
        circleView.backgroundColor = [UIColor whiteColor];
        
        [singleView addSubview:circleView];
        
        [singleView setBackgroundColor:[UIColor blackColor]];
        
        [self.contentView addSubview:singleView];
        
        
    }
    
    UIView *circleLightView = [[UIView alloc] initWithFrame:CGRectMake(1,1,8,8)];
    circleLightView.layer.cornerRadius = 10;  // half the width/height
    
    circleLightView.backgroundColor = _dotC;
    UIView *singleView2 = [[UIView alloc]initWithFrame:CGRectMake(currentPage*10, 0, 10, 10)];
    [singleView2 addSubview:circleLightView];
    
    [singleView2 setBackgroundColor:[UIColor blackColor]];
    
    [self.contentView addSubview:singleView2];
    
    [self pageIndicatorAnimation];
}


- (void) pageIndicatorAnimation {
    //做動畫
    int displayCount = 10;
    NSInteger moveCount = (currentPage+1)-displayCount;
    if (moveCount >=0) {
        if (currentPage == _totalP-1){
            if (lastCurrentPage == 9999 ) {
                [UIView animateWithDuration:0.1
                                 animations:^{
                                     [self.dotScrollView setContentOffset:CGPointMake((moveCount)*10, 0)];
                                 }];
            }
        }else{
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self.dotScrollView setContentOffset:CGPointMake((moveCount+1)*10, 0)];
                             }];
        }
    }
    else{
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.dotScrollView setContentOffset:CGPointMake(0, 0)];
                         }];
    }
    lastCurrentPage = currentPage;
}

-(void)updateCurrentPage:(NSUInteger)currentPosition {
    
    currentPage = currentPosition;
    
}

@end
