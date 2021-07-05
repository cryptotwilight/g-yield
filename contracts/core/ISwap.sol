// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;


interface ISwap { 
    
    function getName() external view returns (string memory _name);
    
    function getVersion() external view returns (uint256 _version);
    
    function swap(uint256 _amountA, address _erc20a, address _erc20b) external payable returns (uint256 _amountB);
    
}