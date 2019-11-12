//
//  SKInputView.m
//  SKInputView
//
//  Created by KentSun on 2019/8/17.
//  Copyright © 2019 KentSun. All rights reserved.
//

#import "SKInputView.h"
#import "SKTextField.h"
#import "Masonry.h"

#define contentViewH 136

@interface SKInputView()<UITextFieldDelegate>

@property (nonatomic ,weak) UIButton *saveBtn;
/** 弹窗主内容view */
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic ,weak) UIView *toolView;
@property (nonatomic ,weak) SKTextField *textField;

/// 弹窗标题
@property (nonatomic, copy) NSString *title;
/// UITextField 居左文字
@property (nonatomic, copy) NSString *placeholderText;
/// 限制输入字数
@property (nonatomic, assign)NSInteger maxLength;
/// 键盘类型
@property (nonatomic, assign) UIKeyboardType keyboardType;
/// textField 数量
@property (nonatomic, assign) SKInputViewNumType inputViewNumType;
@property (nonatomic ,weak) SKTextField *textFieldTwo;

@end

@implementation SKInputView

- (instancetype)initWithTitle:(NSString *)title placeholderText:(NSString *)placeholderText{
    if (self = [super init]) {
        _title = title;
        _placeholderText = placeholderText;
        _maxLength = 0;
        _keyboardType = UIKeyboardTypeDefault;
        _inputViewNumType = SKInputViewNumTypeOne;
        
         [self setupUI];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title placeholderText:(NSString *)placeholderText maxLength:(NSInteger)maxLength keyboardType:(UIKeyboardType)keyboardType{
    if (self = [super init]) {
        _title = title;
        _placeholderText = placeholderText;
        _maxLength = maxLength;
        _keyboardType = keyboardType;
        _inputViewNumType = SKInputViewNumTypeOne;
        
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title placeholderText:(NSString *)placeholderText maxLength:(NSInteger)maxLength keyboardType:(UIKeyboardType)keyboardType inputViewNumType:(SKInputViewNumType)inputViewNumType{
    if (self = [super init]) {
        _title = title;
        _placeholderText = placeholderText;
        _maxLength = maxLength;
        _keyboardType = keyboardType;
        _inputViewNumType = inputViewNumType;
        
        [self setupUI];
    }
    return self;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI{
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    [self setupContentView];
    [self setupToolView];
    
    if (_inputViewNumType == SKInputViewNumTypeOne) {
        [self setupTextField];
    }else{ // SKInputViewNumTypeTwo
        [self setupTextFieldTwo];
    }
}

- (void)setupContentView{
    //------- 弹窗主内容 -------
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    self.contentView = contentView;
    self.contentView.backgroundColor = COLORFFFFFF();
    //画半角
    [self makeViewCornerRadius:self.contentView corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(contentViewH);
    }];
}


- (void)setupToolView{
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 48)];
    toolView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    [self.contentView addSubview:toolView];
    self.toolView = toolView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [toolView addSubview:titleLabel];
    titleLabel.text = _title;
    titleLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONTSIZE(18);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    
    UIButton *dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:dissBtn];
    [dissBtn setImage:[UIImage imageNamed:@"public_page_close"] forState:UIControlStateNormal];
    [dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    [dissBtn addTarget:self action:@selector(dissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:saveBtn];
    self.saveBtn = saveBtn;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:BRANDCOLOR() forState:UIControlStateNormal];
    [saveBtn setTitleColor:COLOREDEDED() forState:UIControlStateDisabled];
    saveBtn.enabled = YES;
    saveBtn.titleLabel.font = FONTBOLDSIZE(16);
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.height.mas_equalTo(24);
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupTextField{
    
    SKTextField *textField = [self createTextField];
    [self.contentView addSubview:textField];
    self.textField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.toolView.mas_bottom).offset(24);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = _placeholderText;
    placeholderLabel.font = FONTSIZE(16);
    placeholderLabel.textColor = MAINCOLOR();
    placeholderLabel.textAlignment = NSTextAlignmentLeft;
    [textField addSubview:placeholderLabel];
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-16);
    }];
    
}

