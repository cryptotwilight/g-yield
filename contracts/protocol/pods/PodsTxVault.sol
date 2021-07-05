pragma solidity >0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "../TxVault.sol";

contract PodsTxVault is TxVault { 
    
    IERC20 erc20; 
    address erc20Address; 
    uint256 deliveryDate; 
    
    constructor(uint256 _txRef, address _gyieldProtcolAddress, address _erc20Address, uint256 _deliveryDate) TxVault(_txRef, _gyieldProtcolAddress) {
        erc20 = IERC20(_erc20Address);
        erc20Address = _erc20Address;
    }
    
    function deposit() payable external returns (){
        
        
    }
    
    
    function preWithdraw() external returns () {
        
    }
    
    function getYield() external returns() {
        
    }
    
    
}