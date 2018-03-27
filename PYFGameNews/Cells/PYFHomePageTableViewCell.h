//
//  PYFHomePageTableViewCell.h
//  PYFGameNews
//
//  Created by 彭宇峰 on 2018/3/15.
//  Copyright © 2018年 彭宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYFHomePageTableViewCell : UITableViewCell
typedef NS_ENUM(NSUInteger, ComponentType){
    ComponentTypeAuthorName,
    ComponentTypePublish,
    ComponentTypeTitle,
    ComponentTypeSubtitle,
    ComponentTypeProfilePic,
    ComponentTypeArticleCover,
};
@end
