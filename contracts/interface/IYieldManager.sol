
pragma solidity >=0.8.0 <0.9.0;

/**
 * @dev The IYieldManager interface is the the main interface for G-Yield, It enables callers to access and managed fixed yields. 
 */ 
interface IYieldManager { 
    /**
     * @dev returns the yield protocols that are registered with this yield manager 
     * @return _protocol
     * @return _protocolWebsite
     * @return _enabled
     */
    function getRegisteredProtocols() external view returns (string [] memory _protocol, string [] memory _protocolWebsite, bool [] memory _enabled);

    /**
     * @dev returns the ERC20 currencies that are accepted by this yield manager 
     * @return _erc20s
     * @return _erc20Names
     */ 
    function getAcceptedERC20() external view returns (address [] memory _erc20s, string [] memory _erc20Names);
    
    /**
     * @dev returns the transactions for the given 'user'
     * @param  _yieldProtocol name of the yield protocol see 'getRegisteredProtocols'
     * @return _txRefs
     * @return _principle
     * @return _yieldRequestDates
     */ 
    function getUserTransactionsForProtocol(string memory _yieldProtocol) external view returns (uint256 [] memory _txRefs, uint256 [] memory _principle, uint256 [] memory _yieldRequestDates);

    /**
     * @dev returns a view of the yield currently in progress associated with the given transaction 
     * @param _yieldProtocol name of the yield protocol see 'getRegisteredProtocols'
     * @param _txRef transaction reference associated with yield request 
     * @return _protocol
     * @return _principal
     * @return _erc20
     * @return _yieldPercentage
     * @return _term
     * @return _deliveryDate
     * @return _earnedToDate
     */
    
    function reviewYield(string memory _yieldProtocol, uint256 _txRef ) external view returns ( string memory _protocol, uint256 _principal, address _erc20, uint256 _yieldPercentage, uint256 _term, uint256 _deliveryDate, uint256 _earnedToDate);

    /**
     * @dev actions a yield request for the given term 
     * @param _yieldProtocol name of the yield protocol see 'getRegisteredProtocols'
     * @param _principal on which yield is to be earned
     * @param _erc20 currency of principal 
     * @param _yieldPercentage requested by the caller
     * @param _term term for which principal is to be exposed
     * @return _txnRef transaction reference associated with yield request 
     * @return _deliveryDate
     */ 
    function requestYield(string memory _yieldProtocol, uint256 _principal, address _erc20, uint256 _yieldPercentage, uint256 _term) external payable returns (uint256 _txnRef, uint256 _deliveryDate);
    
    /**
     * @dev cancels a yield request for the given fee, princial and earnings to date are automatically returned
     * @param _yieldProtocol name of the yield protocol see 'getRegisteredProtocols'
     * @param _txRef transaction reference associated with yield request 
     * @param _cancellationFee required to cancel the yield request
     * @return _txnRef transaction reference associated with yield request 
     * @return _cancellationDate
     * @return _principalReturned
     * @return _earningsReturned
     */
    function cancelYieldRequest(string memory _yieldProtocol, uint256 _txRef, uint256 _cancellationFee )  external payable returns (uint256 _txnRef, uint256 _cancellationDate, uint256 _principalReturned, uint256 _earningsReturned);
    
    /**
     * @dev withdraws the matured yield from the yield manager
     * @param _yieldProtocol name of the yield protocol see 'getRegisteredProtocols'
     * @param _txRef transaction reference associated with yield request 
     * @return _principalReturned
     * @return _earningsReturned
     */ 
    function withdrawYield(string memory _yieldProtocol, uint256 _txRef) external payable returns ( uint256 _principalReturned, uint256 _earningsReturned);
}
