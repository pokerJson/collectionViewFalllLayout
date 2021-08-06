// Copyright © 2021 Peogoo. All rights reserved.

extension DGRectingListModel {}

extension DGServer {
    //获取热门跟读
    public static func getHotRectingData(pageN: Int,materialId: String) -> Operation<DGRectingListModel> {
        let parameters: [String : Any] = [ "pageSize":10, "pageNo":pageN, "materialId":materialId]
        return DGServer.execute(.post, .getHotRectingData, parameters: parameters, isJson: true)
    }
    public static func getNewRectingData(pageN: Int,materialId: String) -> Operation<DGRectingListModel> {
        let parameters: [String : Any] = [ "pageSize":10, "pageNo":pageN, "materialId":materialId]
        return DGServer.execute(.post, .getNewRectingData, parameters: parameters, isJson: true)
    }
}
