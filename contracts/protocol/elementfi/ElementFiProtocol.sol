// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "./AbstractProtocol.sol";

contract ElementFiProtocol is AbstractProtocol {
    
    IERC20 _token;
    string _name;
    string _symbol;
    address userProxyAddress;
    uint256 cancellationFee = 1000000000000000000;
    
    mapping(uint256=>ElementFiTxVault) vaultByTxn; 
    
    constructor (address _administrator, address _userProxy, address _yieldManagerAddress, address _gyieldRegistryAddress) AbstractProtocol("elementfi", 1, _administrator, _yieldManagerAddress, _gyieldRegistryAddress) {
        userProxyAddress = _userProxy; 
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
       
        ElementFiTxVault vault = new ElementFiTxVault (_txRef, address(this), _erc20, userProxyAddress );
       
       
    }
    function cancelYieldGeneration(uint256 _txRef, uint256 _protocolCancellationFee) override external payable returns (bool _isCanceled, uint256 _totalAmount, uint256 _principal, address _erc20,  uint256 _percentageComplete, uint256 _earningsToDate){
       
       vault.preWidthdraw();  
    }
    
    function checkProgress(uint256 _txRef) override external returns (uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate, uint256 _percentageComplete, uint256 _earningsToDate){
        
    }
    
    function getEarningsView(uint256 _txRef) override external returns(uint256 _earningsToDate){
        return vaultByTxn[_txRef].getYield();
    }
    
    function getProtocolCancellationFee(uint256 _txRef) override external returns (uint256 _protocolCancellationFee){
        return cancellationFee; 
    }

    function setCancellationFee(uint256 _fee) external returns (bool _set) {
        require(isAdmin(), " ElementFiProtocol.scf : admin only ");
        cancellationFee = _fee; 
        return true; 
    }

}