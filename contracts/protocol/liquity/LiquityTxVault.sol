// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "../TxVault.sol";



contract LiquityTxVault is TxVault {
    
	constructor(uint256 _txRef, address _gyieldProtocolAddress) TxVault(_txRef, _gyieldProtocolAddress){

	}
	
	function deposit(uint256 _principal ) external payable returns (uint256 _holding) {
	}
	
	function preWithdraw() external returns (uint256 _principal, uint256 _yield, uint256 _total, uint256 _compReward){
		
	}
    
}