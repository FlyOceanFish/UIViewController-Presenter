//
//  UIViewController+Presenter.m
//
//  Created by FlyOceanFish on 2017/8/17.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import "UIViewController+Presenter.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, YTOPresentAnimalDirection) {
    YTOPresentAnimalUp,//动画往上移动
    YTOPresentAnimalDown,//动画往下逐渐变大
};

NSTimeInterval const AnimalTime = 0.35;

static char const*backgroundViewKey = "BackgroundViewKey";
static char const*animalDirectionViewKey = "animalDirectionKey";

@implementation UIViewController (Presenter)

- (UIView *)backgroundView{
    return objc_getAssociatedObject(self, backgroundViewKey);
}
- (void)setBackGroundView:(UIView *)view{
    objc_setAssociatedObject(self, backgroundViewKey, view, OBJC_ASSOCIATION_RETAIN);
}
- (YTOPresentAnimalDirection)animalDirection{
    NSNumber *direction = objc_getAssociatedObject(self, animalDirectionViewKey);
    return direction.intValue;
}
- (void)setanimalDirection:(YTOPresentAnimalDirection)direction{
    objc_setAssociatedObject(self, animalDirectionViewKey, @(direction), OBJC_ASSOCIATION_ASSIGN);
}
- (void)yto_presentInViewController:(UIViewController *)parent{
    [self setanimalDirection:YTOPresentAnimalUp];
    [self privat_addBackgroudView:parent.view];
    float height = CGRectGetHeight(parent.view.bounds);
    [self private_showFromPoint:CGPointMake(self.view.frame.origin.x, height) direction:YTOPresentAnimalUp parent:parent];
}
- (void)yto_presentInViewController:(UIViewController *)parent fromPoint:(CGPoint)point{
    [self setanimalDirection:YTOPresentAnimalDown];
    [self private_showFromPoint:point direction:YTOPresentAnimalDown parent:parent];
}
- (void)private_showFromPoint:(CGPoint)point direction:(YTOPresentAnimalDirection)direction parent:(UIViewController *)parent{
    float originHeight = CGRectGetHeight(self.view.bounds);
    self.view.frame = CGRectMake(point.x,point.y, CGRectGetWidth(parent.view.bounds), direction==YTOPresentAnimalUp?CGRectGetHeight(self.view.bounds):0);
    [parent addChildViewController:self];
    [parent.view addSubview:self.view];
    [self didMoveToParentViewController:parent];
    if (direction==YTOPresentAnimalUp) {
        [UIView animateWithDuration:AnimalTime animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(point.x, -CGRectGetHeight(self.view.bounds));
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:AnimalTime animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, CGRectGetWidth(self.view.bounds), originHeight);
        } completion:^(BOOL finished) {
            
        }];
    }

}
- (void)yto_dismissViewController{
    if ([self animalDirection]==YTOPresentAnimalUp) {
        [UIView animateWithDuration:AnimalTime animations:^{
            self.view.transform = CGAffineTransformIdentity;
            [self backgroundView].alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
            [[self backgroundView] removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:AnimalTime animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, CGRectGetWidth(self.view.bounds), 0);
            [self backgroundView].alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
            [[self backgroundView] removeFromSuperview];
        }];
    }

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
