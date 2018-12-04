//
//  singleSlideView.m
//  News
//
//  Created by zhaobo on 2018/12/4.
//  Copyright © 2018 zhaobo. All rights reserved.
//

#import "singleSlideView.h"
#import "ALView+safeArea.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface singleSlideView()
    @property (nonatomic, strong) UIImageView *imgeView;
    @property (nonatomic, strong) UILabel *bottomLabel;
    @property (nonatomic, strong) UIView *bottomLabel_backGroundView;
    @property (nonatomic, assign) BOOL hasSetUpContains;
@end
@implementation singleSlideView
- (UIView *)bottomLabel_backGroundView{
    if (!_bottomLabel_backGroundView) {
        _bottomLabel_backGroundView = [UIView newAutoLayoutView];
        _bottomLabel_backGroundView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];
    }
    return _bottomLabel_backGroundView;
}
- (UIImageView *)imgeView{
    if (!_imgeView) {
        _imgeView = [UIImageView newAutoLayoutView];
        _imgeView.contentMode= UIViewContentModeScaleAspectFit;
    }
    return _imgeView;
}
- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [UILabel newAutoLayoutView];
        _bottomLabel.textColor = [UIColor whiteColor];
        //_bottomLabel.backgroundColor = [UIColor grayColor];
    }
    return _bottomLabel;
}
- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.imgeView];
        [self addSubview:self.bottomLabel_backGroundView];
        [self.bottomLabel_backGroundView addSubview:self.bottomLabel];
    }
    return self;
}
- (void)layoutSubviews{
    if (!self.hasSetUpContains) {
//        [self autoPinEdgeToSuperviewSafeArea:ALEdgeLeft];
//        [self autoPinEdgeToSuperviewSafeArea:ALEdgeRight];
//        [self autoSetDimension:ALDimensionHeight toSize:100];
//        [self autoPinEdgesToSuperviewEdges];
        [self.imgeView autoPinEdgesToSuperviewEdges];
        
        [self.bottomLabel_backGroundView autoPinEdgesToSuperviewSafeAreaWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [self.bottomLabel_backGroundView autoSetDimension:ALDimensionHeight toSize:55.0f];
        
        [self.bottomLabel autoPinEdgesToSuperviewSafeAreaWithInsets:UIEdgeInsetsMake(10, 20, 30, 20) excludingEdge:ALEdgeBottom];
      
        self.hasSetUpContains = YES;
    }
}

- (void)setImgUrl:(NSString *)imgUrl WithTitleName:(NSString *)titleName{
    //imgUrl = @"http://app.nangonggdw.com:8081/static/media/main/20181126/777.jpg";
    [self.imgeView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    self.bottomLabel.text = titleName;
}
@end
