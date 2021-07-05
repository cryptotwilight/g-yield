pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/yearn/yearn-protocol/blob/develop/contracts/registries/YRegistry.sol";
import "./AkropolisTxVault.sol";
import "../AbstractProtocol.sol";

contract AkropolisProtocol is AbstractProtocol {

    uint256 cancellationFee = 1000000000000000000;
	address self; 
	mapping(uint256=>AkropolisTxVault) vaultByTxn; 
	mapping(address=>address) yVaultAddressByErc20Address;
	YRegistry yRegistry;
	
    constructor (address _administrator, address _yieldManagerAddress, address _gyieldRegistryAddress, address yRegistryAddress) AbstractProtocol("akropolis", 1, _administrator, _yieldManagerAddress, _gyieldRegistryAddress) {
        self = address(this);
		yRegistryAddress = _yRegistryAddress; 
		yRegistry = YRegistry(yRegistryAddress);
    }
    
    function executeYieldGeneration(uint256 _txRef, uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate) override external payable returns ( bool _isRunning){
		sYieldGeneration syg = sYieldGeneration({
										txRef : _txRef,
										principal : _principal,
										erc20 : _erc20,
										yieldPercentage : _yieldPercentage,
										deliveryDate :  _deliveryDate,
										status : "pending"
										});
        
        yieldGenerationByTxn[_txRef] = syg; 
		AkropolisTxVault vault = new AkropolisTxVault(_txRef, _gyieldProtcolAddress, _erc20Address,  _deliveryDate,yVaultAddressByErc20Address[_erc20]); 
		vaultByTxn[_txRef] = vault; 
		IERC20 erc20 = IERC20(_erc20); 
		erc20.transferFrom(yieldManagerAddress, self, _principal); 
		erc20.approve(vault, _principal); 
		vault.deposit(_principal, _yield); 
    }
    function cancelYieldGeneration(uint256 _txRef, uint256 _protocolCancellationFee) override external payable returns (bool _isCanceled, uint256 _totalAmount, uint256 _principal, address _erc20,  uint256 _percentageComplete, uint256 _earningsToDate){
        
    }
    
    function checkProgress(uint256 _txRef) override external returns (uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate, uint256 _percentageComplete, uint256 _earningsToDate){
        
    }
    
    function getEarningsView(uint256 _txRef) override external returns(uint256 _earningsToDate){
        return vaultByTxn[_txRef].getYield(); 
    }
    
    function getProtocolCancellationFee(uint256 _txRef) override external returns (uint256 _protocolCancellationFee){
         return cancellationFee;
    }
}