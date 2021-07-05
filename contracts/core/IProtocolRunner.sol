// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title IProtocolRunner
 * @dev this interface is the main interface into external protocols that are responsible for generating earnings. 
 */
interface IProtocolRunner {
    
    /**
     * @dev this returns the name of this protocol 
     * @return _name of the protocol 
     */ 
    function getName() external view returns (string memory _name); 
    
    /**
     * @dev returns the version of this protocol runner 
     * @return _version of this protocol runner
     */
    function getVersion() external view returns( uint256 _version);
    
    /**
     * 
     * @dev this function triggers the execution of a 'yield run' 
     * @param _txRef transaction reference for yield request
     * @param _principal principal to be invested up to the delivery date
     * @param _erc20 currency of principal 
     * @param _yieldPercentage requested by originating address (user wallet)
     * @param _deliveryDate date by which principal and yield must be returned
     * @return _isRunning true if execution is running
     */
    function executeYieldGeneration(uint256 _txRef, uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate) external payable returns ( bool _isRunning);
    
    /**
     * @dev this function will cancel a given 'yield run'
     * @param _txRef transaction reference for yield request
     * @param _protocolCancellationFee originating address (user wallet) has to pay exact protocol cancellation fee G-Yield feess are deducted in yield manager
     * @return _isCanceled
     * @return _totalAmount
     * @return _principal
     * @return _erc20
     * @return _percentageComplete
     * @return _earningsToDate
     */
    function cancelYieldGeneration(uint256 _txRef, uint256 _protocolCancellationFee) external payable returns (bool _isCanceled, uint256 _totalAmount, uint256 _principal, address _erc20,  uint256 _percentageComplete, uint256 _earningsToDate);
    
    /**
     * @dev this function returns the progress of the 'yield run'
     * @param _txRef transaction reference for yield request
     * @return _principal
     * @return _erc20
     * @return _yieldPercentage
     * @return _deliveryDate
     * @return _percentageComplete
     * @return _earningsToDate
     */
    function checkProgress(uint256 _txRef) external returns (uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate, uint256 _percentageComplete, uint256 _earningsToDate);
    
    /**
     * @dev this function returns the current earnings to date for the 'yield run'
     * @param _txRef transaction reference for yield request
     * @return _earningsToDate
     */
    function getEarningsView(uint256 _txRef) external returns(uint256 _earningsToDate);
     
     /**
     * 
     * @dev this function returns the current protocol cancellation fee for this 'yield run'
     * @param _txRef transaction reference for yield request
     * @return _protocolCancellationFee
     */
    function getProtocolCancellationFee(uint256 _txRef) external returns (uint256 _protocolCancellationFee);
    
}