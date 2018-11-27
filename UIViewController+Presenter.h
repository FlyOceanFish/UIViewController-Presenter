//
//  UIViewController+Presenter.h
//
//  Created by FlyOceanFish on 2017/8/17.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Presenter)

@property(nonatomic,assign,readonly,getter=isVisible)BOOL visible;

- (void)yto_presentInViewController:(UIViewController *)parent;
- (void)yto_presentInViewController:(UIViewController *)parent fromPoint:(CGPoint)point;
- (void)yto_presentInViewController:(UIViewController *)parent fromPoint:(CGPoint)point fullScreen:(BOOL)fullScreen;
- (void)yto_dismissViewController:(BOOL)animal;

@end
