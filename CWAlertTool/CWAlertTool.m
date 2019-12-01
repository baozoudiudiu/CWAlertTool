//
//  CWAlertTool.m
//  CWAlertTool
//
//  Created by 罗泰 on 2019/6/17.
//  Copyright © 2019 chenwang. All rights reserved.
//

#import "CWAlertTool.h"

@interface CWAlertTool()
@property (nonatomic, strong) UIView                *bgView;
@property (nonatomic, copy) void (^showCompletion) (void);
@property (nonatomic, copy) void (^dismissCompletion) (void);
@end


@implementation CWAlertTool
+ (void)showContentView:(UIView *)contentView withStyle:(CWAlertStyle)style completion:(void (^)(void))completion {
    CWAlertTool *tool = [[CWAlertTool alloc] initWithStyle:style contentView:contentView];
    if ([contentView respondsToSelector:@selector(setAlertTool:)]) {
        [contentView performSelector:@selector(setAlertTool:) withObject:tool];
    }
    [tool showWithCompletion:completion];
}

- (instancetype)initWithStyle:(CWAlertStyle)style contentView:(UIView *)contentView {
    if (self = [super initWithFrame:CGRectMake(0, 0, k_CWAlertTool_ScreenWidth, k_CWAlertTool_ScreenHeight)]) {
        _style = style;
        [self configureView];
        self.contentView = contentView;
        self.timeInterval = 0.45;
        self.springWithDamping = 0.7;
        self.initialSpringVelocity = 0.8;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}


- (void)configureView {
    // 设置背景蒙版
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.userInteractionEnabled = YES;
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    [self addSubview:self.bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap)];
    [self.bgView addGestureRecognizer:tap];
}


#pragma mark - 事件响应
- (void)bgViewTap {
    [self dismissWithCompletion:^{
        
    }];
}


#pragma mark - 动画相关
- (void)show {
    [self showWithCompletion:^{
        
    }];
}


- (void)showWithCompletion:(void (^)(void))completion {
    [self setShowCompletion:completion];
    [self showPrepare];
    [self showAnimation];
}


- (void)showAnimation {
    if (_isAnimation) { return; }
    _isAnimation = YES;
    [k_CWKeyWindow addSubview:self];
    [UIView animateWithDuration:self.timeInterval delay:0.0 usingSpringWithDamping:self.springWithDamping initialSpringVelocity:self.initialSpringVelocity options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self dismissPrepare];
    } completion:^(BOOL finished) {
        self->_isAnimation = NO;
        if (self.showCompletion) { self.showCompletion(); }
    }];
}


- (void)dismiss {
    [self dismissWithCompletion:^{
        
    }];
}


- (void)dismissWithCompletion:(void (^)(void))completion {
    [self setDismissCompletion:completion];
    [self dismissPrepare];
    [self dismissAnimation];
}

- (void)dismissAnimation {
    if (_isAnimation) { return; }
    _isAnimation = YES;
    [UIView animateWithDuration:self.timeInterval delay:0.0 usingSpringWithDamping:self.springWithDamping initialSpringVelocity:self.initialSpringVelocity options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self showPrepare];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self->_isAnimation = NO;
        if (self.dismissCompletion) { self.dismissCompletion(); }
    }];
}


- (void)showPrepare {
    self.bgView.alpha = 0.0;
    if (_style == CWAlertStyle_Bottom) {
        self.contentView.layer.affineTransform = CGAffineTransformMakeTranslation(0, self.contentView.frame.size.height + [self bottomSpace]);
    }
    else if (_style == CWAlertStyle_Center) {
        self.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.contentView.alpha = 0.0;
    }
}


- (void)dismissPrepare {
    self.bgView.alpha = 1.0;
    if (_style == CWAlertStyle_Bottom) {
        self.contentView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    }
    else if (_style == CWAlertStyle_Center) {
        self.contentView.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
        self.contentView.alpha = 1.0;
    }
}

- (void)setStyle:(CWAlertStyle)style {
    if (_style == style) { return; }
    _style = style;
    self.contentView = self.contentView;
}


#pragma mark - Setter && Getter
- (void)setContentView:(UIView *)contentView {
    if (_contentView && _contentView.superview) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    _contentView.layer.affineTransform = CGAffineTransformIdentity;
    if (_style == CWAlertStyle_Bottom) {
        _contentView.frame = CGRectMake(0, k_CWAlertTool_ScreenHeight - contentView.frame.size.height - [self bottomSpace], contentView.frame.size.width, contentView.frame.size.height);
    }
    else if (_style == CWAlertStyle_Center) {
        _contentView.center = CGPointMake(k_CWAlertTool_ScreenWidth * 0.5, k_CWAlertTool_ScreenHeight * 0.5);
    }
    [self addSubview:_contentView];
}

- (CGFloat)bottomSpace {
    return (k_CWiPhoneX ? 34 : 0);
}
@end
