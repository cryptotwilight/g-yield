pragma solidity >0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/88mphapp/88mph-contracts/blob/master/contracts/DInterest.sol";
import "../TxVault.sol";

contract Mph88TxVault is TxVault { 
    
    IERC20 erc20; 
    DInterest pool; 
    address poolAddress;
    address erc20Address; 
    uint256 depositId; 
    MPHToken mph; 
    uint256 deliveryDate; 
    
    constructor(uint256 _txRef, address _gyieldProtcolAddress, address _poolAddress, address _erc20Address, address _mphTokenAddress) TxVault(_txRef, _gyieldProtcolAddress) {
        erc20 = IERC20(_erc20Address);
        pool = DInterest(_poolAddress);
        erc20Address = _erc20Address;
        poolAddress = _poolAddress; 
        mph = MPHToken(_mphTokenAddress);
    }
    
    
    function deposit( uint256 _principal, uint256 _deliveryDate) external returns (uint256 _holding){

        require(erc20.approve(poolAddress, _principal), " Mph88TxVault.d 00 approval failure ");
        pool.deposit(_principal, _deliveryDate);
        deliveryDate = _deliveryDate; 
        depositId = pool.depositsLength(); // the ID of the deposit
        
        return _principal;
    }
    
    
    function preWithdraw() external returns (uint256 _total, uint256 _principal, uint256 _yield){
        MPHMinter mphMinter = pool.mphMinter();
        uint256 fundingID = 4; // need to pull this 
        
        mph.approve(address(mphMinter), uint256(-1)); // Infinite approval
        pool.withdraw(depositId, fundingID);
    }
    
    function earlyPreWithdraw() external returns (uint256 _total, uint256 _principal, uint256 _yield) {
        require(block.timestamp < deliveryDate, " Mph88TxVault.epw 00 not early call preWithdraw "); 
        MPHMinter mphMinter = pool.mphMinter();
        uint256 fundingID = 4; // need to pull this 
        
        mph.approve(address(mphMinter), uint256(-1)); // Infinite approval
        pool.earlyWithdraw(depositId, fundingID);
        
    }
    
    function getYield() external view returns (uint256 _uint256){
        
    }
    
}