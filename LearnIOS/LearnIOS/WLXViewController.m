//
//  WLXViewController.m
//  LearnIOS
//
//  Created by 王 李鑫 on 14-8-11.
//  Copyright (c) 2014年 王 李鑫. All rights reserved.
//

#import "WLXViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface WLXViewController ()

@end

@implementation WLXViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableVC = [[WLXTableViewController alloc] init];
    
    
    
    [self loadNetData];
    
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void) loadNetData
{

    NSString *urlString = @"http://10.15.52.53/smilelife/SmileApi/index?t=app/GetLoginUserInfo&appkey=691E2354-D091-EEF6-892F-0CB1EB4586EC&phoneType=Samsung%20Galaxy%20S2%20-%204.1.1%20-%20API%2016%20-%20480x800&happyliveVersionCode=1&osVersionCode=16&accessToken=4243b3aa-d901-4ee0-be63-071aa965738d&osType=Android";

    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    NSString *faceUrl = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"Face"]];
        NSLog(@"dizhi------------->%@",faceUrl);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:faceUrl]];
            UIImage *image = [UIImage imageWithData:data];
            NSLog(@"aa------------->");
            if (image != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"bb------------->");
                    self.imageview.image = image;
                });
            }
            else
            {
                NSLog(@"shibai------------->");
            }
            
            
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败----------->%@",error);
    }];

    
    
    
    
    

    
    
    
    
    

}





-(NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}









- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {
    
    [self.navigationController pushViewController:self.tableVC animated:YES];
}
@end
