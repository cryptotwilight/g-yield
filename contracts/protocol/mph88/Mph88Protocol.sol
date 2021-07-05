import "@88mphapp/88mph-contracts/tree/master/contracts/DInterest.sol";
import "../core/IProtocolRunner.sol";
import "./AbstractProtocol.sol";



contract Mph88Protocol is AbstractProtocol {
    
    uint256 cancellationFee = 1000000000000000000;
    mapping(uint256=>Mph88TxVault) vaultByTxn; 
    mapping(uint256=>uint256) protocolDepositIdByTxn; 
    
    constructor (address _administrator, address _yieldManagerAddress, address _gyieldRegistryAddress) AbstractProtocol("88mph", 1, _administrator, _yieldManagerAddress, _gyieldRegistryAddress) {
        
    }
    
    function executeYieldGeneration(uint256 _txRef, uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate) external payable returns ( bool _isRunning){
         sYieldGeneration syg = sYieldGeneration({
                                            txRef : _txRef,
                                            principal : _principal,
                                            erc20 : _erc20,
                                            yieldPercentage : _yieldPercentage,
                                            deliveryDate :  _deliveryDate,
                                            status : "pending"
                                            });
        
        yieldGenerationByTxn[_txRef] = syg;        
        
   
    }
    
    
    function cancelYieldGeneration(uint256 _txRef) external returns (bool _isCanceled, uint256 _totalAmount, uint256 _principal, address _erc20,  uint256 _percentageComplete, uint256 _earningsToDate){
        

        
    }
    
    constructor (address _administrator) AbstractProtocol("stakedao", 1, _administrator) {
        
    }
    
    function checkProgress(uint256 _txRef)2 override external returns (uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate, uint256 _percentageComplete, uint256 _earningsToDate){
        
    }
    
    function getEarningsView(uint256 _txRef) override external returns(uint256 _earningsToDate){
        return vaultByTxn[_txRef].getYield(); 
    }
    
    function getProtocolCancellationFee(uint256 _txRef) override external returns (uint256 _protocolCancellationFee){
         return cancellationFee;
    }
    function setCancellationFee(uint256 _fee) external returns (bool _set) {
        require(isAdmin(), " Mph88Protocol.scf : admin only ");
        cancellationFee = _fee; 
        return true; 
    }
}