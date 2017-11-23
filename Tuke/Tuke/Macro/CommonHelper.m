//
//  CommonHelper.m
//  CMNewspaper
//
//  Created by zhu on 13-12-30.
//  Copyright (c) 2013年 zhu. All rights reserved.
//

#ifdef __IPHONE_5_0
#include <sys/xattr.h>
#endif

#import <zlib.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CommonCrypto/CommonDigest.h>

#import "regular.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UIImage+GIF.h"

#import "UIImage+YYImage.h"
#import "UIColor+KTUtilities.h"

//点击网址（打开链接／复制网址）
void clickWebUrl_phone(NSString *webUrl){
    if(![NSString isNilOrEmpty:webUrl])
    {
        NSString *tempWebUrl = getWebUrl(webUrl);

        UIAlertController * alertController = [regular getAlertWithFirstActionTitle:NSLocalizedString(@"打开链接",nil) FirstActionBlock:^{

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempWebUrl]];

        } SecondActionTwoTitle:NSLocalizedString(@"复制网址",nil) SecondActionBlock:^{

            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = tempWebUrl;
            [YYToast showToastWithTitle:NSLocalizedString(@"复制成功",nil) andDuration:kAlertToastDuration];

        }];
        UIViewController *currentVC = getCurrentViewController();
        [currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
void clickWebUrl_pad(NSString *webUrl ,UIView *clickView){
    if(![NSString isNilOrEmpty:webUrl])
    {
        NSString *tempWebUrl = getWebUrl(webUrl);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        alertController.view.backgroundColor=[UIColor clearColor];


        UIAlertAction *copyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"复制网址",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = tempWebUrl;

            [YYToast showToastWithTitle:NSLocalizedString(@"复制成功",nil) andDuration:kAlertToastDuration];
        }];

        UIAlertAction *openAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"打开",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempWebUrl]];
        }];

        [alertController addAction:openAction];
        [alertController addAction:copyAction];
        UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];

        popPresenter.sourceView = clickView;
        popPresenter.sourceRect = clickView.bounds;
        UIViewController *currentVC = getCurrentViewController();
        [currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
//打电话
void callSomeone(NSString *realPhoneNum, NSString *showPhoneNum){
    if(![NSString isNilOrEmpty:realPhoneNum]){
        UIViewController *currentVC = getCurrentViewController();
        UIAlertController * alertController = [regular getAlertWithFirstActionTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"呼叫 %@",nil),showPhoneNum] FirstActionBlock:^{

            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",realPhoneNum];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [currentVC.view addSubview:callWebview];
        } SecondActionTwoTitle:NSLocalizedString(@"复制",nil) SecondActionBlock:^{

            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = showPhoneNum;
            [YYToast showToastWithTitle:NSLocalizedString(@"复制成功",nil) andDuration:kAlertToastDuration];

        }];
        [currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
//发邮件
void sendEmail(NSString *email){
    if(![NSString isNilOrEmpty:email])
    {
        __block UIViewController *currentVC = getCurrentViewController();
        UIAlertController * alertController = [regular getAlertWithFirstActionTitle:NSLocalizedString(@"在邮箱中打开",nil) FirstActionBlock:^{

            //            [self SendByEmail:email];
            BOOL _b=[MFMailComposeViewController canSendMail];
            if(_b==YES)
            {
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];

                picker.mailComposeDelegate = currentVC;

                [picker setSubject:@"Enter Your Subject!"];

                // Set up recipients
                NSArray *toRecipients = [NSArray arrayWithObject:email];


                [picker setToRecipients:toRecipients];
                if ([picker.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
                    NSArray *list=currentVC.navigationController.navigationBar.subviews;
                    for (id obj in list) {
                        if ([obj isKindOfClass:[UIImageView class]]) {
                            UIImageView *imageView=(UIImageView *)obj;
                            NSArray *list2=imageView.subviews;
                            for (id obj2 in list2) {
                                if ([obj2 isKindOfClass:[UIImageView class]]) {
                                    UIImageView *imageView2=(UIImageView *)obj2;
                                    imageView2.hidden=YES;
                                }
                            }
                        }
                    }
                }

                picker.navigationBar.barTintColor = _define_white_color;
                [currentVC presentViewController:picker animated:NO completion:nil];

            }else
            {
                [YYToast showToastWithTitle:NSLocalizedString(@"请先设置邮箱帐号",nil) andDuration:kAlertToastDuration];
            }

        } SecondActionTwoTitle:NSLocalizedString(@"复制",nil) SecondActionBlock:^{

            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = email;
            [YYToast showToastWithTitle:NSLocalizedString(@"复制成功",nil) andDuration:kAlertToastDuration];

        }];
        [currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
UIViewController *getPresentedViewController(void){
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }

    return topVC;
}

//获取Window当前显示的ViewController
UIViewController *getCurrentViewController(void)
{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
//固定内容 字体下 获取高度
CGFloat getHeightWithWidth(CGFloat width,NSString *content, UIFont *font){
    CGSize titleSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize.height+1;
}

//固定内容 字体下 获取宽度
CGFloat getWidthWithHeight(CGFloat height,NSString *content, UIFont *font){
    CGSize titleSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize.width+1;
}

//UIView *setNavView(NSString *title,UIView *supview)
//{
//    UIView *_navView = [UIView getCustomViewWithColor:_define_white_color];
//    [supview addSubview:_navView];
//    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(20);
//        make.height.mas_equalTo(45);
//    }];
//
//    UIView *bottomview = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"d3d3d3"]];
//    [_navView addSubview:bottomview];
//    [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
//
//    UILabel *titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:title WithFont:18.0f WithTextColor:nil WithSpacing:0];
//    [_navView addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(-1);
//        make.centerX.mas_equalTo(_navView);
//        make.width.mas_equalTo(160);
//    }];
//
//    return _navView;
//}
NSDate *getDate(long time)
{
    return [NSDate dateWithTimeIntervalSince1970:time/1000];
}
NSString *getTimeStr(long time,NSString *formatter){
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];

    NSLog(@"date:%@",[detaildate description]);

    //实例化一个NSDateFormatter对象

    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];

    //设定时间格式,这里可以设置成自己需要的格式

    [dateFormatter setDateFormat:formatter];

    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];

    return currentDateStr;
}

void popWindowAddBgView(UIView *superView){
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = [UIColor whiteColor];
    tempView.alpha = 0.6;

    superView.backgroundColor = [UIColor clearColor];
    [superView insertSubview:tempView atIndex:0];
    __weak UIView *_weakView = superView;
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakView.mas_top);
        make.left.equalTo(_weakView.mas_left);
        make.bottom.equalTo(_weakView.mas_bottom);
        make.right.equalTo(_weakView.mas_right);

    }];
}

