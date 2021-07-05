// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "../interface/IYieldManager.sol";
import "./YieldVault.sol";
import "./GYieldRegistry.sol";
import "./IProtocolRunner.sol";


contract YieldManager is IYieldManager { 
    
    uint256 version = 7;
    
    address administrator; 
    GYieldRegistry registry; 
    
    address vaultManager; // allow list @todo
    
    
    struct YieldRequest{ 
        string yieldProtocol; 
        uint256 principal; 
        address erc20; 
        uint256 yieldPercentage;
        uint256 term;
        uint256 maturityDate; 
        uint256 yieldRequestDate;
        uint256 txnRef; 
        string status; 
        address payable supplicant; 
    } 
    
    struct Withdrawal {
        uint256 withdrawalTxnReference; 
        uint256 totalAmount; 
        uint256 principal; 
        uint256 earnings; 
        uint256 withdrawalDate; 
        uint256 vaultWithdrawalRef;
        address erc20; 
        address destination; 
        uint256 requestTxnReference; 
    }
    
    struct Cancellation {
        uint256 cancellationTxnReference; 
        uint256 totalAmount; 
        uint256 principal; 
        uint256 earnings; 
        uint256 cancellationDate; 
        address erc20; 
        uint256 requestTxnReference; 
        uint256 fee; 
    }
    
    
    mapping(address=>uint256[]) txnRefsByAddress; 
    mapping(uint256=>YieldRequest) yieldRequestByTxn;
    mapping(address=>YieldVault) vaultByAddress; 
    mapping(address=>bool) hasVaultByAddress; 
    
    mapping(uint256=>Withdrawal) withdrawalByReference; 
    mapping(uint256=>Cancellation) cancellationByReference; 
    
    mapping(uint256=>bool) txnDepositedStatusByTxn; 
    mapping(uint256=>uint256) txnDepositRefByDepositTxn; 
    mapping(uint256=>uint256) ymDepositRefByTxn; 
    mapping(uint256=>uint256) percentageCompleteByTxn; 
    
    
    constructor (address _administrator, address _gyieldRegistryAddress) {
        administrator = _administrator;
        registry = GYieldRegistry(_gyieldRegistryAddress);
    }
    
    function getYieldRequestsForAddress() override external returns (     uint256 [] memory _txRefs, 
                                                                        string [] memory _yieldProtocols,  
                                                                        uint256 [] memory _principals, 
                                                                        uint256 [] memory _yieldPercentages, 
                                                                        uint256 [] memory _yieldRequestDates, 
                                                                        uint256 [] memory _yieldMaturityDates, 
                                                                        string [] memory _yieldRequestStatuses, 
                                                                        uint256 _totalLockedPrincipleUSD, 
                                                                        uint256 _totalLockedEarningsUSD){
        uint256[] memory txns = txnRefsByAddress[msg.sender];
        uint256 length = txns.length; 
        
        _txRefs = new uint256[](length);
        _yieldProtocols  = new string[](length);
        _principals  = new uint256[](length);
        _yieldPercentages = new uint256[](length);
        _yieldRequestDates = new uint256[](length);
        _yieldMaturityDates = new uint256[](length);
        _yieldRequestStatuses = new string[](length);
        for(uint256 x =0;x < txns.length; x++) {
            YieldRequest memory request = yieldRequestByTxn[txns[x]];
            _yieldProtocols[x] = request.yieldProtocol; 
            _principals[x] = request.principal; 
            _yieldPercentages[x] = request.yieldPercentage;
            _yieldRequestDates[x] = request.yieldRequestDate;
            _yieldMaturityDates[x] = request.maturityDate; 
            _yieldRequestStatuses[x] = request.status; 
            
            string memory erc20Name = registry.getERC20Name(request.erc20);

            IOracle oracle = IOracle(registry.getOracleAddress(erc20Name));

            uint256 oraclePrice = oracle.getPrice(erc20Name); // replace later @todo
            
            _totalLockedPrincipleUSD += (request.principal*oraclePrice); 
            
            IProtocolRunner pRunner = IProtocolRunner(registry.getProtocolAddress(request.yieldProtocol));
            // make sure to convert using oracle
            _totalLockedEarningsUSD += (pRunner.getEarningsView(request.txnRef) * oraclePrice);
        }
        
        return(_txRefs, _yieldProtocols, _principals, _yieldPercentages, _yieldRequestDates,_yieldMaturityDates, _yieldRequestStatuses, _totalLockedPrincipleUSD, _totalLockedEarningsUSD );
    }
    
    function reviewYield(string memory _yieldProtocol, uint256 _txRef ) override  external returns ( string memory _protocol, 
                                                                                                            uint256 _principal,
                                                                                                            address _erc20, 
                                                                                                            uint256 _yieldPercentage, 
                                                                                                            uint256 _term, 
                                                                                                            uint256 _deliveryDate,
                                                                                                            uint256 _percentageComplete, 
                                                                                                           uint256 _earnedToDate, 
                                                                                                           string memory yieldStatus){
        YieldRequest memory request =  yieldRequestByTxn[_txRef];
        IProtocolRunner runner = IProtocolRunner(registry.getProtocolAddress(_yieldProtocol));
        
        ( _principal,  _erc20, _yieldPercentage,  _deliveryDate, _percentageComplete,  _earnedToDate) = runner.checkProgress(_txRef);
    
        return (_yieldProtocol, request.principal, request.erc20, request.yieldPercentage, request.term, request.maturityDate, _percentageComplete, _earnedToDate, request.status);
    }

    
    function requestYield( string memory _yieldProtocol, 
                        uint256 _principal, 
                        address _erc20, 
                        uint256 _yieldPercentage, 
                        uint256 _term) override  external payable returns (uint256 _txnRef, uint256 _deliveryDate){
        require(registry.isEnabledProtocol(_yieldProtocol), " ry 00 - protocol disabled ");
        require(registry.isAcceptedERC20(_erc20), " ry 01 - ERC20 not accepted. ");
        address protocolRunnerAddress = registry.getProtocolAddress(_yieldProtocol); 
        
        uint256 txRef = generateTxnRef();
        uint256 yRequestDate = block.timestamp; 
        _deliveryDate = yRequestDate+_term; 
        IProtocolRunner pRunner = IProtocolRunner(protocolRunnerAddress);
        if(_erc20 != registry.getERC20Address("NATIVE")){
            IERC20 erc20 = IERC20(_erc20);
            erc20.transferFrom(msg.sender, address(this), _principal);
            erc20.approve(protocolRunnerAddress, _principal);
            pRunner.executeYieldGeneration(txRef, _principal,  _erc20, _yieldPercentage, _deliveryDate);

        }
        else{
            pRunner.executeYieldGeneration{ value : _principal }(txRef, _principal,  _erc20, _yieldPercentage, _deliveryDate);
        }
        
        YieldRequest memory yRequest = YieldRequest({
                                                yieldProtocol   : _yieldProtocol,
                                                principal       : _principal, 
                                                erc20           : _erc20,
                                                yieldPercentage : _yieldPercentage,
                                                term            : _term, 
                                                maturityDate    : _deliveryDate,
                                                yieldRequestDate : yRequestDate,
                                                txnRef          : txRef,
                                                status          : "pending",
                                                supplicant      :  payable(msg.sender)
                                        });
        yieldRequestByTxn[txRef] = yRequest;
        txnRefsByAddress[yRequest.supplicant].push(txRef);
       
        if(!hasVaultByAddress[yRequest.supplicant]){
            YieldVault vault = new YieldVault(yRequest.supplicant, vaultManager, address(this), address(registry));
            vaultByAddress[yRequest.supplicant] = vault; 
            hasVaultByAddress[yRequest.supplicant] = true;
        }
        
        return(txRef, _deliveryDate);
    }
    
    function cancelYieldRequest(string memory _yieldProtocol, uint256 _txRef, uint256 _cancellationFee ) override  external payable returns (uint256 _cancellationTxnRef, 
                                                                                                                                                uint256 _cancellationDate, 
                                                                                                                                                uint256 _totalAmountReturned, 
                                                                                                                                                uint256 _principalReturned, 
                                                                                                                                                uint256 _earningsReturned){
        // only the supplicant can call this operation
        
        // deal with the cancellation fee
        
        // process the cancelation 
        address protocolRunnerAddress = registry.getProtocolAddress(_yieldProtocol); 
        IProtocolRunner pRunner = IProtocolRunner(protocolRunnerAddress);
        bool isCanceled;
        address l_erc20;
        uint256 l_percentageComplete;
        
        //uint256 protocolCancellationFee = pRunner.getProtocolCancellationFee(_txRef); 
        
        (isCanceled, _totalAmountReturned,  _principalReturned, l_erc20, l_percentageComplete, _earningsReturned) = pRunner.cancelYieldGeneration(_txRef, 100);
        
        
        Cancellation memory cancellation = Cancellation ({
                     cancellationTxnReference : generateTxnRef(),
                     totalAmount : _totalAmountReturned,
                     principal : _principalReturned,
                     earnings :  _earningsReturned,
                     cancellationDate : block.timestamp,
                     erc20 : l_erc20,
                     requestTxnReference : _txRef,
                     fee : _cancellationFee
        });
        cancellationByReference[_txRef] = cancellation; 
        yieldRequestByTxn[_txRef].status = "cancelled";
        
        return(cancellation.cancellationTxnReference , cancellation.cancellationDate, cancellation.totalAmount, cancellation.principal, cancellation.earnings);
    }
    
    function withdrawYield(string memory _yieldProtocol, uint256 _txRef) override external payable returns ( uint256 _withdrawalTxnRef, 
                                                                                                                uint256 _principalReturned, 
                                                                                                                uint256 _earningsReturned,
                                                                                                                uint256 _totalReturned){
        require(txnDepositedStatusByTxn[_txRef], " wy 00 - transaction not deposited ");
        // check it's someone allowed to make the request for the transaction @todo
        
        
        YieldRequest memory request = yieldRequestByTxn[_txRef];
        address payable owner = request.supplicant; 
        YieldVault vault = vaultByAddress[owner];
        uint256 depositRef = txnDepositRefByDepositTxn[_txRef];

        Withdrawal memory withdrawal = Withdrawal ({
                                               withdrawalTxnReference : generateTxnRef(),    
                                               totalAmount : 0,
                                               principal :  0,
                                               earnings :  0,
                                               withdrawalDate : block.timestamp ,
                                               vaultWithdrawalRef : 0,
                                               erc20 : registry.getERC20Address("NATIVE") ,
                                               destination : registry.getERC20Address("NATIVE"),
                                               requestTxnReference : _txRef
                                            
                                        });
 
        (withdrawal.vaultWithdrawalRef, withdrawal.totalAmount, withdrawal.principal, withdrawal.earnings, withdrawal.erc20, withdrawal.requestTxnReference, withdrawal.destination ) = vault.withdraw(depositRef, owner);
        
        withdrawalByReference[_txRef] = withdrawal; 
        request.status = "withdrawn";
        return (withdrawal.withdrawalTxnReference, withdrawal.principal, withdrawal.earnings, withdrawal.totalAmount);
    }
    
    function depositYield(uint256 _txRef, uint256 _totalAmount, uint256 _principal, address _erc20,  uint256 _percentageComplete, uint256 _earningsToDate, string memory status) payable external returns (uint256 _ymDepositRef, uint256 _recievedDate){
        
        // only gyield internal addresses can call this operation 
        
        // all funds are deposited here either from maturity or cancellation 
        percentageCompleteByTxn[_txRef] = _percentageComplete; 
        YieldVault vault = vaultByAddress[yieldRequestByTxn[_txRef].supplicant];
        uint256 depositRef;
        if(_erc20 != registry.getERC20Address("NATIVE")){
            IERC20 erc20 = IERC20(_erc20);
            erc20.transferFrom(msg.sender, address(this), _totalAmount);
            erc20.approve(address(vault), _totalAmount);
            depositRef = vault.deposit(yieldRequestByTxn[_txRef].supplicant, _txRef, _totalAmount, _principal, _earningsToDate, _erc20);
        
        }
        else { 
            depositRef = vault.deposit{value : _totalAmount}(yieldRequestByTxn[_txRef].supplicant, _txRef, _totalAmount, _principal, _earningsToDate, _erc20);
        }
        
        _recievedDate = block.timestamp;
        txnDepositedStatusByTxn[_txRef] = true; 
        txnDepositRefByDepositTxn[_txRef] = depositRef; 
        
        _ymDepositRef = generateTxnRef(); 
        ymDepositRefByTxn[_txRef] = _ymDepositRef;
        
        YieldRequest memory request = yieldRequestByTxn[_txRef];
        request.status = status;
        
        return (_ymDepositRef, _recievedDate);
    }
    
    function setGYieldRegistry(address _gyieldRegistryAddress) external returns (bool _set){
        isAdminOnly();
        registry = GYieldRegistry(_gyieldRegistryAddress);
        return true; 
    }
    
    function setAdministrator(address _administrator) external returns (bool isSet){
        isAdminOnly();
        administrator = _administrator; 
        return true; 
    }
    
    function getVersion() external view returns(uint256 _version) {
        return version; 
    }
    
        // internal functions
    function isAdminOnly() internal view returns (bool _isAdmin){
        require(msg.sender == administrator, " iao 00 - administrator only ");
        return true; 
    }
    
    function generateTxnRef() internal view returns (uint256 _txnRef) {
        return block.timestamp;
    }
}