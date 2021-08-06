// Copyright © 2021 Peogoo. All rights reserved.

#import "DGHotRectingModel.h"

@implementation DGHotRectingModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"IID":@"id"};
}
- (YYTextLayout *)textLayout{
    CGSize size = CGSizeMake((kScreenWidth - 45)/2 - 16, CGFLOAT_MAX);
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:self.materialTitle];
    NSRange range = NSMakeRange(0, self.materialTitle.length);
    
    [attString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:UIColor.peogooDarkerGray range:range];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:size];
    container.maximumNumberOfRows = 2;
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = size;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attString];
//    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attString];
    return layout;
}
- (CGFloat)cellHeight{
    float imageH = (kScreenWidth - 45)/2 * 93/165;
    return imageH + 4 + self.textLayout.textBoundingSize.height + 6 + 20 + 8 + 20 + 12;
}
//素材详情
- (YYTextLayout *)titleLayout{
    CGSize size = CGSizeMake((kScreenWidth - 32), CGFLOAT_MAX);
    if (kStringIsEmpty(self.materialTitle)) {
        self.materialTitle = @"";
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:self.materialTitle];
    NSRange range = NSMakeRange(0, self.materialTitle.length);
    
    [attString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:UIColor.peogooDarkerGray range:range];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:size];
    container.maximumNumberOfRows = 2;
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = size;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attString];
//    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attString];
    return layout;
}
- (YYTextLayout *)contentLayout{
    CGSize size = CGSizeMake((kScreenWidth - 32), CGFLOAT_MAX);
    if (kStringIsEmpty(self.followContent)) {
        self.followContent = @"";
    }
    NSMutableAttributedString *tmpStr = [NSString dealHtmlStyleBy:self.followContent];
    NSMutableAttributedString *attString = tmpStr;
    NSRange range = NSMakeRange(0, tmpStr.length);
    
    [attString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:UIColor.peogooContentGray range:range];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:size];
    container.maximumNumberOfRows = 0;
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = size;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attString];
    return layout;
}
- (CGFloat)detailHeight{
    float imageH = (kScreenWidth - 32) * 193/343;
    return self.titleLayout.textBoundingSize.height + 6 + 20 + 12 + imageH + 16 + 20 + self.contentLayout.textBoundingSize.height;
}
@end
