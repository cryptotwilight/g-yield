pragma solidity >0.8.0 <0.9.0;

import "../TxVault.sol";

contract BitgoTxVault is TxVault {
        uint256 yieldToDate; // @todo source this 
        
		address self; 
		
        constructor(uint256 _txRef, address _gyieldProtcolAddress, 
        address _erc20Address, uint256 _deliveryDate) TxVault(_txRef, _gyieldProtcolAddress) {
			self = address(this); 
            
        }
    
        function deposit(uint256 _principal, uint256 _yieldPercentage) external payable returns (bool _deposited ){
            erc20.transferFrom(gyieldProtcolAddress, self, _principal); 

        }
    
        function getYield() external returns (uint256 _yieldToDate){
            return yieldToDate; 
        }
    
}