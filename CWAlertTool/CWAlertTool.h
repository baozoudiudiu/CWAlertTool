//
//  CWAlertTool.h
//  CWAlertTool
//
//  Created by 罗泰 on 2019/6/17.
//  Copyright © 2019 chenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_CWAlertTool_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define k_CWAlertTool_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define k_CWiPhoneX (k_CWAlertTool_ScreenHeight >= 812)
#define k_CWKeyWindow [UIApplication sharedApplication].keyWindow

typedef NS_ENUM(NSUInteger, CWAlertStyle) {
    CWAlertStyle_Center                 = 0,    ///< 中间弹出
    CWAlertStyle_Bottom                 = 1,    ///< 底部弹出
    CWAlertStyle_Unkonwn                = 99,   ///< 未知类型
};


NS_ASSUME_NONNULL_BEGIN

@class CWAlertTool;
@protocol CWAlertToolDelegate <NSObject>
@optional
@property (nonatomic, weak) CWAlertTool                     *alertTool;
@end


@interface CWAlertTool : UIView
/**
 弹出风格
 */
@property (nonatomic, assign) CWAlertStyle        style;

/**
 弹出框
 */
@property (nonatomic, strong) UIView                        *contentView;

/**
 动画时间 默认: 0.25
 */
@property (nonatomic, assign) NSTimeInterval                timeInterval;

/**
 是否处于动画中
 */
@property (nonatomic, assign, readonly) BOOL                isAnimation;

/**
 阻尼系数, 默认 0.7 (0 ~ 1)
 */
@property (nonatomic, assign) CGFloat                       springWithDamping;

/**
 弹性速率, 默认 0.5
 */
@property (nonatomic, assign) CGFloat                       initialSpringVelocity;


+ (void)showContentView:(UIView *)contentView withStyle:(CWAlertStyle)style completion:(void(^)(void))completion;
- (instancetype)initWithStyle:(CWAlertStyle)style contentView:(UIView *)contentView;
- (void)show;
- (void)showWithCompletion:(void(^)(void))completion;
- (void)dismiss;
- (void)dismissWithCompletion:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