- (void)setupTextFieldTwo{
    
    self.saveBtn.enabled = NO;
    // 中间label
    UILabel *middleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:middleLabel];
    middleLabel.text = @"至";
    middleLabel.font = FONTSIZE(16);
    middleLabel.textColor = MAINCOLOR();
    middleLabel.textAlignment = NSTextAlignmentCenter;
    [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolView.mas_bottom).offset(24);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
    }];
    
    //第一个textfield
    SKTextField *textField = [self createTextField];
    [self.contentView addSubview:textField];
    self.textField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolView.mas_bottom).offset(24);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
        make.right.equalTo(middleLabel.mas_left).offset(-8);
    }];
    
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = _placeholderText;
    placeholderLabel.font = FONTSIZE(16);
    placeholderLabel.textColor = MAINCOLOR();
    placeholderLabel.textAlignment = NSTextAlignmentLeft;
    [textField addSubview:placeholderLabel];
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-16);
    }];
    
    //第二个textfield
    SKTextField *textFieldTwo = [self createTextField];
    [self.contentView addSubview:textFieldTwo];
    self.textFieldTwo = textFieldTwo;
    [textFieldTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolView.mas_bottom).offset(24);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
        make.left.equalTo(middleLabel.mas_right).offset(8);
    }];
    
    UILabel *placeholderLabelTwo = [[UILabel alloc] init];
    placeholderLabelTwo.text = _placeholderText;
    placeholderLabelTwo.font = FONTSIZE(16);
    placeholderLabelTwo.textColor = MAINCOLOR();
    placeholderLabelTwo.textAlignment = NSTextAlignmentLeft;
    [textFieldTwo addSubview:placeholderLabelTwo];
    [placeholderLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-16);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (SKTextField *)createTextField{
    SKTextField *textField = [[SKTextField alloc] init];
    textField.maxLength = _maxLength;
    textField.backgroundColor = [UIColor colorWithRed:250/255.0 green:244/255.0 blue:235/255.0 alpha:1.0];
    textField.keyboardType = _keyboardType;
    textField.font = FONTSIZE(16);
    textField.textColor = MAINCOLOR();
    textField.textAlignment = NSTextAlignmentLeft;
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.cornerRadius = 8;
    textField.layer.borderColor = MAINCOLOR().CGColor;
    textField.layer.borderWidth = 1;
    textField.returnKeyType = UIReturnKeyDone;
    textField.leftViewMode = UITextFieldViewModeWhileEditing;
    textField.tintColor = MAINCOLOR(); //光标颜色
//    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}


- (void)saveBtnClick{
    //验证是否有值
    NSString *text = ValidStr(self.textField.text) ? self.textField.text : nil ;
    NSString *textTwo = ValidStr(self.textFieldTwo.text) ? self.textFieldTwo.text: nil ;
    if (self.inputTextBlock) {
        self.inputTextBlock(text, textTwo);
    }
    [self dismiss];
}

- (void)dissBtnClick{
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
    [self dismiss];
}

#pragma mark - 弹窗展示/隐藏
/** 弹出此弹窗 */
- (void)show {
    // 出场动画
    self.alpha = 0;
    //self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1.3, 1.3);
  
    [UIView animateWithDuration:0.01 animations:^{
        self.alpha = 1;
        //self.contentView.transform = CGAffineTransformIdentity;
//        self.contentView.transform = CGAffineTransformMakeTranslation(0, ScreenH-contentViewH);
    } completion:^(BOOL finished) {
        //弹出键盘
        [self.textField becomeFirstResponder];
    }];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
}

/** 移除此弹窗 */
- (void)dismiss {
//    NSString *text = ValidStr(self.textField.text) ? self.textField.text : nil ;
//    NSString *textTwo = ValidStr(self.textFieldTwo.text) ? self.textFieldTwo.text: nil ;
//    if (self.inputTextBlock) {
//        self.inputTextBlock(text, textTwo);
//    }
    [self removeFromSuperview];
}



#pragma mark - 处理键盘显示/隐藏
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    //    NSLog(@"%@", noti);
    //获取键盘的frame
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //修改底部约束 (屏幕的高度 - 键盘的y值 就是文本框底部间距)
    CGFloat contentViewBottom = nScreenHeight() - frame.origin.y;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-contentViewBottom);
    }];
    //修改执行退出时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        //强制刷新
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  画半角
 */
- (void)makeViewCornerRadius:(UIView *)view corners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *stateLbPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *stateLayer = [[CAShapeLayer alloc] init];
    stateLayer.frame = view.bounds;
    stateLayer.path = stateLbPath.CGPath;
    view.layer.mask = stateLayer;
}


- (void)textDidChangeNotification{
    if(self.inputViewNumType == SKInputViewNumTypeTwo){
        NSString *text = self.textField.text;
        NSString *textTwo = self.textFieldTwo.text;
        if (ValidStr(text) && ValidStr(textTwo)) {
            self.saveBtn.enabled = YES;
        }else{
            self.saveBtn.enabled = NO;
        }
    }
}




@end
