//
//  ViewController.m
//  TTShareViewDemo
//
//  Created by zm on 2020/2/12.
//  Copyright © 2020 tutu. All rights reserved.
//

#import "ViewController.h"
#import "TTShareView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setups];
}


- (void)setups{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"显示" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    button.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, 230, 100, 50);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showView{
    TTShareViewItem *item1 = [TTShareViewItem itemWithTitle:@"微信" icon:@"tt_share_wx" handler:^{
        
    }];
    
    TTShareViewItem *item2 = [TTShareViewItem itemWithTitle:@"QQ" icon:@"tt_share_qq" handler:^{
        
    }];
    
    TTShareViewItem *item3 = [TTShareViewItem itemWithTitle:@"朋友圈" icon:@"tt_share_circle" handler:^{
        
    }];
    
    TTShareView *shareView = [[TTShareView alloc] initWithShareItems:@[item1,item2,item3] frame:self.view.bounds];
    //每行的数量
    shareView.columns = 3;
    [shareView showFromControlle:self];
}

@end
