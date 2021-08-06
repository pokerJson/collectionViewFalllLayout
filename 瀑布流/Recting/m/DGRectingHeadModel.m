// Copyright © 2021 Peogoo. All rights reserved.

#import "DGRectingHeadModel.h"

@implementation DGRectingHeadModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"recetingID":@"id"};
}
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"recetingID":@"id"};
//}
- (YYTextLayout *)textLayout{
    CGSize size = CGSizeMake(kScreenWidth - 56, CGFLOAT_MAX);
    if (kStringIsEmpty(self.materialTitle)) {
        self.materialTitle = @"";
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:self.materialTitle];
    NSRange range = NSMakeRange(0, self.materialTitle.length);
    
    [attString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexStr:@"#353634"] range:range];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:size];
    container.maximumNumberOfRows = 2;
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = size;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attString];
    return layout;
}
- (CGFloat)headViewHeight{
    
    return  12+40+(kScreenWidth - 56)*179.5/319+8+self.textLayout.textBoundingSize.height+14+16;
}

@end
