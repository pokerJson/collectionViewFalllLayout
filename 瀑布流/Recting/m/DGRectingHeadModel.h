// Copyright © 2021 Peogoo. All rights reserved.

#import "DGObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGRectingHeadModel : DGObject

@property (nonatomic,copy) NSString *recetingID;//素材唯一标识
@property (nonatomic,copy) NSString *mediaId;//素材唯一标识

@property (nonatomic,copy) NSString *coverImageUrl;//封面图片路径
@property (nonatomic,copy) NSString *materialTitle;//素材标题
@property (nonatomic,copy) NSString *followContent;//跟读内容
@property (nonatomic,copy) NSString *status;//是否上架或者下架

@property (nonatomic,copy) NSString *uploadTime;//
@property (nonatomic,copy) NSString *createTime;//
@property (nonatomic,copy) NSString *updateTime;//

@property (nonatomic,copy) NSString *followCount;//跟读人数

@property (nonatomic,strong) YYTextLayout *textLayout;
@property (nonatomic,assign) CGFloat headViewHeight;

@end

NS_ASSUME_NONNULL_END
