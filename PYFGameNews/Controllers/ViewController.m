//
//  ViewController.m
//  PYFGameNews
//
//  Created by 彭宇峰 on 2018/3/14.
//  Copyright © 2018年 彭宇峰. All rights reserved.
//

#import "ViewController.h"
#import "CAPSPageMenu.h"
#import "PYFHomePageTableViewCell.h"
#import "PYFSideBar.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.bounds.size.height
#define ARTICLEVIEW_HEIGHT 245
#define PAGEMENU_HEIGHT 40
#define NEWSCELL_HEIGHT 260

@interface ViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,PYFSideBarDelegate,PYFSideBarDataSource>
@property(nonatomic) UIScrollView *mainScrollView;
@property(nonatomic) UIScrollView *articleScrollView;
@property(nonatomic) UITableView *newsTable;
@property(nonatomic) PYFSideBar *sideBar;
@property(nonatomic) NSArray *topArticles;
@property(nonatomic) BOOL mainScrolling;
@property(nonatomic) BOOL subScrolling;

@end

static NSString *homePageReuseIdentifier = @"PYFHomePageTableViewCellIdentifier";

static CGFloat currentPanY = 0;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    [self setUpMainScrollView];
    [self setUpArticles];
    [self setUpNews];
    [self setUpPanGesture];
    [self setUpNavigationBar];
    [self setUpSideBar];
    _mainScrolling = NO;
    _subScrolling = NO;
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置侧边栏
- (void)setUpSideBar {
    _sideBar = PYFSideBar.instance;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:[PYFSideBar instance] aboveSubview:[self.view.subviews lastObject]];
    _sideBar.delegate = self;
    _sideBar.dataSource = self;
    UISwipeGestureRecognizer *swipeFromLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(useSideBarBySwipe:)];
    swipeFromLeft.direction = UISwipeGestureRecognizerDirectionRight;
    swipeFromLeft.delegate = self;
    [self.view addGestureRecognizer:swipeFromLeft];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseSideBar:)];
    [self.view addGestureRecognizer:tap];
}
//设置导航栏
- (void)setUpNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationItem.title = @"W-w-W";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self resizeImage:[UIImage imageNamed:@"Profile"] withSize:CGSizeMake(20, 20)] style:UIBarButtonItemStylePlain target:self action:@selector(openSideBar)];
}
// 调整图片大小

- (UIImage*)resizeImage:(UIImage*)image withSize:(CGSize)size{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}
//设置全屏的scrollView 内部嵌套了主体新闻的tableView（也是scrollView）和顶部新闻的scrollView
- (void)setUpMainScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _mainScrollView.contentSize = CGSizeMake(WIDTH, HEIGHT + ARTICLEVIEW_HEIGHT - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT);
    [self.view addSubview:_mainScrollView];
    _mainScrollView.delegate = self;
    _mainScrollView.scrollEnabled = YES;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

//设置主体的tableView（显示新闻
- (void)setUpNews {
    _newsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (ARTICLEVIEW_HEIGHT + PAGEMENU_HEIGHT), WIDTH, HEIGHT - (NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT)) style:UITableViewStylePlain];
    
    [_mainScrollView addSubview:_newsTable];
    
    _newsTable.delegate = self;
    _newsTable.dataSource = self;
    
    _newsTable.tableFooterView = [UIView new];
    _newsTable.tableHeaderView = [UIView new];
    
    _newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _newsTable.showsVerticalScrollIndicator = NO;
    
    _newsTable.scrollEnabled = NO;
    
    [_newsTable registerClass:[PYFHomePageTableViewCell class] forCellReuseIdentifier:homePageReuseIdentifier];
}

