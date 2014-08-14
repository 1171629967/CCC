//
//  WLXTableViewController.h
//  LearnIOS
//
//  Created by 王 李鑫 on 14-8-11.
//  Copyright (c) 2014年 王 李鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQImageCache.h"
#import "IconDownloader.h"

@interface WLXTableViewController : UITableViewController<IconDownloaderDelegate>
{
    NSMutableArray *fans;

}

@property (retain, nonatomic) TQImageCache *iconCache;
//异步加载图片
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;


- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath;
@end
