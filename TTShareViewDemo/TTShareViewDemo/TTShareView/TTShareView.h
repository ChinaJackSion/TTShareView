//
//  TTShareView.h
//  IntelligentShop
//
//  Created by zm on 2020/2/11.
//  Copyright © 2020 zm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTShareViewItem : NSObject
//item - icon
@property (nonatomic, strong) NSString *itemIcon;

@property (nonatomic, strong) NSString *itemTitle;

@property (nonatomic, copy) void(^selectionHandler)(void);

/**
 *  快速创建方法
 */
+ (instancetype)itemWithTitle:(NSString *)title
                         icon:(NSString *)icon
                      handler:(void (^)(void))handler;

@end

@interface TTShareView : UIView

//每行个数。(必须大于0，默认为2)
@property (nonatomic, assign) NSInteger columns;

- (instancetype)initWithShareItems:(NSArray <TTShareViewItem *>*)items frame:(CGRect)frame;

- (void)showFromControlle:(UIViewController *)controller;

@end

@interface TTShareViewItemView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) void(^tapAction)(void);

@property (nonatomic, strong) UIButton *itemButton;

@end

NS_ASSUME_NONNULL_END
