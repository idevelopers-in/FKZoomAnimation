//
// FKZoomAnimation.m
//
// Copyright (c) 2016 Firoz Khan
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "FKZoomAnimation.h"
#import <UIKit/UIKit.h>

@interface FKZoomAnimation()

@property (strong, nonatomic) __kindof UIView *fromView;
@property (strong, nonatomic) __kindof UIView *toView;
@property (strong, nonatomic) UIView *selfFrameView;
@property (strong, nonatomic) UIImageView *selectedImage;

@end

@implementation FKZoomAnimation

- (void)animateFromView:(__kindof UIView *)fromView toView:(__kindof UIView *)toView {
    
    _fromView = fromView;
    _toView = toView;
    
    CGRect cellframe = _fromView.frame;
    _selfFrameView = [[UIView alloc] initWithFrame:cellframe];
    _selfFrameView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    _selfFrameView.translatesAutoresizingMaskIntoConstraints = false;
    [toView addSubview:_selfFrameView];
    
    _selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _selfFrameView.frame.size.width, _selfFrameView.frame.size.width)];
    _selectedImage.layer.cornerRadius = _selectedImage.frame.size.width/2;
    _selectedImage.clipsToBounds = YES;
    _selectedImage.image = [UIImage imageNamed:@"test"];
    [_selfFrameView addSubview:_selectedImage];
    
    [UIView animateWithDuration:0.50 animations:^{
        [self->_selfFrameView setFrame:CGRectInset(self->_toView.safeAreaLayoutGuide.layoutFrame, 0, 0)];
        self->_selfFrameView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self->_selectedImage.layer.cornerRadius = 0;
        float dy = (self->_toView.frame.size.height - self->_toView.frame.size.width) / 2;
        [self->_selectedImage setFrame:CGRectInset(self->_selfFrameView.bounds, 0, dy)];
        
    } completion:^(BOOL finished) {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [backButton setFrame:CGRectMake(0, 0, 0, 0)];
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        backButton.tag = toView.tag;
        [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self->_selfFrameView addSubview:backButton];
        
        [UIView animateWithDuration:0.05 animations:^{
            [backButton setFrame:CGRectMake(0, 0, 60, 30)];
        }];
    }];
}

-(void)backButtonPressed:(UIButton *)sender{
    
        [UIView animateWithDuration:0.01 animations:^{
            [sender setFrame:CGRectMake(0, 0, 0, 0)];
        } completion:^(BOOL finished) {
    
            NSInteger tag = self->_fromView.tag;
    
            [UIView animateWithDuration:0.5 animations:^{
                [self->_selfFrameView setFrame:_fromView.frame];
                [self->_selectedImage setFrame:CGRectInset(self->_selfFrameView.bounds, 0, 0)];
    
                self->_selectedImage.layer.cornerRadius = self->_selectedImage.frame.size.width/2;
                self->_selectedImage.clipsToBounds = YES;
            } completion:^(BOOL finished) {
                [self->_selfFrameView removeFromSuperview];
//                _toView.scrollEnabled = YES;
            }];
        }];
}

@end
