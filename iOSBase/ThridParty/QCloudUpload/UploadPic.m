//
//  UploadPic.m
//  Training
//
//  Created by 李林 on 2017/4/30.
//  Copyright © 2017年 胡惜. All rights reserved.
//

#import "UploadPic.h"


@interface UploadPic(){
    int64_t currentTaskid;
}

@end

@implementation UploadPic
+ (instancetype)sharedInstance{
    static UploadPic *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        //kSdkAppId
        instance.myClient = [[COSClient alloc] initWithAppId:@"1254340937" withRegion:@"gz"];
        //设置htpps请求
        [instance.myClient openHTTPSrequset:YES];
        instance.dataArray = [NSMutableArray array];
    });
    return instance;
}



-(void)uploadFileMultipartWithPath:(NSString *)filePath fileName:(NSString*)fileName
              callback:(UploadStatusCallBack)callback
{
    COSObjectPutTask *task = [[COSObjectPutTask alloc] init];
    NSLog(@"-send---taskId---%lld",task.taskId);
    task.multipartUpload = YES;
    currentTaskid = task.taskId;
    NSLog(@"photoPath=%@",filePath);
    task.filePath = filePath;
    task.fileName = fileName;
    task.bucket = @"ala";
    task.attrs = @"customAttribute";
    task.directory = @"file";
    task.insertOnly = YES;
    

    RequestParams *parms = [[RequestParams alloc] initWithParams:API_SIGNCREATE];
    
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"upload" successBlock:^(id data) {
        
            task.sign = data[@"pd"][@"sign"];
            [_myClient putObject:task];
            NSLog(@"sign:%@",task.sign);
        
    } failureBlock:^(NSError *error) {
        if (callback) {
            callback(@"");
        }
    }];

    __weak typeof(self) weakSelf = self;
    _myClient.completionHandler = ^(COSTaskRsp *resp, NSDictionary *context){
        COSObjectUploadTaskRsp *rsp = (COSObjectUploadTaskRsp *)resp;
        if (rsp.retCode == 0) {
            NSLog(@"context  = %@",rsp.sourceURL);
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (callback) {
                callback(rsp.sourceURL);
            }
            [strongSelf.dataArray addObject:rsp.sourceURL];
        }else{
            NSLog(@"-error--%@",rsp.descMsg);
            if (callback) {
                callback(@"");
            }
           
        }
    };

}

- (NSString *)photoSavePathForURL:(NSURL *)url
{
    
    NSString *photoSavePath = nil;
    NSString *urlString = [url absoluteString];
    NSString *uuid = nil;
    if (urlString) {
        uuid = [QCloudUtils findUUID:urlString];
    } else {
        uuid = [QCloudUtils uuid];
    }
    
    NSString *resourceCacheDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/UploadPhoto/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:resourceCacheDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:resourceCacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    photoSavePath = [resourceCacheDir stringByAppendingPathComponent:uuid];
    
    return photoSavePath;
    
}
@end
