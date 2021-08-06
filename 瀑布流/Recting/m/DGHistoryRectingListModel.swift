// Copyright © 2021 Peogoo. All rights reserved.

extension DGHistoryRectingListModel {}

extension DGServer {
    //获取历史素材
    public static func getHistoryRectingData(pageN: Int,materialId: String) -> Operation<DGHistoryRectingListModel> {
        let parameters: [String : Any] = [ "pageSize":10, "pageNo":pageN, "token":DGUserInfoManager.unarchive().token,"materialId":materialId]
        return DGServer.execute(.post, .getHistoryRectingData, parameters: parameters, isJson: true)
    }
}
