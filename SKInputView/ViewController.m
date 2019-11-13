//
//  ViewController.m
//  SKInputView
//
//  Created by KentSun on 2019/11/6.
//  Copyright © 2019 KentSun. All rights reserved.
//

#import "ViewController.h"
#import "SKInputView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 100, 200, 50);
    [self.view addSubview:btn1];
    [btn1 setTitle:@"弹出一个TextField" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 20;
    btn1.layer.borderColor = [UIColor blueColor].CGColor;
    btn1.layer.borderWidth = 2;
    [btn1 addTarget:self action:@selector(inputOneTextField:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 200, 200, 50);
    [self.view addSubview:btn2];
    [btn2 setTitle:@"弹出两个TextField" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.layer.cornerRadius = 20;
    btn2.layer.borderColor = [UIColor redColor].CGColor;
    btn2.layer.borderWidth = 2;
    [btn2 addTarget:self action:@selector(inputTwoTextField:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)inputOneTextField:(UIButton *)sender{
    SKInputView *skInputView = [[SKInputView alloc] initWithTitle:@"人均费用" placeholderText:@"元/人" maxLength:0 keyboardType:UIKeyboardTypeDecimalPad];
    [skInputView show];
    
    skInputView.inputTextBlock = ^(NSString * _Nullable text, NSString * _Nullable textTwo) {
        NSLog(@"%@ 元/人", text);
    };
    
}

- (void)inputTwoTextField:(UIButton *)sender{
    SKInputView *skInputView = [[SKInputView alloc] initWithTitle:@"年龄段范围" placeholderText:@"岁" maxLength:2 keyboardType:UIKeyboardTypeNumberPad inputViewNumType:SKInputViewNumTypeTwo];
    [skInputView show];
    
    skInputView.inputTextBlock = ^(NSString * _Nullable text, NSString * _Nullable textTwo) {
        if (ValidStr(text) && ValidStr(textTwo)) {
            if (text.intValue < textTwo.intValue) {
                NSLog(@"%@ 至 %@ 岁", text , textTwo);
            }else{
                NSLog(@"最小年龄不能大于最大年龄");
            }
        }else{
            NSLog(@"两个TextField都没有输入内容");
        }
    };
    
}


@end
