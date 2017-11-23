//
//  CommonHelper.h
//  CMNewspaper
//
//  Created by xuy on 13-12-30.
//  Copyright (c) 2013年 xuy. All rights reserved.
//
/***********************公共类***********************/
#import <UIKit/UIKit.h>

char charToBinary(char value);

NSString *GetApplicationPath(NSString *applicationPathName);

NSString *GetCachePath(NSString *applicationPathName, NSString *cachePathName, BOOL willCreate);

NSString *getMD5String(NSString *str);

NSData *hexStringToByte(NSString *str);

//点击网址（打开链接／复制网址）
void clickWebUrl_phone(NSString *webUrl);
void clickWebUrl_pad(NSString *webUrl ,UIView *clickView);

//打电话
void callSomeone(NSString *realPhoneNum, NSString *showPhoneNum);

//发邮件
void sendEmail(NSString *email);

//获取Window当前显示的ViewController
UIViewController *getCurrentViewController(void);

//获取当前屏幕中present出来的viewcontroller
UIViewController *getPresentedViewController(void);

//固定内容 字体下 获取高度
CGFloat getHeightWithWidth(CGFloat width, NSString *content, UIFont *font);

//固定内容 字体下 获取宽度
CGFloat getWidthWithHeight(CGFloat height,NSString *content, UIFont *font);

//获取文本高度
NSInteger getTxtHeight(float txtWidth,NSString *text,NSDictionary *txtDict);

//获取导航栏
//UIView *setNavView(NSString *title,UIView *supview);

//将时间戳转换成时间
NSDate *getDate(long time);

//时间戳转时间
NSString *getTimeStr(long time,NSString *formatter);

//获取网址+http
NSString *getWebUrl(NSString *website);

//获取html、content 内容、font 字体大小、字体颜色
NSString *getHTMLStringWithContent_phone(NSString *content,NSString *font,NSString *color);
NSString *getHTMLStringWithContent_pad(NSString *content,NSString *font,NSString *color);

NSString *trimWhitespaceOfStr(NSString *string);

//历史账号存放路径
NSString *getUsersStorePath(void);
//历史订单搜索数据
NSString *getOrderSearchNoteStorePath(void);
//历史库存存放路径
NSString *getInventorySearchNoteStorePath(void);
//弹出窗口添加白色，60%透明背影层
void popWindowAddBgView(UIView *superView);

//设置视图顶上偏移约束
void moveViewByOffsetAndConstraint(UIView *view,CGFloat offset, NSLayoutConstraint *layoutConstraint);

//添加子视图时加上动画
void addAnimateWhenAddSubview(UIView *view);
//使用动画从父视图中删除
void removeFromSuperviewUseUseAnimateAndDeallocViewController(UIView *view,UIViewController *viewController);
//根据格式获取显示时间
NSString *getShowDateByFormatAndTimeInterval(NSString *format,NSString *timeInterval);
NSComparisonResult compareNowDate(NSString *timeInterval);
//防止icloud备份
BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL);

void writeImageWithRelativePath(NSString *imageRelativePath, NSString *storePath,UIImage *image, NSString *size);

NSLayoutConstraint *getUIViewLayoutConstraint(UIView *ui ,NSLayoutAttribute layoutAttribute);
//压缩图片
UIImage *compressImage(UIImage *image, NSInteger maxFileSize);
//md5
NSString * md5(NSString *inPutText);

//json
NSString* DataTOjsonString(id object);
id toArrayOrNSDictionary(NSString *jsonString);
//数组装json
NSString * objArrayToJSON(NSArray *array);
// 把格式化的JSON格式的字符串转换成字典
NSDictionary *dictionaryWithJsonString(NSString *jsonString);

//获取中文字体
UIFont *getFont(CGFloat font);

//获取中文粗体
UIFont *getSemiboldFont(CGFloat font);

//获取英文字体
UIFont *get_en_Font(CGFloat font);

void setBorder(UIView *view);
void setCornerRadiusBorder(UIView *view);
void setBorderCustom(UIView *view,CGFloat borderWidth,UIColor *borderColor);

UIAlertController *alertTitleCancel_Simple(NSString *title,void (^block)(void));
