// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;


/**
 * @title IOracle 
 * @dev this interface represents oracles that are used within the system 
 *
 */

interface IOracle {
    
    /**
     * @dev this returns the name of this oracle instance
     * @return _name of the oracle 
     */ 
    function getName() external view returns (string memory _name);
    
    /**
     * @dev returns the version of this oracle instance 
     * @return _version of the oracle
     */ 
    function getVersion() external view returns(uint256 _version);
    
    /**
     * @dev this returns the current price for the given market 
     * @param _market market for which price is required 
     * @return _price current for market 
     */
    function getPrice(string memory _market) external view returns (uint256 _price);
    
    /**
     * @dev this returns whether the give oracle has enough money to cover the call
     * @return _hasCredit true if the oracle has credit
     */ 
    function hasCredit() external view returns (bool _hasCredit);
	
	/**
	 *@dev this returns the markets supported by this oracle 
	 *@return _markets array of markets 
	 */
	function getMarkets() external view returns (string [] memory _markets);
    
}