void moveViewByOffsetAndConstraint(UIView *view,CGFloat offset, NSLayoutConstraint *layoutConstraint){
    layoutConstraint.constant = offset;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        [UIView animateWithDuration:0.3 animations:^{
            [view layoutIfNeeded];
        }];
    }
}

void addAnimateWhenAddSubview(UIView *view){
    view.alpha = 0.0;
    [UIView animateWithDuration:kAddSubviewAnimateDuration animations:^{
        view.alpha = 1.0;
    }];
}

void removeFromSuperviewUseUseAnimateAndDeallocViewController(UIView *view,UIViewController *viewController){
    __block UIViewController *weakViewContorller = viewController;
    view.alpha = 1.0;
    [UIView animateWithDuration:kAddSubviewAnimateDuration animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        weakViewContorller = nil;
    }];
}

NSString *trimWhitespaceOfStr(NSString *string){
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//防止icloud备份
BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL)
{

    NSError *error = nil;
    BOOL success = [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }

    return success;
}


NSString *getShowDateByFormatAndTimeInterval(NSString *format,NSString *timeInterval){
    float millisecond = [timeInterval doubleValue];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millisecond/1000];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];

    [dateFormatter setDateFormat:format];

    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}

NSComparisonResult compareNowDate(NSString *timeInterval){
    float millisecond = [timeInterval doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millisecond/1000];
    //NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    float nowtime = (((int64_t)[[NSDate date] timeIntervalSince1970]/86400)*86400);
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:nowtime];
    float curtime = millisecond/1000;
    if(curtime < nowtime){
        return NSOrderedAscending;
    }else{
        return NSOrderedDescending;
    }//NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
    return [date compare:nowDate];
}

NSString *GetDocumentPath()
{
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);

    return [[filePaths objectAtIndex: 0] stringByAppendingPathComponent:@"Private Documents"];
}

NSString *GetApplicationPath(NSString *applicationPathName)
{
    NSString *appPath = GetDocumentPath();

    return [appPath stringByAppendingPathComponent:applicationPathName];
}

NSString *GetCachePath(NSString *applicationPathName, NSString *cachePathName, BOOL willCreate)
{
    NSString *cachePath = GetApplicationPath(applicationPathName);

    cachePath = [cachePath stringByAppendingPathComponent:cachePathName];
    if(cachePath && willCreate)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:cachePath])
        {
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }

    return cachePath;
}
//历史账号存放路径
NSString *getUsersStorePath(void){
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [filePaths objectAtIndex: 0];
    docPath = [docPath stringByAppendingPathComponent:@"users2.txt"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docPath]) {
        //[fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        //[fileManager removeItemAtPath:docPath error:nil];
    }

    //防止icloud备份
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:docPath]);
    return docPath;
}

