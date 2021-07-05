// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >0.8.0 <0.9.0;


contract VegaWalletProxy { 
    
        
    function deposit(address _vault, uint256 _principal, uint256 _maturityDate, uint256 _yield) external returns (bool acknowleged){
        // deposit principal into VegaWallet and lock against vault
    }
    
    // proxy should push back yield on maturity date
    
    // cancel to end early
    function cancel(address _vault) external returns (uint256 _principal, uint256 _yield, uint256 _total){
        // pull principal from vegaWallet and return to vault 
    }
    
    
}