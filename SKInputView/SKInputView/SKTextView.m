//
//  SKTextView.m
//  SKInputView
//
//  Created by KentSun on 2019/9/9.
//  Copyright © 2019 KentSun. All rights reserved.
//

#import "SKTextView.h"
#import "Masonry.h"

@interface SKTextView()<UITextViewDelegate>
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *countLb;
@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation SKTextView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UITextView *textView = [[UITextView alloc] init];
    textView.textColor = MAINCOLOR();
    textView.font = FONTSIZE(14);
    textView.backgroundColor = COLORF9F9F9();
    textView.tintColor = MAINCOLOR();
    textView.textColor = MAINCOLOR();
    textView.layer.borderWidth = 0.5f;
    textView.layer.borderColor = COLOREDEDED().CGColor;
//    [textView makeRoundedCorner:4];
    textView.layer.cornerRadius = 4;
    
    [self addSubview:textView];
    self.textView = textView;
    textView.delegate = self;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];
    textView.textContainerInset = UIEdgeInsetsMake(6, 8, 6, 8);
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(8);
    }];
    
    UILabel *countLb = [[UILabel alloc] init];
    countLb.font = FONTSIZE(12);
    countLb.textColor = COLOR888888();
    [self addSubview:countLb];
    self.countLb = countLb;
    [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(4);
        //make.height.mas_equalTo(16);
        //make.bottom.equalTo(self);
        make.right.equalTo(textView);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChangeText:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setLimit:(NSInteger)limit {
    _limit = limit;
    self.countLb.text = [NSString stringWithFormat:@"0/%ld",limit];
}
-(void)setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
    self.countLb.text = [NSString stringWithFormat:@"%ld/%ld",text.length,self.limit];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
}
- (UILabel *)placeholderLabel {
    if (_placeholderLabel) return _placeholderLabel;
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.textColor = COLORCCCCCC();
    placeholderLabel.font = FONTSIZE(14);
    placeholderLabel.numberOfLines = 0;
    [self.textView addSubview:placeholderLabel];
    _placeholderLabel = placeholderLabel;
    return _placeholderLabel;
}


#pragma mark UITextViewDelegate
// 将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.backgroundColor = COLORFAF4EB();
    self.placeholderLabel.hidden = YES;
    if (self.textViewShouldBeginEditingBlock) {
        self.textViewShouldBeginEditingBlock(YES);
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    textView.backgroundColor = COLORF9F9F9();
    self.text = textView.text;
    
    NSInteger length = self.text.length;
    if (length > 0) { // 显示隐藏占位符
        self.placeholderLabel.hidden = YES;
    }else {
        self.placeholderLabel.hidden = NO;
    }
    if(self.textViewDidEndEditingBlock){
        self.textViewDidEndEditingBlock(NO);
    }
}
// 监听到 键盘输入 时的文本发生改变
- (void)textViewDidChangeText:(NSNotification *)notification {
    
    NSString *text = self.textView.text;
    if (self.textFieldBlock) {
        self.textFieldBlock(text);
    }
    NSInteger length = text.length;
    self.countLb.text = [NSString stringWithFormat:@"%ld/%ld",length,self.limit];
    UIColor *color = (length == 1 ||length > self.limit)? WARNINGCOLOR():MAINCOLOR();
    CGColorRef border = (length == 1 ||length > self.limit)? WARNINGCOLOR().CGColor:COLOREDEDED().CGColor;
    self.countLb.textColor = color;
    self.textView.layer.borderColor = border;
    self.textView.textColor = color;
    
}




@end