//历史订单存放路径
NSString *getOrderSearchNoteStorePath(void){
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [filePaths objectAtIndex: 0];
    docPath = [docPath stringByAppendingPathComponent:@"ordersearchnote.txt"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docPath]) {
        //[fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        //[fileManager removeItemAtPath:docPath error:nil];
    }
    //防止icloud备份
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:docPath]);
    return docPath;
}

//历史库存存放路径
NSString *getInventorySearchNoteStorePath(void){
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [filePaths objectAtIndex: 0];
    docPath = [docPath stringByAppendingPathComponent:@"inventoryrsearchnote.txt"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docPath]) {
        //[fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        //[fileManager removeItemAtPath:docPath error:nil];
    }
    //防止icloud备份
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:docPath]);
    return docPath;
}


NSString *getMD5String(NSString *str)
{
    if(str && [str length])
    {
        unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
        CC_MD5([[str dataUsingEncoding:NSUTF8StringEncoding] bytes], (CC_LONG)[str length], result);

        int j = 0;
        unsigned char resultHEX[CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH] = {0};
        char charHex[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        {
            resultHEX[j] = charHex[result[i] >> 4 & 0xf];
            resultHEX[j + 1] = charHex[result[i] & 0xf];
            j += 2;
        }

        //return [NSString stringWithCharacters:(const unichar *)resultHEX length:CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH];
        return [NSString stringWithCString:(const char *)resultHEX length:CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH];
    }

    return nil;
}

char charToBinary(char value)
{
    char temp;

    switch(value)
    {
        case '1':
            temp = 1;
            break;
        case '2':
            temp = 2;
            break;
        case '3':
            temp = 3;
            break;
        case '4':
            temp = 4;
            break;
        case '5':
            temp = 5;
            break;
        case '6':
            temp = 6;
            break;
        case '7':
            temp = 7;
            break;
        case '8':
            temp = 8;
            break;
        case '9':
            temp = 9;
            break;
        case '0':
            temp = 0;
            break;
        case 'A':
        case 'a':
            temp = 0xA;
            break;
        case 'B':
        case 'b':
            temp = 0xB;
            break;
        case 'C':
        case 'c':
            temp = 0xC;
            break;
        case 'D':
        case 'd':
            temp = 0xD;
            break;
        case 'E':
        case 'e':
            temp = 0xE;
            break;
        case 'F':
        case 'f':
            temp = 0xF;
            break;
    }

    return temp;
}

NSData *hexStringToByte(NSString *str)
{
    int nLen = 0;
    if(str && (nLen = [str length]))
    {
        char *srcString = malloc(nLen + 1);
        if(srcString)
        {
            memset(srcString, 0, nLen + 1);
            [str getCString:srcString maxLength:nLen];

            char *desString = malloc(nLen / 2 + 1);
            if(desString)
            {
                memset(desString, 0, nLen / 2 + 1);

                int j = 0;
                for(int i = 0; i < nLen; i +=2)
                {
                    desString[j] = (charToBinary(srcString[i]) << 4) | charToBinary(srcString[i + 1]);
                    j++;
                }

                NSData *resultData = [NSData dataWithBytes:desString length:nLen / 2];

                free(srcString);
                free(desString);

                return resultData;
            }
        }
    }

    return nil;
}

//图片存储
void writeImageWithRelativePath(NSString *imageRelativePath, NSString *storePath, UIImage *image,NSString *size){
    storePath = [storePath stringByAppendingString:@"/"];
    storePath = [storePath stringByAppendingString:[imageRelativePath lastPathComponent]];
    storePath = [storePath stringByAppendingString:size];
    [UIImagePNGRepresentation(image) writeToFile:storePath atomically:YES];
}

//获取网址+http
NSString *getWebUrl(NSString *website)
{
    if(![NSString isNilOrEmpty:website])
    {
        if([website hasPrefix:@"http"])
        {
            return website;
        }
        return [[NSString alloc] initWithFormat:@"http://%@",website];
    }
    return @"";
}
//获取html、content 内容、font 字体大小、字体颜色
NSString *getHTMLStringWithContent_phone(NSString *content,NSString *font,NSString *color)
{
    if(!content)content=@"";
    if(!font)font=@"15px/20px";
    if(!color)color=@"#000000";
    NSString *temp = nil;
    NSMutableString *mut=[[NSMutableString alloc] init];
    for(int i =0; i < [content length]; i++)
    {
        temp = [content substringWithRange:NSMakeRange(i, 1)];
        if([temp isEqualToString:@"\n"])
        {
            [mut appendString:@"<br>"];

        }else
        {
            [mut appendString:temp];
        }
    }

    return [NSString stringWithFormat:@"<!DOCTYPE HTML><html><head><meta charset=utf-8><meta name=viewport content=width=device-width, initial-scale=1><style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Helvetica;align:justify;color:%@}</style><div align='justify'>%@<div>",font,color,mut];
}

NSString *getHTMLStringWithContent_pad(NSString *content,NSString *font,NSString *color)
{
    if(!content)content=@"";
    if(!font)font=@"15px/20px";
    if(!color)color=@"#000000";
    NSString *temp = nil;
    NSMutableString *mut=[[NSMutableString alloc] init];
    for(int i =0; i < [content length]; i++)
    {
        temp = [content substringWithRange:NSMakeRange(i, 1)];
        if([temp isEqualToString:@"\n"])
        {
            [mut appendString:@"<br>"];

        }else
        {
            [mut appendString:temp];
        }
    }
    return [NSString stringWithFormat:@"<!DOCTYPE HTML><html><head><meta charset=utf-8><meta name=viewport content=width=device-width, initial-scale=1><style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Custom-Font-Name;align:justify;color:%@}</style><div align='justify'>%@<div>",font,color,mut];
}

NSLayoutConstraint *getUIViewLayoutConstraint(UIView *ui ,NSLayoutAttribute layoutAttribute){
    for (NSLayoutConstraint * constrait in [ui constraints]) {
        if(constrait.firstAttribute == NSLayoutAttributeHeight){
            return constrait;
        }
    }
    return nil;
}


NSInteger getTxtHeight(float txtWidth,NSString *text,NSDictionary *txtDict){
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(txtWidth, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:txtDict context:nil];
    //    CGSize textSize =[text sizeWithAttributes:txtDict];
    //    NSInteger rowNum = ceilf(textSize.width/txtWidth);
    //    float textTotalHeight = rowNum * ceilf(textSize.height);
    return ceilf(textRect.size.height);
}

NSString * objArrayToJSON(NSArray *array){
    NSString *jsonStr = @"[";
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\"",array[i]]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];

    return jsonStr;
}
NSString * DataTOjsonString(id object)
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
id toArrayOrNSDictionary(NSString *jsonString){
    NSData *jsonData= [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    } else {
        // 解析错误
        return nil;
    }
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
NSDictionary *dictionaryWithJsonString(NSString *jsonString) {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//压缩图片
UIImage *compressImage(UIImage *image, NSInteger maxFileSize){
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }

    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}
//md5
NSString * md5(NSString *inPutText)
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);

    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
