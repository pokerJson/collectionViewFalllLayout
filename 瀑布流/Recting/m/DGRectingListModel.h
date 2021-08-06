// Copyright © 2021 Peogoo. All rights reserved.

#import "DGObject.h"
#import "DGHotRectingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGRectingListModel : DGObject

@property  NSInteger currentPage;
@property  NSInteger pageSize;
@property  NSInteger totalCount;
@property  NSInteger totalPage;
@property  NSInteger start;
@property (nullable) NSArray<DGHotRectingModel*> *list;

@end

NS_ASSUME_NONNULL_END
