// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "./VegaTxVault.sol";
import "../AbstractProtocol.sol";
// Ropsten


contract VegaProtocol is AbstractProtocol {
    
    mapping(uint256=>VegaTxVault) vaultByTxn;
    uint256 cancellationFee = 1000000000000000000;
    address vegaWalletProxy;
    address self; 

    constructor (address _administrator, address _yieldManagerAddress, address _gyieldRegistryAddress, address _vegaWalletProxy) AbstractProtocol("vega", 1, _administrator, _yieldManagerAddress, _gyieldRegistryAddress) {
        vegaWalletProxy = _vegaWalletProxy;
        self = address(this);
        
    }
    
    function executeYieldGeneration(uint256 _txRef, uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate) override external payable returns ( bool _isRunning){
        sYieldGeneration memory syg = sYieldGeneration({
                                        txRef : _txRef,
                                        principal : _principal,
                                        erc20 : _erc20,
                                        yieldPercentage : _yieldPercentage,
                                        deliveryDate :  _deliveryDate,
                                        status : "pending"
                                        });
        
        yieldGenerationByTxn[_txRef] = syg; 
        VegaTxVault vault = new VegaTxVault( _txRef, self, _erc20, _deliveryDate, vegaWalletProxy);
        vaultByTxn[_txRef] = vault; 
		IERC20 erc20 = IERC20(_erc20); 
		erc20.transferFrom(yieldManagerAddress, self, _principal);
		erc20.approve(vault, _principal); 
        vault.deposit(_principal, _yieldPercentage);
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
    
    function pushReturns() external payable returns (bool _acknowledged) {
    
    
        
    }
    
}