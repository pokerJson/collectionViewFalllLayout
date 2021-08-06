// Copyright © 2021 Peogoo. All rights reserved.

#import "DGObject.h"
#import "DGHostoryRectingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DGHistoryRectingListModel : DGObject

@property  NSInteger currentPage;
@property  NSInteger pageSize;
@property  NSInteger totalCount;
@property  NSInteger totalPage;
@property  NSInteger start;
@property (nullable) NSArray<DGHostoryRectingModel*> *list;

@end

NS_ASSUME_NONNULL_END