// 设置顶部新闻
- (void)setUpArticles {
    _articleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ARTICLEVIEW_HEIGHT)];
    _articleScrollView.pagingEnabled = YES;
    _articleScrollView.showsHorizontalScrollIndicator = NO;
    _articleScrollView.showsVerticalScrollIndicator = NO;
    _articleScrollView.contentSize = CGSizeMake(WIDTH * 3, ARTICLEVIEW_HEIGHT);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTopArticleImageView)];
    
    UIView *topArticle_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ARTICLEVIEW_HEIGHT)];
    topArticle_1.backgroundColor = [UIColor orangeColor];
    UIImageView *topArticleImageView_1 = [[UIImageView alloc] initWithFrame:topArticle_1.frame];
    topArticleImageView_1.userInteractionEnabled = YES;
    
    UIView *topArticle_2 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, ARTICLEVIEW_HEIGHT)];
    topArticle_2.backgroundColor = [UIColor blueColor];
    UIImageView *topArticleImageView_2 = [[UIImageView alloc] initWithFrame:topArticle_2.frame];
    topArticleImageView_2.userInteractionEnabled = YES;
    
    UIView *topArticle_3 = [[UIView alloc] initWithFrame:CGRectMake(2*WIDTH, 0, WIDTH, ARTICLEVIEW_HEIGHT)];
    topArticle_3.backgroundColor = [UIColor redColor];
    UIImageView *topArticleImageView_3 = [[UIImageView alloc] initWithFrame:topArticle_3.frame];
    topArticleImageView_3.userInteractionEnabled = YES;
    
    _topArticles = @[topArticle_1, topArticle_2, topArticle_3];
    
    [_articleScrollView addGestureRecognizer:tapGesture];
    [self.articleScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [_articleScrollView addSubview:topArticle_1];
    [_articleScrollView addSubview:topArticle_2];
    [_articleScrollView addSubview:topArticle_3];
    [_articleScrollView addSubview:topArticleImageView_1];
    [_articleScrollView addSubview:topArticleImageView_2];
    [_articleScrollView addSubview:topArticleImageView_3];
    [_mainScrollView addSubview:_articleScrollView];
}

//返回点击的图片返回相对文章

- (void)clickTopArticleImageView {
    UIView *view;
    NSLog(@"conten.x = %f",_articleScrollView.contentOffset.x);
    if(_articleScrollView.contentOffset.x < WIDTH) {
        view = _topArticles[0];
    } else if(_articleScrollView.contentOffset.x < 2 * WIDTH) {
        view = _topArticles[1];
    } else {
        view = _topArticles[2];
    }
}

// 设置拖拽手势
- (void)setUpPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerActionWithRecognizer:)];
    pan.delegate = self;
    [_mainScrollView addGestureRecognizer:pan];
}
//kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _articleScrollView && [keyPath isEqualToString:@"contentOffset"]) {
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//scrollView已开始滚动
//scrollView代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        UIView *barImageView = self.navigationController.navigationBar.subviews.firstObject;
        if (scrollView.contentOffset.y >= (ARTICLEVIEW_HEIGHT - (NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT))) {
            [scrollView setContentOffset:CGPointMake(0, (ARTICLEVIEW_HEIGHT - (NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT))) animated:NO];
            barImageView.backgroundColor = [UIColor whiteColor];
            _mainScrollView.scrollEnabled = NO;
            _newsTable.scrollEnabled = YES;
            _mainScrolling = NO;
            _subScrolling = YES;
        }else {
            barImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:scrollView.contentOffset.y / (ARTICLEVIEW_HEIGHT - (NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT))];
        }
    } else {
        if (scrollView.contentOffset.y <= 0) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            _mainScrollView.scrollEnabled = YES;
            _newsTable.scrollEnabled = NO;
            _mainScrolling = YES;
            _subScrolling = NO;
        }
    }
}

