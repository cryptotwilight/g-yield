// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "../core/ISwap.sol";

contract UNISwap is ISwap { 
 
    string name; 
    uint256 version; 
 
    function getName() override external view returns (string memory _name){
        return name; 
    }
    
    function getVersion() override external view returns (uint256 _version){
        return version; 
    }
    
    function swap(uint256 _amountA, address _erc20a, address _erc20b) override external payable returns (uint256 _amountB){
        
    }
    
    
}