//获取中文字体
UIFont *getFont(CGFloat font)
{
    return (kIOSVersions_v9? [UIFont fontWithName:@"PingFangSC-Regular" size:font]:[UIFont fontWithName:@"HelveticaNeue" size:font]);
}

//获取中文粗体
UIFont *getSemiboldFont(CGFloat font)
{

    return (kIOSVersions_v9? [UIFont fontWithName:@"PingFangSC-Semibold" size:font]:[UIFont fontWithName:@"HelveticaNeue-Bold" size:font]);
}

//获取英文字体
UIFont *get_en_Font(CGFloat font)
{
    return [UIFont fontWithName:@"HelveticaNeue" size:font];
}

void setBorder(UIView *view)
{
    view.layer.masksToBounds=YES;
    view.layer.borderColor=[[UIColor blackColor] CGColor];
    view.layer.borderWidth=1;
}
void setCornerRadiusBorder(UIView *view)
{
    view.layer.masksToBounds=YES;
    view.layer.borderColor=[[UIColor colorWithHex:kDefaultBorderColor] CGColor];
    view.layer.borderWidth=1;
    view.layer.cornerRadius=2.0f;
}
void setBorderCustom(UIView *view,CGFloat borderWidth,UIColor *borderColor)
{
    view.layer.masksToBounds = YES;

    if(borderWidth){
        view.layer.borderWidth = borderWidth;
    }else{
        view.layer.borderWidth = 1;
    }

    if(borderColor){
        view.layer.borderColor=[borderColor CGColor];
    }else{
        view.layer.borderColor=[[UIColor blackColor] CGColor];
    }
}
UIAlertController *alertTitleCancel_Simple(NSString *title,void (^block)())
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    return alertController;
}

