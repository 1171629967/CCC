//
//  Fans.h
//  LearnIOS
//
//  Created by 王 李鑫 on 14-8-13.
//  Copyright (c) 2014年 王 李鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fans : NSObject

@property (copy, nonatomic) NSString *faceUrl;
@property (nonatomic,retain) UIImage * imgData;

@property int height;

- (id)initWidthFaceurl:(NSString *)newfaceUrl;

@end
