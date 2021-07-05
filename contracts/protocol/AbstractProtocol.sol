// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "../core/IProtocolRunner.sol";


abstract contract  AbstractProtocol is IProtocolRunner { 
    
    string name; 
    uint256 version; 
    address administrator; 
    
    constructor(string memory _name, uint256 _version, address _administrator) {
        administrator = _administrator; 
        name = _name; 
        version = _version; 
    }
    
    function getName() override external view returns(string memory _name) {
        return name; 
    }
    
    function getVersion() override external view returns (uint256 _version) {
        return version; 
    }

    function isAdmin() external view returns(bool _isAdmin) {
        return msg.sender == administrator;
    }

}