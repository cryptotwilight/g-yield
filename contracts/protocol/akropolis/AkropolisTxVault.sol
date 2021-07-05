pragma solidity >0.8.0 <0.9.0;

//import "https://github.com/yearn/yearn-protocol/blob/develop/contracts/vaults/yVault.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "../TxVault.sol";

interface IyVault { // version issue with yVault
    
    function deposit(uint256 _amount) external; 
}

contract AkropolisTxVault is TxVault { 
    
    IERC20 erc20; 
    address erc20Address; 
    uint256 deliveryDate; 
    IyVault yvault; 
    address self;
	address yVaultAddress; 
	
	
    constructor(uint256 _txRef, address _gyieldProtcolAddress, address _erc20Address, uint256 _deliveryDate, address _yVaultAddress) TxVault(_txRef, _gyieldProtcolAddress) {
        erc20 = IERC20(_erc20Address);
        erc20Address = _erc20Address;
        deliveryDate = _deliveryDate;
		yVaultAddress = _yVaultAddress;
        yvault = IyVault(_yVaultAddress); // real yvault address
		self = address(this);
    }
    
    function deposit(uint256 _principal, uint256 _yieldPercentage) payable external returns (bool _deposited){
        
		erc20.transferFrom(gyieldProtcolAddress, self, _principal); 
		erc20.approve(yVaultAddress, _principal);
		yvault.deposit(_principal);
        return true; 
    }
    
    
    function preWithdraw() external returns (uint256 _total, uint256 _principal, uint256 _yield) {
        
    }
    
    function getYield() external returns(uint256 _yieldToDate) {
        
    }
}