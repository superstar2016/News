//
//  slideBanerVC.m
//  News
//
//  Created by zhaobo on 2018/12/4.
//  Copyright © 2018 zhaobo. All rights reserved.
//

#import "slideBanerVC.h"
#import "singleSlideView.h"
#import "ALView+safeArea.h"
@interface slideBanerVC ()
@property (nonatomic, strong) singleSlideView *image1;
@property (nonatomic, strong) singleSlideView *image2;
@property (nonatomic, strong) singleSlideView *image3;


@property (nonatomic, assign) NSUInteger interval;

@property (nonatomic, strong) UIImage *placeHolder;

@property (nonatomic, strong) NSArray * imageArray;

@property (nonatomic, strong) UIScrollView *wheelScrollView;
@property (nonatomic, strong) UIView *wheelScrollView_contentView;
// scrollView
@property (nonatomic, strong) UIPageControl *wheelPageControl;      // pageControl

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int currentImageIndex;

@property (nonatomic, assign) BOOL hasSetUpConstains;

@property (nonatomic, assign) int imageNum;
@end

@implementation slideBanerVC
#pragma mark - lazyLoads
- (UIPageControl *)wheelPageControl{
    if (!_wheelPageControl) {
        _wheelPageControl = [UIPageControl newAutoLayoutView];
        _wheelPageControl.backgroundColor = [UIColor clearColor];
        _wheelPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _wheelPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
    }
    return _wheelPageControl;
}
- (singleSlideView *)image1{
    if (!_image1) {
        _image1 = [singleSlideView newAutoLayoutView ];
        //_image1.backgroundColor = [UIColor yellowColor];
    }
    return  _image1;
}
- (singleSlideView *)image2{
    if (!_image2) {
        _image2 = [singleSlideView newAutoLayoutView ];
        //_image2.backgroundColor = [UIColor blackColor];
    }
    return  _image2;
}
- (singleSlideView *)image3{
    if (!_image3) {
        _image3 = [singleSlideView newAutoLayoutView ];
        //_image3.backgroundColor = [UIColor orangeColor];
    }
    return  _image3;
}
- (UIScrollView *)wheelScrollView{
    if (!_wheelScrollView) {
        _wheelScrollView = [UIScrollView newAutoLayoutView];
        _wheelScrollView.pagingEnabled = YES;
        _wheelScrollView.backgroundColor = [UIColor redColor];
        _wheelScrollView.bounces = NO;
        _wheelScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _wheelScrollView;
}
- (UIView *)wheelScrollView_contentView{
    if (!_wheelScrollView_contentView) {
        _wheelScrollView_contentView = [UIView newAutoLayoutView];
        _wheelScrollView_contentView.backgroundColor = [UIColor blueColor];
    }
    return _wheelScrollView_contentView;
}
#pragma mark - viewLoads
- (void)loadView{
    self.view = [UIView new];
    [self addChildViews];
    [self.view setNeedsUpdateConstraints];
}
- (void)addChildViews{
    [self.view addSubview:self.wheelScrollView];
    [self.wheelScrollView addSubview:self.wheelScrollView_contentView];
    
    [self.wheelScrollView_contentView addSubview:self.image1];
    [self.wheelScrollView_contentView addSubview:self.image2];
    [self.wheelScrollView_contentView addSubview:self.image3];
    
    [self.wheelScrollView addSubview:self.wheelPageControl];
}
- (void)updateViewConstraints{
    if (!self.hasSetUpConstains) {
        [self.wheelScrollView autoPinEdgesToSuperviewSafeAreaWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//       [self.wheelScrollView autoSetDimension:ALDimensionHeight toSize:200];
        [self.wheelScrollView_contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [@[self.image1,self.image2,self.image3] autoMatchViewsDimension:ALDimensionWidth];
        [@[self.image1,self.image2,self.image3] autoMatchViewsDimension:ALDimensionHeight];
        
        [self.image1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
        [self.image1 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.wheelScrollView];
        
        [self.image1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeRight];
        
        [self.image2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.image1];
        [self.image2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.image1];
        
        [self.image3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.image2];
        [self.image3 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.image1];
        [self.image3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.wheelPageControl autoPinEdgeToSuperviewSafeArea:ALEdgeRight withInset:5.0f];
        [self.wheelPageControl autoPinEdgeToSuperviewSafeArea:ALEdgeBottom withInset:-10.0f];
        
        self.hasSetUpConstains = YES;
    }
    [super updateViewConstraints];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.slideArry = @[@"http://app.nangonggdw.com:8081/static/media/main/20181126/777.jpg",@"http://app.nangonggdw.com:8081/static/media/main/20181126/777.jpg",@"http://app.nangonggdw.com:8081/static/media/main/20181126/777.jpg"];
     //self.slideArry = @[@"http://app.nangonggdw.com:8081/static/media/main/20181126/777.jpg"];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.wheelScrollView.contentOffset = CGPointMake(self.wheelScrollView.bounds.size.width, 0);
}
- (void)setSlideArry:(NSArray *)slideArry{
    _slideArry = slideArry;
//    [self.image1 setImgUrl: self.slideArry[2] WithTitleName:@"hello2"];
//    [self.image2 setImgUrl: self.slideArry[0] WithTitleName:@"hello0"];
//    [self.image3 setImgUrl: self.slideArry[1] WithTitleName:@"hello1"];
    
    if (slideArry.count <= 1) {
        self.wheelPageControl.hidden = YES;
        self.wheelScrollView.scrollEnabled = NO;
    }
    self.wheelPageControl.numberOfPages = slideArry.count;
    self.wheelPageControl.currentPage = 0;
    self.imageNum = (int)slideArry.count;
    self.currentImageIndex = 0;
    [self updateScrollImage];
}

- (void)updateScrollImage
{
    int left;
    int right;
    
    // 计算页数
    int page = self.wheelScrollView.contentOffset.x / self.wheelScrollView.frame.size.width;
    if (page <= 0)
    {
        // 计算当前图片索引
        self.currentImageIndex = (self.currentImageIndex + self.imageNum - 1) % self.imageNum;   // %限定当前索引不越界；
    }
    else if(page == 2)
    {
        // 计算当前图片索引
        self.currentImageIndex = (self.currentImageIndex + 1) % self.imageNum;
    }
    
    // 当前图片左右索引
    left = (int)(self.currentImageIndex + self.imageNum - 1) % self.imageNum;
    right = (int)(self.currentImageIndex + 1) % self.imageNum;
    
    // 更换UIImage
    
    [self.image1 setImgUrl: self.slideArry[left] WithTitleName:@"hello2"];
    [self.image2 setImgUrl: self.slideArry[self.currentImageIndex] WithTitleName:@"hello0"];
    [self.image3 setImgUrl: self.slideArry[right] WithTitleName:@"hello1"];
    
    self.wheelPageControl.currentPage = self.currentImageIndex;
    [self.wheelScrollView setContentOffset:CGPointMake(self.wheelScrollView.frame.size.width, 0) animated:NO];
}

@end
