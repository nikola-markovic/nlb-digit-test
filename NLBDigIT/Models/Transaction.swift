import Foundation
import SwiftData

@Model
final class Transaction {
    var ordererName: String
    var ordererAddress: String
    var ordererPlace: String
    
    var creditorName: String
    var creditorAddress: String
    var creditorPlace: String
    
    var code: Transaction.Code
    var amount: Double
    var creditAccount: String
    var model: String
    var referenceNumber: String
    var purpose: String
    var timestamp: Date
    
    var cardId: Int?
    
    init(ordererName: String, ordererAddress: String, ordererPlace: String, creditorName: String, creditorAddress: String, creditorPlace: String, code: Transaction.Code, amount: Double, creditAccount: String, model: String, referenceNumber: String, purpose: String, timestamp: Date, cardId: Int? = nil) {
        self.ordererName = ordererName
        self.ordererAddress = ordererAddress
        self.ordererPlace = ordererPlace
        self.creditorName = creditorName
        self.creditorAddress = creditorAddress
        self.creditorPlace = creditorPlace
        self.code = code
        self.amount = amount
        self.creditAccount = creditAccount
        self.model = model
        self.referenceNumber = referenceNumber
        self.purpose = purpose
        self.timestamp = timestamp
        self.cardId = cardId
    }
    
    enum Code: String, Codable {
        case `220` = "Turnover of goods and services - intermediary consumptions, payments for goods, raw material, materials, production services, fuel, lubricants, energy, purchase of farm products, membership fees, payment of services of public companies which are not defined for other goods and services"
        case `221` = "Turnover of goods and services - final consumptions, payments for goods, raw material, materials, production services, fuel, lubricants, energy, purchase of farm products, membership fees, payment of services of public companies which are not defined for other goods and services (including the payment of all commissions and fees), except for investments - final consumptions"
        case `222` = "Services of public companies, payments to public companies for defined liabilities"
        case `223` = "Investments into facilities and equipment, payment based on construction of facilities and equipment procurement (procurement price, delivery, installation etc.)"
        case `224` = "Investments - other, payments based on investments, except investments in facilities and equipment"
        case `225` = "Rents for immovable and movable properties in state ownership, fees for other services of the public income nature"
        case `226` = "Rents for immovable and movable properties for which the tax is due to be payed in accordance with the law"
        case `227` = "Subsides, recourses and premiums from special accounts, collection, transfer and calculation based on subsides, recourses and premiums from consolidated account of the vault, i.e. funds and organizations of mandatory social security"
        case `228` = "Subsides, recourses and premiums from other accounts, collection, transfer and calculation based on subsides, recourses and premiums from other accounts"
        case `231` = "Customs and other import payment duties, collection, transfer from accounts and calculation of settlement of customs and other import duties (customs and other public revenues collected by the Customs Administration to its evidence account)"
        case `240` = "Salaries and other allowances of employees, earnings, compensation of earnings, bonuses, (recourses, meal, field allowance) and earning of employees (from temporary or seasonal jobs and based on employment contracts outside the premises of employer), except payments in cash"
        case `241` = "Non-taxable revenues of employees, social and other payments excluded from taxation"
        case `242` = "Salaries at the charge of the employer"
        case `244` = "Earnings via youth and student cooperatives, payments to cooperative members from the cooperative account"
        case `245` = "Pensions, amount of pension paid to pensioners or transferred to their current accounts at banks or other financial organizations, except cash payments"
        case `246` = "Deductions from pensions"
        case `247` = "Other social allowances"
        case `248` = "Income of private individuals from capital and other property rights"
        case `249` = "Other income of private individuals"
        case `253` = "Payment of public income except tax and contribution withholding"
        case `254` = "Payment of tax and contribution withholding"
        case `257` = "Return of overpaid or wrongly paid public revenues, current income, transfer of funds from payment account, current income in favor of taxpayers, in the name of overpaid or wrongly paid current income"
        case `258` = "Rebooking of overpaid or wrongly paid public revenues, current income, transfer of funds from one payment account, current income in favor of other, in the name of overpaid or wrongly paid current income"
        case `260` = "Insurance premium and indemnity of insurance premium, reinsurance, indemnity"
        case `261` = "Public revenue allocation, allocation of taxes, contribution and other current income paid to beneficiaries"
        case `262` = "Transfers within state agencies, within the account and sub-account of the vault, transfer of funds to budget beneficiaries, payments under the government social safety net"
        case `263` = "Other transfers within the same legal entity and other transfers allocation from joint income"
        case `264` = "Transfer of funds from budget for assuring returns from overpaid public revenues, funds from the budget at the account of current income from which it is necessary to return funds which will be returned to the payer"
        case `265` = "Payment of daily turnover"
        case `266` = "Cash payment, all cash payments from the account of a corporate client or an entrepreneur"
        case `270` = "Short-term loans, transfer of funds based on approved short-term loans"
        case `271` = "Long-term loans, transfer of funds based on approved long-term loans"
        case `272` = "Active interest rate payment"
        case `273` = "Payment of term deposits"
        case `275` = "Other disbursements of purchases and sales of equity instruments, purchase of equity in the privatization procedure in terms of a law defining the privatization and purchase of shares from Share fund of the Republic of Serbia, cross-banking disbursement (securities, loans)"
        case `276` = "Repayment of short-term loans"
        case `277` = "Repayment of long-term loans"
        case `278` = "Refund of term deposits"
        case `279` = "Passive interest, payment of interest under the deposits and other cash deposits"
        case `280` = "Discount securities"
        case `281` = "Founder's borrowings for liquidity, founder's borrowings - private individual to a legal entity"
        case `282` = "Return of a borrowing for liquidity to the founder of a legal entity - private individual"
        case `283` = "Collection of retail cheques"
        case `284` = "Payment Cards"
        case `285` = "Exchange operations"
        case `286` = "FX currency sales and purchase"
        case `287` = "Donations and sponsorships from the funds of banks and other legal entities based on internal regulation"
        case `288` = "Donations from international agreements"
        case `289` = "Transactions upon the orders of private individuals"
        case `290` = "Other transactions"
    }
}
