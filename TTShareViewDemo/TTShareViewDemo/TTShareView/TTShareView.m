//
//  TTShareView.m
//  IntelligentShop
//
//  Created by zm on 2020/2/11.
//  Copyright © 2020 zm. All rights reserved.
//

#import "TTShareView.h"

#import <MessageUI/MessageUI.h>

//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
// 界面宽高
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SHARE_CANCEL_BUTTON_HEIGHT  50  //取消按钮高度
#define SHARE_BODY_VIEW_HEIGHT  130  //bodyview高度
#define SHARE_ITEM_HEIGHT  60   //item 高度
#define SHARE_ITEM_WIDTH  60    //item 宽度
#define SHARE_ITEM_LEFT_MARGIN  15  //左右边距
#define SHARE_ITEM_TOP_MARGIN 15    //顶部边距

#define SHARE_CONTENT_VIEW_HEIGHT (SHARE_BODY_VIEW_HEIGHT+SHARE_CANCEL_BUTTON_HEIGHT)

@implementation TTShareViewItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon handler:(void (^)(void))handler{
    TTShareViewItem *item = [[TTShareViewItem alloc] init];
    item.itemIcon = icon;
    item.itemTitle = title;
    item.selectionHandler = handler;
    return item;
}

@end

@interface TTShareView ()

@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) UIControl *maskView;

@property (nonatomic, strong) UIView *contenView;

@property (nonatomic, strong) UIView *bodyView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIViewController *myViewController;

@end

@implementation TTShareView
{
    CGFloat itemView_width; //item宽度
}

- (instancetype)initWithShareItems:(NSArray <TTShareViewItem *>*)items frame:(CGRect)frame{
    TTShareView *shareView = [[TTShareView alloc] initWithFrame:frame items:items];
    shareView.columns = self.columns;
    [shareView setups];
    return shareView;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray <TTShareViewItem *>*)items{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.itemArray = items;
    }
    return self;
}

- (void)setups{
    if (!_maskView) {
        _maskView = [[UIControl alloc] initWithFrame:self.frame];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.6);
        _maskView.tag = 100;
        [_maskView addTarget:self action:@selector(maskViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_maskView];
    }
    if (!_contenView) {
        _contenView = [[UIView alloc] initWithFrame: CGRectMake(0,  SCREEN_HEIGHT, SCREEN_WIDTH, SHARE_BODY_VIEW_HEIGHT)];
        _contenView.backgroundColor = RGBA(255, 255, 255, 0.9);
        _contenView.userInteractionEnabled = YES;
        [self addSubview:_contenView];
    }
    if (!_bodyView) {
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SHARE_BODY_VIEW_HEIGHT)];
        _bodyView.backgroundColor = HEXCOLOR(0xf4f4f4);
        [_contenView addSubview:_bodyView];
    }
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SHARE_CONTENT_VIEW_HEIGHT-SHARE_CANCEL_BUTTON_HEIGHT, SCREEN_WIDTH, SHARE_CANCEL_BUTTON_HEIGHT)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelButton setTitleColor:RGBA(32, 32, 32, 1) forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[self imageWithColor:RGBA(234, 234, 234, 1) size:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
        [_contenView addSubview:_cancelButton];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    UIView *theMaskView = (UIView *)[self viewWithTag:100];
    theMaskView.alpha = 0;
    CGFloat  height = [self getBodyViewHeight];
    CGRect rect = self.bodyView.frame;
    rect.size.height = height;
    self.bodyView.frame = rect;
    
    CGFloat contenViewHeight = height+SHARE_CANCEL_BUTTON_HEIGHT;
    CGRect cancelBtnRect = self.cancelButton.frame;
    cancelBtnRect.origin.y = contenViewHeight-SHARE_CANCEL_BUTTON_HEIGHT;
    self.cancelButton.frame = cancelBtnRect;
    //执行动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        if (weakSelf.contenView) {
            weakSelf.contenView.frame = CGRectMake(0, SCREEN_HEIGHT - contenViewHeight, SCREEN_WIDTH, contenViewHeight);
        }
        theMaskView.alpha = 0.6;
        
    } completion:nil];
}

#pragma mark public action
//展示分享页面
- (void)showFromControlle:(UIViewController *)controller{
    if (!(_columns > 0)) {
        _columns = 2;
    }
    itemView_width = (SCREEN_WIDTH-(4*SHARE_ITEM_LEFT_MARGIN))/_columns;
     [self configShareBtnItemView];
    self.myViewController = controller;
    [controller.view.window addSubview:self];
    
}

//配置分享种类
- (void)configShareBtnItemView{

    for (int i = 0; i<self.itemArray.count; i++) {
        TTShareViewItem *item = self.itemArray[i];
        // 计算行号  和   列号
        int row = i / _columns;
        int col = i % _columns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat itemX = SHARE_ITEM_LEFT_MARGIN + col * (itemView_width + SHARE_ITEM_LEFT_MARGIN);
        CGFloat itemY = row * (SHARE_BODY_VIEW_HEIGHT + SHARE_ITEM_TOP_MARGIN);
        TTShareViewItemView *itemView = [[TTShareViewItemView alloc] initWithFrame:CGRectMake(itemX, itemY, itemView_width, SHARE_BODY_VIEW_HEIGHT)];
        itemView.image = [UIImage imageNamed:item.itemIcon];
        itemView.titleLabel.text = item.itemTitle;
        __weak typeof(item) weakItem = item;
        __weak typeof(self) weakSelf = self;
        [itemView setTapAction:^{
            if (weakItem.selectionHandler) {
                weakItem.selectionHandler();
                [weakSelf tappedCancel];
            }
        }];
        [self.bodyView addSubview:itemView];
    }
}
//获取分享种类高度
- (CGFloat)getBodyViewHeight{
    CGFloat height = 0;
    int count = 1;
    if (self.itemArray.count%_columns==0) {
        count = 0;
    }
    height =(self.itemArray.count/_columns+count)*SHARE_BODY_VIEW_HEIGHT+(self.itemArray.count/_columns+count)*SHARE_ITEM_TOP_MARGIN;
    return height;
}

#pragma mark private action

- (void)maskViewClick:(UIControl *)sender {
    [self tappedCancel];
    
}

//消失动画
- (void)tappedCancel {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        UIView *theMaskView = (UIView *)[self viewWithTag:100];
        theMaskView.alpha = 0;
        if (weakSelf.contenView) {
            weakSelf.contenView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, weakSelf.contenView.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


#pragma mark -- Other

//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end

@implementation TTShareViewItemView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutUI{
    if (!_itemButton) {
        _itemButton = [[UIButton alloc] initWithFrame:CGRectMake(((CGRectGetWidth(self.frame)-SHARE_ITEM_WIDTH)/2), 35, SHARE_ITEM_WIDTH, SHARE_ITEM_HEIGHT)];
        [_itemButton setBackgroundColor:[UIColor clearColor]];
        [_itemButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_itemButton];
    }
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_itemButton.frame)+5, CGRectGetWidth(self.frame), 15)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        [self addSubview:_titleLabel];
    }
}

#pragma mark private action
- (void)action:(UIButton *)sender{
    if (self.tapAction) {
        self.tapAction();
    }
}

#pragma mark pubilc action
//设置图片
- (void)setImage:(UIImage *)image{
    _image = image;
    [self.itemButton setImage:image forState:UIControlStateNormal];
}

@end
