// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.5.0 <0.6.0;

import "../TxVault.sol";
import "https://github.com/compound-finance/compound-protocol/blob/b9b14038612d846b83f8a009a82c38974ff2dcfe/contracts/Comptroller.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/compound-finance/compound-protocol/blob/b9b14038612d846b83f8a009a82c38974ff2dcfe/contracts/CErc20.sol";

contract CompoundTxVault is TxVault{
    
    uint256 principal;
    uint256 ctokenPrincpal; 
    address erc20; 
    address cErc20;
    IERC20 underlying;
    IERC20 comp; 
    CErc20 cToken;
    Comptroller comptroller; 
    address gyieldProtocolAddress; 
    

    constructor(uint256 _txRef, address _gyieldProtocolAddress, address _erc20Address, address _cErc20Address, address _comptrollerAddress, address _compAddress) TXVault(_txRef, _gyieldProtocolAddress){
        underlying = IERC20(_erc20Address);
        cToken = CErc20(_cErc20Address);
        comptroller = Comptroller(_comptrollerAddress);
        erc20 = _erc20Address;
        cErc20 = _cErc20Address;
        comp = IERC20(_compAddress);
    }

    function getYield() external returns (uint256 _yield) {
        return cToken.balanceOf(address(this))-cTokenPrincipal; 
    }
    
    function deposit( uint256 _principal ) external payable returns (uint256 _holding){
        CErc20 cToken = CErc20(_cErc20);
        underlying.approve(_cErc20, _principal );
        require(cToken.mint(principal) == 0,"TXVaultCompound.d 00 - depost mint failure " );
        ctokenPrincpal = principal / cToken.getExchangeRateCurrent(); 
        
        return ctokenPrincipal ;
    }
    
    function preWithdraw() external returns (uint256 _principal, uint256 _yield, uint256 _total, uint256 _compReward) {
        require(msg.sender == _gyieldProtocolAddress, " TXVaultCompound.w 00 unauthorized withdraw ");
        comptroller.claimComp();
        address self = address(this);
        cToken.redeem(cToken.balanceOf(self));
        _compReward = comp.balanceOf(self);
        _total = erc20.balanceOf(self);
        _yield = _total - _principal; 
        erc20.approve(_gyieldProtocolAddress, _total);
        comp.approve(_gyieldProtocolAddress, _compReward);
        return (_principal, _yield, _total, _compReward);
    }
}