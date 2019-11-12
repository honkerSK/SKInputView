//
//  SKInputView.h
//  SKInputView
//
//  Created by KentSun on 2019/8/17.
//  Copyright © 2019 KentSun. All rights reserved.
//

//输入内容弹窗 带textfield
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SKInputViewNumType) {
    SKInputViewNumTypeOne, //一个textfield
    SKInputViewNumTypeTwo //两个textfield
};

@interface SKInputView : UIView
/// 返回输入文本
//@property (nonatomic, copy) void (^inputTextBlock)(NSString *text);

@property (nonatomic, copy) void (^inputTextBlock)(NSString *_Nullable text ,NSString * _Nullable textTwo);


- (instancetype)initWithTitle:(NSString *)title placeholderText:(NSString *)placeholderText;
- (instancetype)initWithTitle:(NSString *)title placeholderText:(NSString *)placeholderText maxLength:(NSInteger)maxLength keyboardType:(UIKeyboardType)keyboardType;

/**
 返回带textfield的弹窗
 
 @param title 弹窗标题
 @param placeholderText 弹窗内文本
 @param maxLength 限制输入字数
 @param keyboardType 弹出键盘类型
 @param inputViewNumType textField 数量
 @return 返回底部弹窗
 */
- (instancetype)initWithTitle:(NSString *)title placeholderText:(NSString *)placeholderText maxLength:(NSInteger)maxLength keyboardType:(UIKeyboardType)keyboardType inputViewNumType:(SKInputViewNumType)inputViewNumType ;


/** show出这个弹窗 */
- (void)show;


@end

NS_ASSUME_NONNULL_END
