pragma solidity >0.8.0 <0.9.0; 

import "https://github.com/element-fi/elf-contracts/blob/main/contracts/UserProxy.sol";
import "../TxVault.sol";

contract ElementFiTxVault is TxVault {
    
        IERC20 erc20; 
        UserProxy proxy; 
        address self; 
        address userProxyAddress; 
        address position;
        uint256 deliveryDate; 
        
        constructor(uint256 _txRef, address _gyieldProtocolAddress, address _erc20Adress, address _userProxyAddress ) TxVault(_txRef, _gyieldProtocolAddress){
            self = address(this);
            userProxyAddress = _userProxyAddress;
        }
        
        
        function deposit(uint256 _principal, uint256 _deliveryDate, PermitData[] calldata _permitCallData) external payable returns (uint256 _holding) {
            deliveryDate = _deliveryDate; 
            erc20.transferFrom(gyieldProtocolAddress, self,  _principal);
            erc20.approve(userProxyAddress, _principal);
            uint256 pt;
            uint256 yt; 
            (pt, yt) = proxy.mint(_principal, erc20, _deliveryDate, position, _permitCallData );
        }
        
        function preWithdraw() external returns (uint256 _principal, uint256 _yield, uint256 _total, uint256 _compReward){

            uint256 _amountPT;
            uint256 _amountYT;
            PermitData[] calldata _permitCallData;
            proxy.withdrawWeth(deliveryDate, position,_amountPT, _amountYT, _permitCallData );
        }
    
        function getYield() external returns(uint256 _currenctYield) {
            
        }
}