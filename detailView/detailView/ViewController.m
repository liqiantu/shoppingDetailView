//
//  ViewController.m
//  detailView
//
//  Created by liqiantu on 2018/9/18.
//  Copyright © 2018年 qiantu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *headLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.webView];
    
}

#pragma mark - privateMethod

// 进入详情
- (void)enterDetail
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _webView.frame = CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height);
        _tableView.frame = CGRectMake(0, -self.view.frame.size.height , self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}


// 返回第tableView
- (void)enterTableView
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height);
        _webView.frame = CGRectMake(0, _tableView.contentSize.height, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

// 头部提示文本动画
- (void)headLabAnimation:(CGFloat)offsetY
{
    _headLab.alpha = -offsetY/60;
    _headLab.center = CGPointMake(self.view.frame.size.width/2, -offsetY/2.f);
    // 图标翻转，表示已超过临界值，松手就会返回上页
    if(-offsetY > 40){
        _headLab.textColor = [UIColor redColor];
        _headLab.text = @"释放，返回详情";
    }else{
        _headLab.textColor = [UIColor blackColor];
        _headLab.text = @"上拉，返回详情";
    }
}

#pragma mark - delegate

// 观察webView contentOffset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if(object == _webView.scrollView && [keyPath isEqualToString:@"contentOffset"])
    {
        [self headLabAnimation:[change[@"new"] CGPointValue].y];
    }else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// tableView scrollView 代理
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if([scrollView isKindOfClass:[UITableView class]])
    {
        // 触发翻页的理想值:tableView整体的高度减去屏幕本身的高度
        CGFloat valueNum = _tableView.contentSize.height - self.view.frame.size.height;
        if ((offsetY - valueNum) > 40)
        {
            
            [self enterDetail];
        }
    }
    else // webView页面向上滚动
    {
        if(offsetY < 0 && -offsetY > 40)
        {
            [self enterTableView];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"index is %ld",(long)indexPath.row];
    return cell;
}

#pragma mark - get
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        footLabel.text = @"继续拖动，查看详情";
        footLabel.font = [UIFont systemFontOfSize:13];
        footLabel.textAlignment = NSTextAlignmentCenter;
        _tableView.tableFooterView = footLabel;
    }
    
    return _tableView;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _tableView.contentSize.height, self.view.frame.size.width, self.view.frame.size.height)];
        _webView.scrollView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
        [_webView addSubview:self.headLab];
        [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    
    return _webView;
}

- (UILabel *)headLab {
    if (_headLab == nil) {
        _headLab = [[UILabel alloc] init];
        _headLab.text = @"上拉，返回详情";
        _headLab.textAlignment = NSTextAlignmentCenter;
        _headLab.font = [UIFont systemFontOfSize:13];
        _headLab.frame = CGRectMake(0, 0, self.view.frame.size.width, 40.f);
        _headLab.alpha = 0.f;
        _headLab.textColor = [UIColor blackColor];
    }
    
    return _headLab;
}

@end
