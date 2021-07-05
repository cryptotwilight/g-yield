// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "../AbstractProtocol.sol";


contract StakeDAOProtocol is AbstractProtocol {
    
    uint256 cancellationFee = 1000000000000000000;
    mapping(uint256=>StakeDAOTxVault) vaultByTxn; 
    
    
    constructor (address _administrator, address _yieldManagerAddress, address _gyieldRegistryAddress) AbstractProtocol("stakedao", 1, _administrator, _yieldManagerAddress, _gyieldRegistryAddress) {
        
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