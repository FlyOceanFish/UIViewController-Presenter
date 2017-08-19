//
//  UIViewController+Presenter.m
//
//  Created by FlyOceanFish on 2016/6/23.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import "UIViewController+Presenter.h"
#import <objc/runtime.h>

NSTimeInterval const AnimalTime = 0.35;

static char const*backgroundViewKey = "BackgroundViewKey";

@implementation UIViewController (Presenter)

- (UIView *)backgroundView{
    return objc_getAssociatedObject(self, backgroundViewKey);
}
- (void)setBackGroundView:(UIView *)view{
    objc_setAssociatedObject(self, backgroundViewKey, view, OBJC_ASSOCIATION_RETAIN);
}
- (void)yto_presentInViewController:(UIViewController *)parent{
    [self privat_addBackgroudView:parent.view];
    float height = CGRectGetHeight(parent.view.bounds);
    self.view.frame = CGRectMake(self.view.frame.origin.x,height, CGRectGetWidth(parent.view.bounds), CGRectGetHeight(self.view.bounds));
    
    [parent addChildViewController:self];
    [parent.view addSubview:self.view];
    [self didMoveToParentViewController:parent];
    [UIView animateWithDuration:AnimalTime animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.origin.x, -CGRectGetHeight(self.view.bounds));
    } completion:^(BOOL finished) {
        
    }];
}
- (void)yto_dismissViewController{
    [UIView animateWithDuration:AnimalTime animations:^{
        self.view.transform = CGAffineTransformIdentity;
        [self backgroundView].alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        [[self backgroundView] removeFromSuperview];
    }];
}
- (void)privat_addBackgroudView:(UIView *)superView{
    UIView *background = [[UIView alloc] initWithFrame:superView.frame];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.3;
    [superView addSubview:background];
    [self setBackGroundView:background];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yto_dismissViewController)];
    [background addGestureRecognizer:tap];
    
}
@end
