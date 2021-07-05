// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "../TxVault.sol";
import "./IIdleTokenV3_1.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


contract IdleTxVault is TxVault { 
    
    address idleTokenAddress; 
    
    address erc20Address;
    
    IIdleTokenV3_1 idleToken; 
    IERC20 erc20; 
    address self; 
    uint256 principal;
    

    constructor(uint256 _txRef, address _gyieldProtocolAddress, address _idleTokenAddress, address _erc20Address) TxVault(_txRef, _gyieldProtocolAddress) {
        idleTokenAddress = _idleTokenAddress; 
        erc20Address = _erc20Address; 
        idleToken = IIdleTokenV3_1(idleTokenAddress);
        erc20 = IERC20(_erc20Address);
        self = address(this);

    }
    
    function deposit( uint256 _principal ) external payable returns (uint256 _holding){
        principal = _principal;
        erc20.transferFrom(gyieldProtocolAddress, self, _principal );
        erc20.approve(idleTokenAddress, _principal);
        _holding = idleToken.mintIdleToken(_principal, true, self);
        return _holding; 
    }

    function preWithdraw() external returns(uint256 _total, uint256 _yield, uint256 _principal) {
        this.isProtocolOnly(); 
        uint256 sbalance_ = idleToken.balanceOf(self);
        _total = idleToken.redeemIdleToken(sbalance_);
        _yield = _total - principal; 
        erc20.approve(gyieldProtocolAddress, _total);
        return (_total, _yield, principal);
    }
    
    
    function getYield() external returns(uint256 _yield){
        uint256 sbalance = idleToken.balanceOf(self);
        uint256 avgCost = sbalance * (idleToken.userAvgPrices(self))/(10**18);
        uint256 currentValue = sbalance * (idleToken.tokenPrice())/(10**18);
        uint256 earnings = currentValue - avgCost;
        return earnings; 
    }
    

}