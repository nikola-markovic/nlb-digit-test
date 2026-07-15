import Foundation
import SwiftData

@Model
final class TransactionModel {
    var id: UUID
    
    var ordererName: String
    var ordererAddress: String
    var ordererPlace: String
    
    var creditorName: String
    var creditorAddress: String
    var creditorPlace: String
    
    var code: TransactionCode
    var amount: Double
    var model: String
    var referenceNumber: String
    var purpose: String
    var timestamp: Date
    
    var cardId: Int?
    
    var account: AccountModel?
    
    init(id: UUID, ordererName: String, ordererAddress: String, ordererPlace: String, creditorName: String, creditorAddress: String, creditorPlace: String, code: TransactionCode, amount: Double, model: String, referenceNumber: String, purpose: String, timestamp: Date, cardId: Int? = nil, account: AccountModel?) {
        self.id = id
        self.ordererName = ordererName
        self.ordererAddress = ordererAddress
        self.ordererPlace = ordererPlace
        self.creditorName = creditorName
        self.creditorAddress = creditorAddress
        self.creditorPlace = creditorPlace
        self.code = code
        self.amount = amount
        self.model = model
        self.referenceNumber = referenceNumber
        self.purpose = purpose
        self.timestamp = timestamp
        self.cardId = cardId
        self.account = account
    }
    
    static func initialModel() -> TransactionModel {
        TransactionModel(
            id: UUID(),
            ordererName: "",
            ordererAddress: "",
            ordererPlace: "",
            creditorName: "",
            creditorAddress: "",
            creditorPlace: "",
            code: .`289`,
            amount: 0,
            model: "",
            referenceNumber: "",
            purpose: "",
            timestamp: .now,
            account: nil,
        )
    }

}
