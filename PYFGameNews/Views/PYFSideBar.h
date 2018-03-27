//
//  PYFSideBar.h
//  PYFGameNews
//
//  Created by 彭宇峰 on 2018/3/22.
//  Copyright © 2018年 彭宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PYFSideBarDelegate

@optional
-(void)didSelectedItemAtIndex:(NSUInteger)index;
@end

@protocol PYFSideBarDataSource
@optional
-(void)setUpPicProfile;
@end

@interface PYFSideBar : UIView

@property(nonatomic) id<PYFSideBarDelegate> delegate;
@property(nonatomic) id<PYFSideBarDataSource> dataSource;
@property(nonatomic) UIImageView *picProfile;
@property(nonatomic) NSArray *buttons;
+(instancetype)instance;
@end

