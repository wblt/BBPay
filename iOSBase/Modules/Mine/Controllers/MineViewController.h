//
//  MineViewController.h
//  iOSBase
//
//  Created by 冷婷 on 2018/8/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface MineViewController : BaseViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate> //一定要声明这三个协议，缺一不可

@property(nonatomic,strong) UIImagePickerController *imagePicker; //声明全局的UIImagePickerController


@end
