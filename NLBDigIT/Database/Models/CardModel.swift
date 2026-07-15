import Foundation
import SwiftData

@Model
final class CardModel {
    var id: UUID
    
    var number: String
    var expirationDate: Date
    var ownerName: String
    var cvv: String
    
    init(id: UUID, number: String, expirationDate: Date, ownerName: String, cvv: String) {
        self.id = id
        self.number = number
        self.expirationDate = expirationDate
        self.ownerName = ownerName
        self.cvv = cvv
    }
}
