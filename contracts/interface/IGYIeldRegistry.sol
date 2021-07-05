// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

/**
  * @dev this is the G-Yield UI facing registry interface 
  *
  */
interface IGYieldRegistry {
    
    
    /**
     * @dev returns the yield protocols that are registered with this yield manager 
     * @return _yieldProtocol
     * @return _yieldProtocolWebsite
     * @return _cancellationFeePercentage
     * @return _enabled
     */
    function getRegisteredProtocols() external view returns (string [] memory _yieldProtocol, 
                                                                string [] memory _yieldProtocolWebsite, 
                                                                uint256 [] memory _cancellationFeePercentage, 
                                                                bool [] memory _enabled);

    /**
     * @dev returns the ERC20 currencies that are accepted by this yield manager 
     * @return _erc20s
     * @return _erc20Names
     */ 
    function getAcceptedERC20() external view returns (address [] memory _erc20s, 
                                                        string [] memory _erc20Names);
    
 
}