- (void)panGestureRecognizerActionWithRecognizer:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateChanged) {
        // 停止滑动后清空状态和临界点
        currentPanY = 0;
        _mainScrolling = NO;
        _subScrolling = NO;
    } else {
        // 当前手指所处位置的Y坐标
        CGFloat currentY = [recognizer translationInView:_mainScrollView].y;
        // 经过临界点时
        if (_mainScrolling || _subScrolling) {
            // 保存经过临界点瞬间手指所处位置的Y坐标
            if (currentPanY == 0) {
                currentPanY = currentY;
            }
            // 当前位置与经过临界点时位置的Y坐标偏移量
            CGFloat offsetY = currentPanY - currentY;
            // 正在滚动的是 mainScrollView
            if (_mainScrolling) {
                // 因为经过临界点时 mainScrollView的Y的偏移量已经是(ARTICLEVIEW_HEIGHT - (NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT))了
                // 在设置偏移量时应以此为基础增加
                CGFloat supposeY = (ARTICLEVIEW_HEIGHT - (NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT)) + offsetY;
                if (supposeY >= 0) {
                    [_mainScrollView setContentOffset:CGPointMake(0, supposeY)];
                } else {
                    // 偏移量 < 0 时使mainScrollView的偏移量固定在(0,0)
                    [_mainScrollView setContentOffset:CGPointZero];
                }
            } else {
                // 直接设置子视图的偏移量
                [_newsTable setContentOffset:CGPointMake(0, offsetY)];
            }
        }
    }
}

//点击关闭侧边栏，只要tap的位置不在侧边栏内

- (void)tapToCloseSideBar:(UITapGestureRecognizer*)tap{
    if (!_sideBar.isHidden && tap.view != _sideBar) {
        [self closeSideBar];
    }
}

// 根据_sideBar是否隐藏判断应该打开侧边栏还是关闭侧边栏
- (void)toggle {
    if (_sideBar.isHidden) {
        [self openSideBar];
    } else{
        [self closeSideBar];
    }
}

// 打开侧边栏
- (void)openSideBar {
    [_sideBar.layer removeAnimationForKey:@"moveBack"];
    _sideBar.hidden = NO;
    if (!_sideBar.picProfile.image) {
        [_sideBar.dataSource setUpPicProfile];
    }
    [self moveView:_sideBar From:_sideBar.layer.position.x To:_sideBar.layer.position.x + _sideBar.bounds.size.width Duration:0.3 forKeyPath:@"position.x" forAnimationName:@"move"];
}

// 关闭侧边栏
- (void)closeSideBar {
    [self moveView:_sideBar From:_sideBar.layer.position.x + _sideBar.bounds.size.width To:_sideBar.layer.position.x Duration:0.3 forKeyPath:@"position.x" forAnimationName:@"moveBack"];
    NSLog(@"%f",_sideBar.bounds.origin.x);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _sideBar.hidden = YES;
    });
}

// 参数
// 将view 在 time 秒内，从 a 移动到 b，动画的别名为 name
- (void)moveView:(UIView*)view From:(CGFloat)a To:(CGFloat)b Duration:(CFTimeInterval)time forKeyPath:(NSString *)path forAnimationName:(NSString*)name{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:path];
    anim.fromValue = [NSNumber numberWithFloat:a];
    anim.toValue = [NSNumber numberWithFloat:b];
    anim.duration = time;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:anim forKey:name];
}

- (void)useSideBarBySwipe:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self openSideBar];
    }
}

//tableView 代理 设置section分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//tableView 代理 设置cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//tableView 代理 设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NEWSCELL_HEIGHT;
}

//根据indexPath设置cell中新闻内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYFHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homePageReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[PYFHomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homePageReuseIdentifier];
    }
    return cell;
}


//UIGestureRecognizer 代理  设置手势识别的时候是否接受touch
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

//UIGestureRecognizer 代理 设置是否同时识别其他手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// 设置侧边栏头像
- (void)setUpPicProfile{
    // getPicProfileWithUserID()
    _sideBar.picProfile.image = [UIImage imageNamed:@"picProfile"];
}
@end
