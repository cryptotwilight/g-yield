// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "../../core/ISwap.sol";
import "./../AbstractProtocol.sol";
import "./CompoundTxVault.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/compound-finance/compound-protocol/blob/b9b14038612d846b83f8a009a82c38974ff2dcfe/contracts/CErc20.sol";



contract CompoundProtocol is AbstractProtocol {
    

    mapping(address=>address) cTokenContractByTokenContract; 
    mapping(string=>address) cTokenContractByTokenName; 
    
    mapping(uint256=>CompoundTXVault) vaultByTxn; 
    
    uint256 cancellationFee = 1000000000000000000;
    
    address comptrollerAddress;
    address compAddress; 
    

    constructor (address _administrator, address _comptrollerAddress, address _compAddress, address _yieldManagerAddress, address _gyieldRegistryAddress) AbstractProtocol("compound", 1, _administrator, _yieldManagerAddress, _gyieldRegistryAddress) {
        comptrollerAddress = _comptrollerAddress;
        compAddress = _compAddress;
    }
    
    function executeYieldGeneration(uint256 _txRef, uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate) override external payable returns ( bool _isRunning){
        
        sYieldGeneration syg = sYieldGeneration({
                                            txRef : _txRef,
                                            principal : _principal,
                                            erc20 : _erc20,
                                            yieldPercentage : _yieldPercentage,
                                            deliveryDate :  _deliveryDate,
                                            status : "pending"
                                            });
        
        yieldGenerationByTxn[_txRef] = syg; 
        
        address cErc20_ = cTokenContractByTokenContract[_erc20];
        
        // create a tx vault 
        CompoundTXVault vault_ = new CompountTXVault(_txRef, addres(this), _erc20, cErc20_,  _comptrollerAddress, compAddress);
        
        // approve vault 
        _erc20.approve(address(vault_), _principal);
        
        // deposit into vault 
        vault.deposit(_principal);
        
        // record the vault
        vaultByTxn[_txRef] = vault_; 

    }
    function cancelYieldGeneration(uint256 _txRef, uint256 _protocolCancellationFee) override external payable returns (bool _isCanceled, uint256 _totalAmount, uint256 _principal, address _erc20,  uint256 _percentageComplete, uint256 _earningsToDate){
        //@todo some cancellation fee math; 
        
        CompountTXVault vault = vaultByTxn[_txRef]; 
    
        uint256 compReward_;
        
        // set up the vault for withdrawal 
        (_principal , _earningsToDate, _totalAmount, compReward ) = vault.preWithdraw(); 

        sYieldGeneration syg = yieldGenerationByTxn[_txRef];
        
        // withdraw from the vaul 
        IERC20 erc20 = IERC20(syg.erc20); 
        IERC20 comp = IERC20(compAddress);
        erc20.transferFrom(address(vault), address(this), _totalAmount);
        comp.transferFrom(address(vault), address(this), compReward);
        
        ISwap swap = ISwap(registry.getSwapAddress());
        
        comp.approve(address(swap));
        
        uint256 swappedReward = swap.swap(compReward, compAddress, syg.erc20);
        
        _totalAmount += swappedReward;
        
        _earningsToDate += swappedReward; 
        
        _percentageComplete = 0; 
        yManager.deposit( _txRef,  _totalAmount, _principal, _erc20, _percentageComplete, _earningsToDate, "cancelled");
        
        return (true, _totalAmount, _principal, _erc20, ); 
    }
    
    function checkProgress(uint256 _txRef) override external returns (uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate, uint256 _percentageComplete, uint256 _earningsToDate){
        sYieldGeneration syg_ = yieldGenerationByTxn[_txRef];
        uint256 yield_ = vaultByTxn[_txRe].getYield(); 
        _percentageComplete = yield_ / principal * 100; 
        return (principal, erc20, syg_.yieldPercentage, syg_.deliveryDate, _percentageComplete, yield_);
    }
    
    function getEarningsView(uint256 _txRef) override external returns(uint256 _earningsToDate){
        return vaultByTxn[_txRe].getYield();
    }
    
    function pushYield() external returns (bool _yieldSent) {
        require(isAdmin(), " CompoundProtocol.py : admin only ");
        

    }
    
    
    function getProtocolCancellationFee(uint256 _txRef) override external returns (uint256 _protocolCancellationFee){
        return cancellationFee; 
    }
    
    function setCancellationFee(uint256 _fee) external returns (bool _set) {
        require(isAdmin(), " CompoundProtocol.scf : admin only ");
        cancellationFee = _fee; 
        return true; 
    }
    
    
    function loadAddresses() internal returns (bool _loaded) {
        // main net addresses
        cTokenContractByTokenName["cBAT"] = 0x6c8c6b02e7b2be14d4fa6022dfd6d75921d90e4e;
        cTokenContractByTokenName["cCOMP"] = 0x70e36f6bf80a52b3b46b3af8e106cc0ed743e8e4;
        cTokenContractByTokenName["cDAI"] = 0x5d3a536e4d6dbd6114cc1ead35777bab948e3643;
        //cTokenContractByTokenName["cETH"] = 0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5;
        cTokenContractByTokenName["cLINK"] = 0xface851a4921ce59e912d19329929ce6da6eb0c7;
        //cTokenContractByTokenName["cREP"] = 0x158079ee67fce2f58472a96584a73c7ab9ac95c1;
        cTokenContractByTokenName["cSAI"] = 0xf5dce57282a584d2746faf1593d3121fcac444dc;
        cTokenContractByTokenName["cTUSD"] = 0x12392f67bdf24fae0af363c24ac620a2f67dad86;
        cTokenContractByTokenName["cUNI"] = 0x35a18000230da775cac24873d00ff85bccded550;
        cTokenContractByTokenName["cUSDC"] = 0x39aa39c021dfbae8fac545936693ac917d5e7563;
        cTokenContractByTokenName["cUSDT"] = 0xf650c3d88d12db855b8bf7d11be6c55a4e07dcc9;
        cTokenContractByTokenName["cWBTC"] = 0xc11b1268c1a384e55c48c2391d8d480264a3a7f4;
        //cTokenContractByTokenName["cWBTC2"] = 0xccf4429db6322d5c611ee964527d42e5d685dd6a;
        cTokenContractByTokenName["cZRX"] = 0xb3319f5d18bc0d84dd1b4825dcde5d5f7266d407;
        
        cTokenContractByTokenContract[0xc00e94cb662c3520282e6f5717214004a7f26888] = 0x70e36f6bf80a52b3b46b3af8e106cc0ed743e8e4; // COMP
        cTokenContractByTokenContract[0x0d8775f648430679a709e98d2b0cb6250d2887ef] = 0x6c8c6b02e7b2be14d4fa6022dfd6d75921d90e4e; //BAT
        cTokenContractByTokenContract[0x6b175474e89094c44da98b954eedeac495271d0f] = 0x5d3a536e4d6dbd6114cc1ead35777bab948e3643; //DAI
        //cTokenContractByTokenContract[] = 0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5; //ETH
        cTokenContractByTokenContract[0x514910771af9ca656af840dff83e8264ecf986ca] = 0xface851a4921ce59e912d19329929ce6da6eb0c7; //LINK
        //cTokenContractByTokenContract[] = 0x158079ee67fce2f58472a96584a73c7ab9ac95c1; //REP
        cTokenContractByTokenContract[0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359] = 0xf5dce57282a584d2746faf1593d3121fcac444dc; //SAI
        cTokenContractByTokenContract[0x0000000000085d4780B73119b644AE5ecd22b376] = 0x12392f67bdf24fae0af363c24ac620a2f67dad86; //TUSD
        cTokenContractByTokenContract[0x1f9840a85d5af5bf1d1762f925bdaddc4201f984] = 0x35a18000230da775cac24873d00ff85bccded550; //UNI
        cTokenContractByTokenContract[0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48] = 0x39aa39c021dfbae8fac545936693ac917d5e7563; //USDC
        cTokenContractByTokenContract[0xdac17f958d2ee523a2206206994597c13d831ec7] = 0xf650c3d88d12db855b8bf7d11be6c55a4e07dcc9; //USDT
        cTokenContractByTokenContract[0x2260fac5e5542a773aa44fbcfedf7c193bc2c599] = 0xc11b1268c1a384e55c48c2391d8d480264a3a7f4; //WBTC
        // cTokenContractByTokenContract[] = 0xccf4429db6322d5c611ee964527d42e5d685dd6a; //WBTC2
        cTokenContractByTokenContract[0xe41d2489571d322189246dafa5ebde1f4699f498] = 0xb3319f5d18bc0d84dd1b4825dcde5d5f7266d407; //ZRX
    }
}