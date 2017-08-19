//
//  UIViewController+Presenter.h
//
//  Created by FlyOceanFish on 2016/6/23.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Presenter)
- (void)yto_presentInViewController:(UIViewController *)parent;
- (void)yto_dismissViewController;
@end
