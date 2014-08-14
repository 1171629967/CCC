//
//  WLXTableViewController.m
//  LearnIOS
//
//  Created by 王 李鑫 on 14-8-11.
//  Copyright (c) 2014年 王 李鑫. All rights reserved.
//

#import "WLXTableViewController.h"
#import "Fans.h"
#import "FansCellTableViewCell.h"
#import "IconDownloader.h"

@interface WLXTableViewController ()

@end

@implementation WLXTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.iconCache = [[TQImageCache alloc] initWithCachePath:@"icons" andMaxMemoryCacheNumber:50];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    fans = [[NSMutableArray alloc] init];
   
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) refreshData
{
    [self performSelector:@selector(handleData) withObject:nil afterDelay:2];
}


- (void) handleData
{
    
    Fans *f1 = [[Fans alloc] initWidthFaceurl:@"http://h.hiphotos.baidu.com/image/pic/item/7af40ad162d9f2d378dde4e6abec8a136227ccef.jpg"];
    Fans *f2 = [[Fans alloc] initWidthFaceurl:@"http://c.hiphotos.baidu.com/image/pic/item/adaf2edda3cc7cd947f4acd03b01213fb90e91da.jpg"];
    Fans *f3 = [[Fans alloc] initWidthFaceurl:@"http://b.hiphotos.baidu.com/image/pic/item/29381f30e924b899580265306c061d950a7bf6f8.jpg"];
    Fans *f4 = [[Fans alloc] initWidthFaceurl:@"http://d.hiphotos.baidu.com/image/pic/item/fcfaaf51f3deb48f57e422f1f11f3a292df57814.jpg"];
    
    [fans addObject:f1];
    [fans addObject:f2];
    [fans addObject:f3];
    [fans addObject:f4];
    
    
    
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    
}




- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",[indexPath row]];
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:key];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgRecord = imgRecord;
        iconDownloader.index = key;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:key];
        [iconDownloader startDownload];
    }
}


- (void)appImageDidLoad:(NSString *)index
{
    int _index = [index intValue];
    if (_index >= [fans count]) {
        return;
    }
    Fans *f = [fans objectAtIndex:[index intValue]];
    if (f) {
        IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:index];
        if (iconDownloader) {
            f.imgData = iconDownloader.imgRecord.img;
        }
        
       
        
        f.height = f.imgData.size.height;
        
        // cache it
        NSData * imageData = UIImagePNGRepresentation(f.imgData);
        [self.iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:f.faceUrl]];
        [self.tableView reloadData];
    }
}



-(void)viewDidUnload
{
    self.iconCache = nil;
    [self.imageDownloadsInProgress removeAllObjects];
    self.imageDownloadsInProgress = nil;
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return fans.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Fans * f = [fans objectAtIndex:[indexPath row]];
    
    
    
    return 20+f.height;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellId = @"cellId";
    
  
    
    
    FansCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"FansCellTableViewCell" owner:self options:nil];
        
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[FansCellTableViewCell class]]) {
                cell = (FansCellTableViewCell *)o;
                break;
            }
        }
    }
    
    
    
    Fans *f = [fans objectAtIndex:[indexPath row]];
   
    
    
    
    
    
    //头像
    if (f.imgData == nil) {
        if ([f.faceUrl isEqualToString:@""]) {
            f.imgData = [UIImage imageNamed:@"ic.jpg"];
        }
        else
        {
            NSData * imageData = [self.iconCache getImage:[TQImageCache parseUrlForCacheName:f.faceUrl]];
            if (imageData) {
                NSLog(@"load image from cache");
                f.imgData = [UIImage imageWithData:imageData];
                cell.imageView.image = f.imgData;
                f.height = cell.imageView.image.size.height;
                
            } else {
                IconDownloader *downloader = [self.imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                if (downloader == nil) {
                    ImgRecord *record = [ImgRecord new];
                    record.url = f.faceUrl;
                    [self startIconDownload:record forIndexPath:indexPath];
                }
            }
            
        }
    }
    else
    {
        cell.imageView.image = f.imgData;
    }
    
    
    
    
    cell.imageView.frame = CGRectMake(10, 10, 200, f.height);
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
