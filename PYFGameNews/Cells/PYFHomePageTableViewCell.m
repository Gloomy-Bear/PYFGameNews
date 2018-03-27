//
//  PYFHomePageTableViewCell.m
//  PYFGameNews
//
//  Created by 彭宇峰 on 2018/3/15.
//  Copyright © 2018年 彭宇峰. All rights reserved.
//

#import "PYFHomePageTableViewCell.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation PYFHomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 初始化
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat leading = 12.f;
        CGFloat top = 18.f;
        // 文章封面
        UIImageView *articleCover = [[UIImageView alloc] initWithFrame:CGRectMake(leading, top, WIDTH - 2 * leading, 160)];
        articleCover.tag = ComponentTypeArticleCover;
        articleCover.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:articleCover];
        
        // 文章标题
        CGFloat internalBetweenArticleCoverAndArticleTitle = 2.f;
        UIFont *articleTitleFont = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        UILabel *articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(leading, 18 + articleCover.frame.size.height + internalBetweenArticleCoverAndArticleTitle, articleCover.frame.size.width, articleTitleFont.pointSize * 2)];
        articleTitle.tag = ComponentTypeTitle;
        [articleTitle setFont:articleTitleFont];
        articleTitle.text = @"主标题";
        articleTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:articleTitle];
        
        // 副标题
        UIFont *articleSubtitleFont = [UIFont systemFontOfSize:12];
        UILabel *articleSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(leading, articleTitle.frame.origin.y + articleTitle.frame.size.height + 3, articleCover.frame.size.width, articleSubtitleFont.pointSize)];
        articleSubtitle.tag = ComponentTypeSubtitle;
        articleSubtitle.font = articleSubtitleFont;
        articleSubtitle.text = @"副标题";
        articleSubtitle.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:articleSubtitle];
        
        // 作者头像
        UIImageView *profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(leading + 16, top + 16, 32, 32)];
        profilePic.tag = ComponentTypeProfilePic;
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
        profilePic.clipsToBounds = YES;
        profilePic.backgroundColor = [UIColor orangeColor];
        profilePic.layer.masksToBounds = YES;
        profilePic.layer.borderWidth = 1.f;
        profilePic.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self.contentView addSubview:profilePic];
        
        // 作者
        UILabel *authorName = [[UILabel alloc] initWithFrame:CGRectMake(profilePic.frame.origin.x + profilePic.frame.size.width + 8, profilePic.frame.origin.y + 6, 9 * 20, 9)];
        UIFont *authorNameFont = [UIFont fontWithName:@"STHeitiTC-Light" size:9];
        authorName.font = authorNameFont;
        authorName.text = @"作者";
        authorName.textColor = [UIColor whiteColor];
        authorName.tag = ComponentTypeAuthorName;
        [self.contentView addSubview:authorName];
        
        // 发布时间
        UILabel *publishDate = [[UILabel alloc] initWithFrame:CGRectMake(profilePic.frame.origin.x + profilePic.frame.size.width + 8, authorName.frame.origin.y + 15, 7 * 10, 7)];
        UIFont *publishDateFont = [UIFont fontWithName:@"STHeitiTC-Light" size:7];
        publishDate.font = publishDateFont;
        publishDate.text = @"2018-01-01";
        publishDate.textColor = [UIColor whiteColor];
        publishDate.tag = ComponentTypeAuthorName;
        [self.contentView addSubview:publishDate];
        // 评论数
        
        // Like数
        
    }
    return self;
}

@end
