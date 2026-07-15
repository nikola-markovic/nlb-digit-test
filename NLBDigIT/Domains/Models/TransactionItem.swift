import Foundation

struct TransactionItem: Equatable {
    var id: UUID
    
    var ordererName: String
    var ordererAddress: String
    var ordererPlace: String
    
    var creditorName: String
    var creditorAddress: String
    var creditorPlace: String
    
    var code: TransactionCode
    var amount: Double
    var creditAccount: String
    var model: String
    var referenceNumber: String
    var purpose: String
    var timestamp: Date
    
    var cardId: Int?
    
    static func initialTransaction() -> TransactionItem {
        TransactionItem(
            id: UUID(),
            ordererName: "",
            ordererAddress: "",
            ordererPlace: "",
            creditorName: "",
            creditorAddress: "",
            creditorPlace: "",
            code: .`289`,
            amount: 0,
            creditAccount: "",
            model: "",
            referenceNumber: "",
            purpose: "",
            timestamp: .now
        )
    }
}
