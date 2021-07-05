// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

/**
 * This contract acts as a proxy for the transaction 
 */ 

contract TXVault { 
    
    uint256 txRef; 
    address gyieldProtocolAddress; 
    
    constructor(uint256 _txRef, address _gyieldProtocolAddress){
        txRef = _txRef; 
        gyieldProtocolAddress = _gyieldProtocolAddress; 
    }
    

}