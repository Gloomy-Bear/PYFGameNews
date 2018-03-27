//
//  PYFSideBar.m
//  PYFGameNews
//
//  Created by 彭宇峰 on 2018/3/22.
//  Copyright © 2018年 彭宇峰. All rights reserved.
//

#import "PYFSideBar.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface PYFSideBar()
@end

@implementation PYFSideBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.hidden = YES;
        _picProfile = [[UIImageView alloc] init];
        _picProfile.bounds = CGRectMake(0, 0, 96, 96);
        _picProfile.center = CGPointMake(WIDTH * 3 / 10, 128);
        _picProfile.layer.cornerRadius = 48;
        _picProfile.clipsToBounds = YES;
        [self addSubview:_picProfile];
    }
    return self;
}

+ (instancetype)instance{
    static PYFSideBar *_instance = nil;
    if (!_instance) {
        @synchronized(self){
            if (!_instance) {
                _instance = [[PYFSideBar alloc] initWithFrame:CGRectMake(-(WIDTH * 3) /5, 0, WIDTH * 3 / 5, HEIGHT)];
            }
        }
    }
    return _instance;
}
@end
