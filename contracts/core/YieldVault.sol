// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "./GYieldRegistry.sol";

/**
 * @dev the yield vault is responsible for holding the transaction funds through out the yield generation lifecycle 
 * 
 */

contract YieldVault {
    
    address owner; 
    address vaultManager;
    address yieldManager; 
    
    uint256 version = 1; 
    
    GYieldRegistry registry; 
    
    uint256 vaultBalance; 
    
    mapping(uint256=>Deposit) depositsByDepositRef; 
    
    mapping(address=>uint256) erc20Totals; 
    
    mapping(address=>bool) knownERC20StatusByAddress; 
    
    constructor (address _owner, 
                 address _registry, 
                address _vaultManager, 
                address _yieldManager) {
        owner = _owner; 
        vaultManager = _vaultManager; 
        yieldManager = _yieldManager; 
        registry = GYieldRegistry(_registry);
    }
    
    struct Deposit {
        uint256 txnRef;
        uint256 amount; 
        address erc20; 
        uint256 depositRef;
        string status; 
        uint256 withdrawRef; 
        uint256 principal; 
        uint256 earnings; 
    }
    
    function getVaultBalance() external view returns (uint256 _vaultBalance){
        return vaultBalance; 
    }
    
    function deposit(address _owner, uint256 _txRef, uint256 _amount, uint256 _principal, uint256 _earnings, address _erc20) external payable returns (uint256 _depositRef){
       // require(msg.sender == vaultManager," d 00 - incorrect vault manager " ); // allow list required @todo
        require(owner == _owner, " d 00 - incorrect owner ");
        if(_erc20 == registry.getERC20Address("NATIVE")){
            // do nothing 
        }
        else {
            IERC20 erc20 = IERC20(_erc20);
            erc20.transferFrom(yieldManager, address(this), _amount);
        }
        
        if(knownERC20StatusByAddress[_erc20]) {
            erc20Totals[_erc20]+=_amount; 
        }
        else{
            erc20Totals[_erc20] = _amount; 
        }
        uint256 l_depositRef = generateRef(); 
        
        Deposit memory l_deposit = Deposit({
                                    txnRef : _txRef, 
                                    amount : _amount,
                                    erc20 : _erc20, 
                                    depositRef : l_depositRef,
                                    status : "held",
                                    withdrawRef : 0,
                                    principal : _principal, 
                                    earnings : _earnings
                                });
        depositsByDepositRef[l_depositRef] = l_deposit;
        return l_depositRef; 
        
    }
    
    function withdraw(uint256 _depositRef, address payable _destination) external returns(uint256 _withdrawalRef, uint256 _amount, uint256 principal, uint256 earnings, address _erc20, uint256 _txRef, address destination) {
        // require(msg.sender == vaultManager," w 00 - incorrect vault manager " ); // allow list required
        Deposit memory l_deposit = depositsByDepositRef[_depositRef];
        if(l_deposit.erc20 == registry.getERC20Address("NATIVE")){
            _destination.transfer(l_deposit.amount);
        }
        else 
        {
            IERC20 erc20 = IERC20(l_deposit.erc20);
            erc20.transfer(_destination, l_deposit.amount);
        }
        uint256 withdrawalRef = generateRef(); 
        l_deposit.status = "withdrawn";
        l_deposit.withdrawRef = withdrawalRef;
        return (withdrawalRef, l_deposit.amount, l_deposit.principal, l_deposit.earnings, l_deposit.erc20, l_deposit.txnRef, _destination );
    } 
    
    function getDepositStatus(uint256 _depositRef) external view returns (string memory _depositStatus) {
        return depositsByDepositRef[_depositRef].status; 
    }
 
    function generateRef() internal view returns(uint256 _depositRef){
        return block.timestamp; 
    }
    
}