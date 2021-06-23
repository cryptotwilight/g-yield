pragma solidity >=0.8.0 <0.9.0;

import "../interface/IYieldManager.sol";


contract YieldManager is IYieldManager { 
    
    address administrator; 
    
    mapping(address=>mapping(string=>mapping(uint256=>bool))) transactionKnownStatusByProtocolByCaller; 
    mapping(address=>mapping(string=>bool)) protocolHoldingStatusByCaller; 
    
    address [] acceptedERC20s; 
    string [] erc20Names; 
    
    mapping(string=>address) erc20AddressByName; 
    mapping(address=>bool) erc20AcceptedStatusByAddress; 
    
    struct Protocol { 
        string name; 
        string website; 
    }
    
    Protocol [] yieldProtocols; 
    mapping(string=>bool) protocolEnabledStatusByProtocol; 
    mapping(uint256=>Protocol) protocolByTransactionRef; 
    
    constructor (address _administrator) {
        administrator = _administrator;
    }
    
    function getRegisteredProtocols() override external view returns (string [] memory _protocol, string [] memory _website, bool [] memory _enabled){
       uint256 length = yieldProtocols.length;
       _protocol = new string[](length);
       _website = new string[](length);
       _enabled = new bool[](length);
       for(uint256 x ; x < length; x++) {
           Protocol memory protocol = yieldProtocols[x];
           _protocol[x] = protocol.name; 
           _website[x] = protocol.website; 
           _enabled[x] = protocolEnabledStatusByProtocol[protocol.name];
       }
       return (_protocol, _website, _enabled);
    }

    function getAcceptedERC20() override  external view returns (address [] memory _erc20s, string []  memory _erc20Name){
        return (acceptedERC20s, erc20Names); 
    }
    
    function getUserTransactionsForProtocol(string memory _yieldProtocol) override external view returns (uint256 [] memory _txRefs, uint256 [] memory _principle, uint256 [] memory _yieldRequestDates){
        require(protocolHoldingStatusByCaller[msg.sender][_yieldProtocol], " gtfp 00 - no user transactions for protocol ");
        
        
    }
    
    function reviewYield(string memory _yieldProtocol, uint256 _txRef ) override  external view returns ( string memory _protocol, uint256 _principal, address _erc20, uint256 _yieldPercentage, uint256 _term, uint256 _deliveryDate, uint256 _earnedToDate){
        require(hasProtocolAssociation(msg.sender, _yieldProtocol), " ry 00 - address has no association to yield protocol ");
        require(isKnownTransaction(msg.sender, _yieldProtocol, _txRef), " ry 01 - unknown caller transaction for protocol ");
    
        
    }

    
    function requestYield(string memory _yieldProtocol, uint256 _principal, address _erc20, uint256 _yieldPercentage, uint256 _term) override  external payable returns (uint256 _txnRef, uint256 _deliveryDate){
        require(protocolEnabledStatusByProtocol[_yieldProtocol], " ry 00 - protocol disabled ");
        require(erc20AcceptedStatusByAddress[_erc20], " ry 01 - ERC20 not accepted. ");
        
        
    }
    
    function cancelYieldRequest(string memory _yieldProtocol, uint256 _txRef, uint256 _cancellationFee ) override  external payable returns (uint256 _txnRef, uint256 _cancellationDate, uint256 _principalReturned, uint256 _earningsReturned){
        require(hasProtocolAssociation(msg.sender, _yieldProtocol), " cyr 00 - address has no association to yield protocol ");
        require(isKnownTransaction(msg.sender, _yieldProtocol, _txRef), " cyr 01 - unknown caller transaction for protocol ");
        
        
    }
    
    function withdrawYield(string memory _yieldProtocol, uint256 _txRef) override external payable returns ( uint256 _principalReturned, uint256 _earningsReturned){
        require(hasProtocolAssociation(msg.sender, _yieldProtocol), " wy 00 - address has no association to yield protocol ");
        require(isKnownTransaction(msg.sender, _yieldProtocol, _txRef), " wy 01 - unknown caller transaction for protocol ");
        
        
        
        
    }
    
    
    function registerProtocol (string memory _protocolName, string memory _protocolWebsite) external returns (uint256 _txnRef){
        
        Protocol memory protocol = Protocol ({ name : _protocolName,
                                        website : _protocolWebsite
                                            });
        yieldProtocols.push(protocol);
        
        _txnRef = generateTxnRef(); 
        
        protocolByTransactionRef[_txnRef] = protocol;
        
        return _txnRef; 
    }
    
    function registerERC20(address _erc20, string memory _erc20Name) external returns (uint256 _txnRef){
        require(!erc20AcceptedStatusByAddress[_erc20], " r 00 - ERC20 already registered. ");
        acceptedERC20s.push(_erc20); 
        erc20Names.push(_erc20Name); 
        erc20AddressByName[_erc20Name] = _erc20;  
        erc20AcceptedStatusByAddress[_erc20] = true; 
        return generateTxnRef(); 
    }
    
    function disableProtocol(string memory _protocol) external returns (bool _disabled){
        protocolEnabledStatusByProtocol[_protocol] = false;
        return protocolEnabledStatusByProtocol[_protocol]; 
    }
    
    function enableProtocol(string memory _protocol) external returns (bool _enabled){
        protocolEnabledStatusByProtocol[_protocol] = true;
        return protocolEnabledStatusByProtocol[_protocol];
    }
    
    function hasProtocolAssociation(address _caller, string memory _yieldProtocol) internal view returns (bool _hasAssociation) {
        return protocolHoldingStatusByCaller[_caller][_yieldProtocol];
    }
    
    function isKnownTransaction(address _caller, string memory _yieldProtocol, uint256 _txRef) internal view returns (bool _isKnown){
        return transactionKnownStatusByProtocolByCaller[_caller][_yieldProtocol][_txRef];
    }
    
    function generateTxnRef() internal view returns (uint256 _txnRef) {
        return block.timestamp;
    }
}