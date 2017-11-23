//
//  ViewController.m
//  Tuke
//
//  Created by yyj on 2017/11/21.
//  Copyright © 2017年 TukeCreator. All rights reserved.
//

#import "ViewController.h"

#import "SFPSDWriter.h"
#import "SFPSDWriter+MMLayershots.h"
#import "CALayer+MMLayershots.h"
#import "UIScreen+MMLayershots.h"

@interface ViewController ()

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property (nonatomic,strong) UIView *backView;

@end

// Private methods
#if (DEBUG)
@interface UIWindow()
+ (NSArray *)allWindowsIncludingInternalWindows:(BOOL)includeInternalWindows onlyVisibleWindows:(BOOL)visibleOnly;
@end
#endif

@implementation ViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{

    _backView = [UIView getCustomViewWithColor:_define_white_color];
    [self.view addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];

    UILabel *tempLabel = [UILabel getLabelWithAlignment:1 WithTitle:@"Editable" WithFont:18.0f WithTextColor:nil WithSpacing:0];
    [_backView addSubview:tempLabel];
    [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(50);
        make.height.mas_equalTo(100);
    }];
    tempLabel.backgroundColor = [UIColor blueColor];

    UIButton *tempBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:20.0f WithSpacing:0 WithNormalTitle:@"VIEW---->PSD(Clickable)" WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [_backView addSubview:tempBtn];
    [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(tempLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(100);
    }];
    tempBtn.backgroundColor = [UIColor redColor];
    [tempBtn addTarget:self action:@selector(layershotAction) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *tempImg = [UIImageView getImgWithImageStr:@"WechatIMG21.jpeg"];
    [_backView addSubview:tempImg];
    [tempImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(300);
        make.centerX.mas_equalTo(_backView);
        make.top.mas_equalTo(tempBtn.mas_bottom).with.offset(50);
    }];
    tempImg.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - --------------请求数据----------------------
//-(void)RequestData{}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)layershotAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [self getLayershotData];
        [self didCreateLayershotForData:data];
    });
}

#pragma mark - --------------自定义方法----------------------

- (void)didCreateLayershotForData:(NSData *)data {
    NSString *filePath = [[[self class] documentsDirectory] stringByAppendingPathComponent:@"layershots.psd"];
    [data writeToFile:filePath atomically:NO];
    NSLog(@"Saving psd to %@", filePath);
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    [self.documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

+ (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSAssert(documentsDirectory!=nil, @"Can't determine document directory");
    return documentsDirectory;
}

- (NSData *)getLayershotData{
    UIScreen *screen = [UIScreen mainScreen];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize size = [screen sizeForInterfaceOrientation:orientation];
    size.width = size.width * screen.scale;
    size.height = size.height * screen.scale;

    SFPSDWriter *psdWriter = [[SFPSDWriter alloc] initWithDocumentSize:size];

    [self.backView.layer beginHidingSublayers];
    [psdWriter addImagesForLayer:self.backView.layer renderedToRootLayer:self.backView.layer];
    [self.backView.layer endHidingSublayers];

    [psdWriter.layers setValue:@(YES) forKey:@"shouldUnpremultiplyLayerData"];
    NSData *psdData = [psdWriter createPSDData];
    return psdData;
}
#pragma mark - --------------other----------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
