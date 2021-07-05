// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;


import "../../core/IProtocolRunner.sol";
import "../../core/YieldManager.sol";
import "../../core/GYieldRegistry.sol";
import "../AbstractProtocol.sol";
import "./IdleTxVault.sol";



contract IdleProtocol is AbstractProtocol {
    
    
    mapping(address=>address) idleTokenAddresesByErc20Address; 
    mapping(uint256=>IdleTxVault) vaultByTxn; 
    
    uint256 cancellationFee = 1000000000000000000;
    mapping(address=>address) idleTokenAddressByErc20Address; 
    
    address self; 
    
    constructor (address _administrator, address _yieldManagerAddress, address _gyieldProtocolAddress) AbstractProtocol("idle", 1, _administrator, _yieldManagerAddress, _gyieldProtocolAddress) {
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
        yieldGenerationByTxn[_txRef]  = syg; 

        address idleToeknAddress = idleTokenAddressByErc20Address[_erc20];
        IdleTxVault vault_ = new IdleTxVault(_txRef, self, idleTokenAddressByErc20Address[_erc20],  _erc20);
        vault_.deposit(_principal);
        
        return true; 
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
    
        function loadMarkets() internal returns (bool _loaded){
        idleTokenAddressByErc20Address[0x028ff8ecfdd14f924f48d05f9afa76f7a1500082] = 0x295CA5bC5153698162dDbcE5dF50E436a58BA21e; //Kovan DAI
        idleTokenAddressByErc20Address[0x8365b8e4c07a5448ee2b2edbc6a9ea84639022ea] = 0x0de23D3bc385a74E2196cfE827C8a640B8774B9f; //Kovan USDC 
        idleTokenAddressByErc20Address[0x809eeafbab7cb533d5b87e959f894130346555bb] = 0xAB6Bdb5CCF38ECDa7A92d04E86f7c53Eb72833dF; //Kovan IDLE
    }
    function setCancellationFee(uint256 _fee) external returns (bool _set) {
        require(isAdmin(), " IdleProtocol.scf : admin only ");
        cancellationFee = _fee; 
        return true; 
    }
}
