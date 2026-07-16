import Foundation

enum TransactionCode: Int, Codable, CaseIterable, Identifiable {
    var id: Int {
        return self.rawValue
    }
    
    case code220 = 220
    case code221 = 221
    case code222 = 222
    case code223 = 223
    case code224 = 224
    case code225 = 225
    case code226 = 226
    case code227 = 227
    case code228 = 228
    case code231 = 231
    case code240 = 240
    case code241 = 241
    case code242 = 242
    case code244 = 244
    case code245 = 245
    case code246 = 246
    case code247 = 247
    case code248 = 248
    case code249 = 249
    case code253 = 253
    case code254 = 254
    case code257 = 257
    case code258 = 258
    case code260 = 260
    case code261 = 261
    case code262 = 262
    case code263 = 263
    case code264 = 264
    case code265 = 265
    case code266 = 266
    case code270 = 270
    case code271 = 271
    case code272 = 272
    case code273 = 273
    case code275 = 275
    case code276 = 276
    case code277 = 277
    case code278 = 278
    case code279 = 279
    case code280 = 280
    case code281 = 281
    case code282 = 282
    case code283 = 283
    case code284 = 284
    case code285 = 285
    case code286 = 286
    case code287 = 287
    case code288 = 288
    case code289 = 289
    case code290 = 290
    
    var description: String {
        switch self {
        case .code220:
            return "Turnover of goods and services - intermediary consumptions, payments for goods, raw material, materials, production services, fuel, lubricants, energy, purchase of farm products, membership fees, payment of services of public companies which are not defined for other goods and services"
        case .code221:
            return "Turnover of goods and services - final consumptions, payments for goods, raw material, materials, production services, fuel, lubricants, energy, purchase of farm products, membership fees, payment of services of public companies which are not defined for other goods and services (including the payment of all commissions and fees), except for investments - final consumptions"
        case .code222:
            return "Services of public companies, payments to public companies for defined liabilities"
        case .code223:
            return "Investments into facilities and equipment, payment based on construction of facilities and equipment procurement (procurement price, delivery, installation etc.)"
        case .code224:
            return "Investments - other, payments based on investments, except investments in facilities and equipment"
        case .code225:
            return "Rents for immovable and movable properties in state ownership, fees for other services of the public income nature"
        case .code226:
            return "Rents for immovable and movable properties for which the tax is due to be payed in accordance with the law"
        case .code227:
            return "Subsides, recourses and premiums from special accounts, collection, transfer and calculation based on subsides, recourses and premiums from consolidated account of the vault, i.e. funds and organizations of mandatory social security"
        case .code228:
            return "Subsides, recourses and premiums from other accounts, collection, transfer and calculation based on subsides, recourses and premiums from other accounts"
        case .code231:
            return "Customs and other import payment duties, collection, transfer from accounts and calculation of settlement of customs and other import duties (customs and other public revenues collected by the Customs Administration to its evidence account)"
        case .code240:
            return "Salaries and other allowances of employees, earnings, compensation of earnings, bonuses, (recourses, meal, field allowance) and earning of employees (from temporary or seasonal jobs and based on employment contracts outside the premises of employer), except payments in cash"
        case .code241:
            return "Non-taxable revenues of employees, social and other payments excluded from taxation"
        case .code242:
            return "Salaries at the charge of the employer"
        case .code244:
            return "Earnings via youth and student cooperatives, payments to cooperative members from the cooperative account"
        case .code245:
            return "Pensions, amount of pension paid to pensioners or transferred to their current accounts at banks or other financial organizations, except cash payments"
        case .code246:
            return "Deductions from pensions"
        case .code247:
            return "Other social allowances"
        case .code248:
            return "Income of private individuals from capital and other property rights"
        case .code249:
            return "Other income of private individuals"
        case .code253:
            return "Payment of public income except tax and contribution withholding"
        case .code254:
            return "Payment of tax and contribution withholding"
        case .code257:
            return "Return of overpaid or wrongly paid public revenues, current income, transfer of funds from payment account, current income in favor of taxpayers, in the name of overpaid or wrongly paid current income"
        case .code258:
            return "Rebooking of overpaid or wrongly paid public revenues, current income, transfer of funds from one payment account, current income in favor of other, in the name of overpaid or wrongly paid current income"
        case .code260:
            return "Insurance premium and indemnity of insurance premium, reinsurance, indemnity"
        case .code261:
            return "Public revenue allocation, allocation of taxes, contribution and other current income paid to beneficiaries"
        case .code262:
            return "Transfers within state agencies, within the account and sub-account of the vault, transfer of funds to budget beneficiaries, payments under the government social safety net"
        case .code263:
            return "Other transfers within the same legal entity and other transfers allocation from joint income"
        case .code264:
            return "Transfer of funds from budget for assuring returns from overpaid public revenues, funds from the budget at the account of current income from which it is necessary to return funds which will be returned to the payer"
        case .code265:
            return "Payment of daily turnover"
        case .code266:
            return "Cash payment, all cash payments from the account of a corporate client or an entrepreneur"
        case .code270:
            return "Short-term loans, transfer of funds based on approved short-term loans"
        case .code271:
            return "Long-term loans, transfer of funds based on approved long-term loans"
        case .code272:
            return "Active interest rate payment"
        case .code273:
            return "Payment of term deposits"
        case .code275:
            return "Other disbursements of purchases and sales of equity instruments, purchase of equity in the privatization procedure in terms of a law defining the privatization and purchase of shares from Share fund of the Republic of Serbia, cross-banking disbursement (securities, loans)"
        case .code276:
            return "Repayment of short-term loans"
        case .code277:
            return "Repayment of long-term loans"
        case .code278:
            return "Refund of term deposits"
        case .code279:
            return "Passive interest, payment of interest under the deposits and other cash deposits"
        case .code280:
            return "Discount securities"
        case .code281:
            return "Founder's borrowings for liquidity, founder's borrowings - private individual to a legal entity"
        case .code282:
            return "Return of a borrowing for liquidity to the founder of a legal entity - private individual"
        case .code283:
            return "Collection of retail cheques"
        case .code284:
            return "Payment Cards"
        case .code285:
            return "Exchange operations"
        case .code286:
            return "FX currency sales and purchase"
        case .code287:
            return "Donations and sponsorships from the funds of banks and other legal entities based on internal regulation"
        case .code288:
            return "Donations from international agreements"
        case .code289:
            return "Transactions upon the orders of private individuals"
        case .code290:
            return "Other transactions"
        }
    }
}
