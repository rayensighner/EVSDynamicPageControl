//
//  ContentViewController.m
//  DynamicPageControl
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 com.dynamicPageControl. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"第%lu個被創建",(unsigned long)self.pageIndex);

 
    
}


-(void)viewWillAppear:(BOOL)animated{
   
    [self indexLabelSET];
}

-(void)indexLabelSET{
    self.view.backgroundColor = [UIColor colorWithRed:[self randomFloat] green:[self randomFloat] blue:[self randomFloat] alpha:1];
    UILabel *pageIndexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    pageIndexLabel.center = self.view.center;
    pageIndexLabel.textColor = [UIColor whiteColor];
    pageIndexLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex ];
    pageIndexLabel.backgroundColor = [UIColor blackColor];
    [self.view addSubview: pageIndexLabel];
}

-(CGFloat)randomFloat {
    CGFloat f = (CGFloat)(rand()%100)/255.0;
    return f;
}
-(void)dealloc{
    
//    NSLog(@"第%lu個被銷毀",(unsigned long)self.pageIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
