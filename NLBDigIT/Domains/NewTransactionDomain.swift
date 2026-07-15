import Foundation
import ComposableArchitecture

@Reducer
struct NewTransactionDomain {
    
    @ObservableState
    struct State: Equatable {
        var transaction = TransactionItem.initialTransaction()
    }
    
    enum Action: Sendable {
        case didUpdateOrdererName(String)
        case didUpdateOrdererAddress(String)
        case didUpdateOrdererPlace(String)
        
        case didUpdateCreditorName(String)
        case didUpdateCreditorAddress(String)
        case didUpdateCreditorPlace(String)
        
        case didUpdateCode(TransactionCode)
        case didUpdateAmount(Double)
//        case didUpdateCreditAccount(String)
        case didUpdateModel(String)
        case didUpdateReferenceNumber(String)
        case didUpdatePurpose(String)
        
        case didTapCreate
        case newTransactionResponse(TransactionItem)
    }
    
    @Dependency(\.databaseClient) var databaseClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .didUpdateOrdererName(let newValue):
                state.transaction.ordererName = newValue
                return .none
                
            case .didUpdateOrdererAddress(let newValue):
                state.transaction.ordererAddress = newValue
                return .none
                
            case .didUpdateOrdererPlace(let newValue):
                state.transaction.ordererPlace = newValue
                return .none
                
            case .didUpdateCreditorName(let newValue):
                state.transaction.creditorName = newValue
                return .none
                
            case .didUpdateCreditorAddress(let newValue):
                state.transaction.creditorAddress = newValue
                return .none
                
            case .didUpdateCreditorPlace(let newValue):
                state.transaction.creditorPlace = newValue
                return .none
                
            case .didUpdateCode(let newValue):
                state.transaction.code = newValue
                return .none
                
            case .didUpdateAmount(let newValue):
                state.transaction.amount = newValue
                return .none
                
//            case .didUpdateCreditAccount(let newValue):
//                state.transaction.creditAccount = newValue
//                return .none
                
            case .didUpdateModel(let newValue):
                state.transaction.model = newValue
                return .none
                
            case .didUpdateReferenceNumber(let newValue):
                state.transaction.referenceNumber = newValue
                return .none
                
            case .didUpdatePurpose(let newValue):
                state.transaction.purpose = newValue
                return .none
                
            case .didTapCreate:
                state.transaction.timestamp = .now
                state.transaction.id = UUID()
                let transactionItem = state.transaction
                return .run(operation: { send in
                    try await databaseClient.createTransaction(transactionItem)
                    await send(.newTransactionResponse(transactionItem))
                    print("saved \(transactionItem.timestamp)")
                }, catch: { error, send in
                    print(error)
                })
            case .newTransactionResponse(let item):
                return .none
            }
            
        }
        
    }
}
