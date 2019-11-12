//
//  SKTextField.h
//  SKInputView
//
//  Created by KentSun on 2019/7/17.
//  Copyright © 2019 KentSun. All rights reserved.
//

// 没有下划线TextField
// 如果需要自定义UITextField的delegate，请用textField.bridgeDelegate = self 代替 textField.delegate = self
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKTextField : UITextField <UITextFieldDelegate>

/// 最大字数，emoji算两个字，中英文都算一个字。
@property(nonatomic, assign) NSInteger maxLength;

/// 如果需要自定义UITextField的delegate，请用textField.bridgeDelegate = self 代替 textField.delegate = self
@property(nonatomic, weak) id<UITextFieldDelegate> bridgeDelegate;

@end

NS_ASSUME_NONNULL_END
