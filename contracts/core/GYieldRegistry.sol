// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "../interface/IGYieldRegistry.sol";
import "./IOracle.sol";
import "./ISwap.sol";

contract GYieldRegistry is IGYieldRegistry {
    
    address administrator; 
    uint256 version = 3; 
    address NATIVE = 0x7F175528B60f40d6cA5e3555272E14f2F19E64a7; 
    
    struct Protocol { 
        string name; 
        string website; 
        uint256 cancellationFeePercentage;
        bool enabled; 
        address yieldProtocolAddress; 
    }
    
    address [] acceptedERC20s; 
    string [] erc20Names; 
    
    mapping(address=>string) erc20NameByAddress;
    mapping(string=>address) erc20AddressByName; 
    mapping(address=>bool) erc20AcceptedStatusByAddress; 
    
    Protocol [] yieldProtocols; 
    mapping(string=>Protocol) yieldProtocolsByName; 
    mapping(string=>bool) registeredProtocolKnownStatusByProtocolName;
    
    mapping(uint256=>Protocol) protocolByTransactionRef; 
    
    
    string [] oracles; 
    mapping(string=>address[]) oracleAddressByMarket; 

    string [] swaps; 
    
    mapping(string=>address) swapAddressByName; 
    
    
    constructor(address _administrator) {
        administrator = _administrator; 
        string memory native_ = "NATIVE";
          acceptedERC20s.push(NATIVE); 
        erc20Names.push(native_); 
        erc20AddressByName[native_] = NATIVE;  
        erc20NameByAddress[NATIVE] = native_;
        erc20AcceptedStatusByAddress[NATIVE] = true;
    }
    // front end public 
    function getRegisteredProtocols() override external view returns (  string [] memory _yieldProtocol, 
                                                                        string [] memory _yieldProtocolWebsite, 
                                                                        uint256 [] memory _cancellationFeePercentage, 
                                                                        bool [] memory _enabled){
       uint256 length = yieldProtocols.length;
       
       _yieldProtocol = new string[](length);
       _yieldProtocolWebsite = new string[](length);
       _cancellationFeePercentage = new uint256[](length);
       _enabled = new bool[](length);
       
       for(uint256 x = 0  ; x < length; x++) {
           Protocol memory protocol = yieldProtocols[x];
           _yieldProtocol[x] = protocol.name; 
           _yieldProtocolWebsite[x] = protocol.website; 
           _cancellationFeePercentage[x] = protocol.cancellationFeePercentage; 
           _enabled[x] = protocol.enabled;
       }
       return (_yieldProtocol, _yieldProtocolWebsite, _cancellationFeePercentage, _enabled);
    }

    function getAcceptedERC20() override  external view returns (address [] memory _erc20s, string []  memory _erc20Name){
        return (acceptedERC20s, erc20Names); 
    }
    
     // backend interface
    function isAcceptedERC20(address _erc20) external view returns (bool _isAccepted){
        return erc20AcceptedStatusByAddress[_erc20]; 
    }
    
    function isEnabledProtocol(string memory _yieldProtocol) external view returns (bool _isEnabled){
        require(registeredProtocolKnownStatusByProtocolName[_yieldProtocol], " gpa 00 - unknown protocol ");
        Protocol memory protocol = yieldProtocolsByName[_yieldProtocol];
        return protocol.enabled; 
    }
    
    function getProtocolAddress(string memory  _yieldProtocol) external view returns (address _yieldProtocolAddress) { 
        require(registeredProtocolKnownStatusByProtocolName[_yieldProtocol], " gpa 00 - unknown protocol ");
        Protocol memory protocol = yieldProtocolsByName[_yieldProtocol];
        require(protocol.enabled, " gpa 01 - protocol disabled ");
        return protocol.yieldProtocolAddress;
    }
    
    function getERC20Name(address _erc20) external view returns (string memory _erc20Name){
        return erc20NameByAddress[_erc20];
    }
    
    function getERC20Address(string memory _erc20Name) external view returns (address _er20Address) {
        return erc20AddressByName[_erc20Name];
    }
    
    function getOracleAddress(string memory _market) external view returns (address _oracleAddress){
        address [] memory oracleAddresses = oracleAddressByMarket[_market];
        for(uint256 x = 0;  x< oracleAddresses.length; x++ ){
            address o = oracleAddresses[x];
            IOracle oracle = IOracle(o);
            if(oracle.hasCredit()){
                return o;
            }
        }
        return oracleAddressByMarket[_market][0]; 
    }
    
    function getSwapAddress(string memory _swap) external view returns (address _swapAddress) {
        return swapAddressByName[_swap];
    }
    
    
    function getRegisteredOracles() external view returns(string [] memory _oracles){
        return oracles; 
    }
    
    function getRegisteredSwaps() external view returns (string [] memory _swaps) {
        return swaps; 
    }
    
    function getVersion() external view returns (uint256 _version) {
        return version; 
    }
    
    // admin functions
    function setEnabledProtocolAddress(string memory _yieldProtocol, bool _enabled) external view returns (bool _isEnabled)  {
        isAdminOnly(); 
        require(registeredProtocolKnownStatusByProtocolName[_yieldProtocol], " gpa 00 - unknown protocol ");
        Protocol memory protocol = yieldProtocolsByName[_yieldProtocol];
        protocol.enabled = _enabled; 
        return protocol.enabled;
    }
    
    function registerProtocol (string memory _yieldProtocol, address _yieldProtocolAddress, string memory _protocolWebsite, uint256 _cancellationFeePercentage, bool _enabled) external returns (uint256 _txnRef){
        isAdminOnly();
        Protocol memory protocol = Protocol ({ name : _yieldProtocol,
                                                website : _protocolWebsite,
                                                cancellationFeePercentage : _cancellationFeePercentage,
                                                enabled : _enabled,
                                                yieldProtocolAddress : _yieldProtocolAddress
                                            });
        yieldProtocols.push(protocol);
        
        yieldProtocolsByName[_yieldProtocol] = protocol;
        _txnRef = generateTxnRef(); 
    
        protocolByTransactionRef[_txnRef] = protocol;
               
        registeredProtocolKnownStatusByProtocolName[_yieldProtocol] = true;

        return _txnRef; 
    }
    
    function registerERC20(address _erc20, string memory _erc20Name) external returns (uint256 _txnRef){
        isAdminOnly(); 
        require(!erc20AcceptedStatusByAddress[_erc20], " r 00 - ERC20 already registered. ");
        acceptedERC20s.push(_erc20); 
        erc20Names.push(_erc20Name); 
        erc20AddressByName[_erc20Name] = _erc20;  
        erc20NameByAddress[_erc20] = _erc20Name;
        erc20AcceptedStatusByAddress[_erc20] = true; 
        return generateTxnRef(); 
    }
    
    function registerOracleAddress(address _oracleAddress) external returns (bool _isRegistered){
        isAdminOnly();
        
		IOracle oracle = IOracle(_oracleAddress);
		oracles.push(oracle.getName());
		
		string [] memory markets = oracle.getMarkets(); 
        for(uint256 x =0; x < markets.length; x++){
            string memory market = markets[x];
            oracleAddressByMarket[market].push( _oracleAddress);
        }
        return true; 
    }
    
    function registerSwapAddress(address _swapAddress ) external returns (bool _isRegistered) {
        isAdminOnly(); 
        ISwap swap = ISwap(_swapAddress);
        swapAddressByName[swap.getName()] = _swapAddress; 
        swaps.push(swap.getName());
        return _isRegistered; 
    }
    
    
    // internal functions
    function isAdminOnly() internal view returns (bool _isAdmin){
        require(msg.sender == administrator, " iao 00 - administrator only ");
        return true; 
    }
    
    function generateTxnRef() internal view returns (uint256 _txnRef) {
        return block.timestamp;
    }
}