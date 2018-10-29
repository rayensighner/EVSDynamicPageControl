//
//  EdeePageControl.h
//  DynamicPageControl
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 com.dynamicPageControl. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface EdeePageControl : NSObject
@property (nonatomic, strong)UIView *pageControllerUnderView;
@property(nonatomic, readwrite)NSUInteger currentPage;
@property(nonatomic, readwrite)NSUInteger lastCurrentPage;

@property (nonatomic, assign)NSUInteger visibleAreaP;
@property(nonatomic, assign)NSUInteger totalP;
@property(nonatomic, assign)CGFloat dotRadiusS;
@property(nonatomic, assign)CGFloat startPos;
@property(nonatomic, strong)UIColor *dotC;

+ (id)EPageControlShareInstance ;
-(UIView*) initialPageControlView:(CGRect)frame VisibleAreaPoint:(CGFloat)visibleAreaPoint DotRadiusSize:(CGFloat)dotRadiusSize DotColor:(UIColor*)dotColor StartPosition:(CGFloat) startPosition TotalPoints:(NSUInteger)totalPoints;
-(void)updateCurrentPage:(NSUInteger)currentPage;

-(void)drawPoint;

@end
