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

static char const *backgroundViewKey = "BackgroundViewKey";
static char const *animalDirectionViewKey = "animalDirectionKey";
static char const *visibleKey = "visibleKey";

@implementation UIViewController (Presenter)
-(void)setVisible:(BOOL)visible{
    objc_setAssociatedObject(self, visibleKey, [NSNumber numberWithBool:visible], OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isVisible{
    NSNumber *number = objc_getAssociatedObject(self, visibleKey);
    return number.boolValue;
}
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
    float height = CGRectGetHeight(parent.view.bounds);
    [self private_showFromPoint:CGPointMake(self.view.frame.origin.x, height) direction:YTOPresentAnimalUp parent:parent];
    [self privat_addBackgroudView:parent.view];
}
- (void)yto_presentInViewController:(UIViewController *)parent fromPoint:(CGPoint)point{
    [self setanimalDirection:YTOPresentAnimalDown];
    [self private_showFromPoint:point direction:YTOPresentAnimalDown parent:parent];
    [self privat_addBackgroudView:parent.view];
}
- (void)private_showFromPoint:(CGPoint)point direction:(YTOPresentAnimalDirection)direction parent:(UIViewController *)parent{
    [self setVisible:YES];
    float originHeight = CGRectGetHeight(self.view.bounds);
    [parent addChildViewController:self];
    [parent.view addSubview:self.view];
    [self didMoveToParentViewController:parent];
    self.view.clipsToBounds = YES;
    self.view.frame = CGRectMake(point.x,point.y, CGRectGetWidth(parent.view.bounds), direction==YTOPresentAnimalUp?CGRectGetHeight(self.view.bounds):0);
    if (direction==YTOPresentAnimalUp) {
        [UIView animateWithDuration:AnimalTime animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(point.x, -CGRectGetHeight(self.view.bounds));
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:AnimalTime animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, CGRectGetWidth(self.view.bounds), originHeight);
        } completion:^(BOOL finished) {
//            [self setVisible:YES];
        }];
    }

}
- (void)yto_dismissViewController:(BOOL)animal{
    [self setVisible:NO];
    if (animal) {
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
    }else{
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        [[self backgroundView] removeFromSuperview];
    }
}
- (void)privat_addBackgroudView:(UIView *)superView{
    UIView *background = nil;
    if ([self animalDirection]==YTOPresentAnimalUp) {
        background = [[UIView alloc] initWithFrame:CGRectMake(superView.frame.origin.x, superView.frame.origin.y, CGRectGetWidth(superView.frame), CGRectGetHeight(superView.frame))];
    }else{
        background = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, CGRectGetWidth(superView.frame), CGRectGetHeight(superView.frame)-self.view.frame.origin.y)];
    }
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.3;
    [superView insertSubview:background belowSubview:self.view];
    [self setBackGroundView:background];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yto_dismissViewController:)];
    [background performSelector:@selector(addGestureRecognizer:) withObject:tap afterDelay:0.2];
    
}
@end
