// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "../TxVault.sol";
import "./VegaWalletProxy.sol";
import "../IOpsProtocol.sol";

contract VegaTxVault is TxVault { 
    
    IERC20 erc20; 
    address erc20Address; 
    uint256 deliveryDate;
    address vegaWalletProxyAddress;
    uint256 principal; 
    address self; 
    uint256 yield; 
    IOpsProtocol gyVega; 
    VegaWalletProxy proxy;
    uint256 total; 

    
    constructor(uint256 _txRef, address _gyieldProtcolAddress, address _erc20Address, uint256 _deliveryDate, address _vegaWalletProxy) TxVault(_txRef, _gyieldProtcolAddress) {
        erc20 = IERC20(_erc20Address);
        erc20Address = _erc20Address;
        deliveryDate = _deliveryDate; 
        vegaWalletProxyAddress = _vegaWalletProxy; 
        proxy = VegaWalletProxy(vegaWalletProxyAddress);
        gyVega = IOpsProtocol(_gyieldProtcolAddress);
    }
    
    function deposit(uint256 _principal, uint256 _yieldPercentage) payable external returns ( uint256 _holding){
        erc20.transferFrom(gyieldProtocolAddress, self, _principal);
        erc20.approve(vegaWalletProxyAddress, _principal);
        proxy.deposit(self, _principal, deliveryDate, _yieldPercentage);
        total = principal; 
        return _principal; 
    }

    function cancelVault() external returns (uint256 _total, uint256 _princpal, uint256 _yield){
        require(msg.sender == gyieldProtocolAddress,  "cv - protocol only ");
        return proxy.cancel(self);
    }


    function preWithdraw() external returns (uint256 _total, uint256 _princpal, uint256 _yield) {
        erc20.approve(gyieldProtocolAddress, total);
        return (total, principal, yield);
    }
    
    function getYield() external view returns( uint256 _currentYield) {
        return yield; 
    }
    
    function closeVault(uint256 _total, uint256 _principal, uint256 _yield) external returns (bool _closed) {
        require(msg.sender == vegaWalletProxyAddress, " cv - proxy only ");
        total = _total;
        yield = _yield; 
        erc20.transferFrom(vegaWalletProxyAddress, self, total);
        gyVega.depositYield(txRef, _total, _principal, _yield); 
        return true; 
    }
    
}