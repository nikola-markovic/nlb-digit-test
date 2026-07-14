import Foundation
import SwiftData

@Model
final class Card {
    var id: Int
    var number: String
    var expirationDate: Date
    var ownerName: String
    var cvv: String
    
    init(id: Int, number: String, expirationDate: Date, ownerName: String, cvv: String) {
        self.id = id
        self.number = number
        self.expirationDate = expirationDate
        self.ownerName = ownerName
        self.cvv = cvv
    }
}
