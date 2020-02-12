# TTShareView
iOS功能弹窗，简单即可实现功能弹窗功能






几行代码即可实现效果：

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
