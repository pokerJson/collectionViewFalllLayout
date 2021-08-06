// Copyright © 2021 Peogoo. All rights reserved.

#import "DGObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGHotRectingModel : DGObject

@property (nonatomic,copy) NSString *IID;//主键标识
@property (nonatomic,copy) NSString *materialId;//素材唯一标识
@property (nonatomic,copy) NSString *materialTitle;//素材标题
@property (nonatomic,copy) NSString *mediaId;//音频唯一标识
@property (nonatomic,copy) NSString *announcerNick;//用户昵称
@property (nonatomic,copy) NSString *userId;//用户id
@property (nonatomic,copy) NSString *announcerPhone;//用户shoujihao

@property (nonatomic,assign) NSInteger givelikeCount;
@property (nonatomic,assign) NSInteger status;//0：已上架，1：下架

@property (nonatomic,copy) NSString *uploadTime;//上传时间
@property (nonatomic,copy) NSString *putawayTime;//素材上架时间
@property (nonatomic,copy) NSString *flag;//点赞标识 0：未点过，1：点过

@property (nonatomic,copy) NSString *durationStr;//时长
@property (nonatomic,copy) NSString *photoUrl;//用户头像
@property (nonatomic,copy) NSString *coverImageUrl;//素材图片
@property (nonatomic,copy) NSString *followContent;//跟读内容
@property (nonatomic,copy) NSString *followCount;//跟读人数
@property (nonatomic,copy) NSString *mediaUrl;//音频路径


@property (nonatomic,strong) YYTextLayout *textLayout;
@property (nonatomic,assign) CGFloat cellHeight;


///详情总的高度 这里先用DGHotRectingModel做统一的model，后面看接口返回

//@property (nonatomic,copy) NSString *contents;//
//@property (nonatomic,copy) NSString *contentStr;//

@property (nonatomic,strong) YYTextLayout *titleLayout;//标题
@property (nonatomic,strong) YYTextLayout *contentLayout;//跟读内容
@property (nonatomic,assign) CGFloat detailHeight;
@end

NS_ASSUME_NONNULL_END
