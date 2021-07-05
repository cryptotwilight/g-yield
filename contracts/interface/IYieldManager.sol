
// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

/**
 * @dev The IYieldManager interface is the the main interface for G-Yield, It enables callers to access and managed fixed yields. 
 */ 
interface IYieldManager { 
    
    /**
     * @dev returns all the transactions across all protocols for a 'user' 
     * @return _txRefs
     * @return _yieldProtocols
     * @return _principals
     * @return _yieldPercentages
     * @return _yieldRequestDates
     * @return _yieldMaturityDates
     * @return _yieldRequestStatuses
     * @return _totalLockedPrincipleUSD
     * @return _totalLockedEarningsUSD
     */
    function getYieldRequestsForAddress() external returns (uint256 [] memory _txRefs, 
                                                            string [] memory _yieldProtocols,  
                                                            uint256 [] memory _principals, 
                                                            uint256 [] memory _yieldPercentages, 
                                                            uint256 [] memory _yieldRequestDates, 
                                                            uint256 [] memory _yieldMaturityDates, 
                                                            string [] memory _yieldRequestStatuses,
                                                            uint256 _totalLockedPrincipleUSD, 
                                                            uint256 _totalLockedEarningsUSD);
        
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
     * @return _percentageComplete
     * @return _earnedToDate
     * @return _yieldStatus
     */
    function reviewYield(string memory _yieldProtocol, uint256 _txRef ) external  returns ( string memory _protocol, 
                                                                                                uint256 _principal, 
                                                                                                address _erc20, 
                                                                                                uint256 _yieldPercentage, 
                                                                                                uint256 _term, 
                                                                                                uint256 _deliveryDate, 
                                                                                                uint256 _percentageComplete,
                                                                                                uint256 _earnedToDate, 
                                                                                                string memory _yieldStatus);

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
    function requestYield(string memory _yieldProtocol, uint256 _principal, address _erc20, uint256 _yieldPercentage, uint256 _term) external payable returns (uint256 _txnRef, 
                                                                                                                                                                uint256 _deliveryDate);
    
    /**
     * @dev cancels a yield request for the given fee, princial and earnings to date are automatically returned
     * @param _yieldProtocol name of the yield protocol see 'getRegisteredProtocols'
     * @param _txRef transaction reference associated with yield request 
     * @param _cancellationFee required to cancel the yield request
     * @return _cancellationTxnRef transaction reference associated with yield request 
     * @return _cancellationDate
     * @return _totalAmountReturned
     * @return _principalReturned
     * @return _earningsReturned
     */
    function cancelYieldRequest(string memory _yieldProtocol, uint256 _txRef, uint256 _cancellationFee )  external payable returns (uint256 _cancellationTxnRef, 
                                                                                                                                    uint256 _cancellationDate, 
                                                                                                                                    uint256 _totalAmountReturned, 
                                                                                                                                    uint256 _principalReturned, 
                                                                                                                                    uint256 _earningsReturned);
    
    /**
     * @dev withdraws the matured yield from the yield manager
     * @param _yieldProtocol name of the yield protocol see 'getRegisteredProtocols'
     * @param _txRef transaction reference associated with yield request 
     * @return _txnRef transaction reference associated with yield request 
     * @return _principalReturned
     * @return _earningsReturned
     * @return _totalReturned
     */ 
    function withdrawYield(string memory _yieldProtocol, uint256 _txRef) external payable returns ( uint256 _txnRef, 
                                                                                                    uint256 _principalReturned, 
                                                                                                    uint256 _earningsReturned,
                                                                                                    uint256 _totalReturned);
}
