//
//  WLXViewController.h
//  LearnIOS
//
//  Created by 王 李鑫 on 14-8-11.
//  Copyright (c) 2014年 王 李鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "WLXTableViewController.h"

@interface WLXViewController : UIViewController

@property (strong, nonatomic) WLXTableViewController *tableVC;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;

@property (strong, nonatomic) IBOutlet UIButton *buttonClick;


- (IBAction)click:(id)sender;
@end
