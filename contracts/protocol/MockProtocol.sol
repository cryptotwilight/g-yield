pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "../core/IProtocolRunner.sol";
import "../core/YieldManager.sol";
import "../core/GYieldRegistry.sol";

contract MockProtocol is IProtocolRunner {
    
    address administrator; 
    YieldManager yManager;
    uint256 version = 3; 
    address yieldManagerAddress; 
    string name; 
    GYieldRegistry registry; 
    
    struct YieldProgress {
        uint256 principal;  
        address erc20; 
        uint256 yieldPercentage;
        uint256 deliveryDate; 
        uint256 percentageComplete;
        uint256 earningsToDate;
        string status; 
    }
    
    mapping(uint256=>uint256) earningsToDateByTxn; 
    mapping(uint256=>YieldProgress) yieldProgressByTxn; 
    
    
    constructor(address _administrator, address _yieldManagerAddress, address _gyieldRegistryAddress,  string memory _name) {
        administrator = _administrator; 
        name = _name; 
        yieldManagerAddress = _yieldManagerAddress;
        yManager = YieldManager(yieldManagerAddress);
        registry = GYieldRegistry(_gyieldRegistryAddress);
    }
    
    function getName() override external view returns (string memory _name){
        return name; 
    }
    
    function getVersion() override external view returns (uint256 _version){
        return version; 
    }
    
    function executeYieldGeneration(uint256 _txRef, uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate) override external payable returns ( bool _isRunning){
        // security restrict to yield manager
        
        YieldProgress memory progress = YieldProgress({
                                                        principal : _principal,
                                                        erc20 : _erc20,
                                                        yieldPercentage : _yieldPercentage,
                                                        deliveryDate : _deliveryDate,
                                                        percentageComplete : 0,
                                                        earningsToDate : 0,
                                                        status : "executing"
                                                    });
        yieldProgressByTxn[_txRef] = progress; 
        if(_erc20 != registry.getERC20Address("NATIVE")){
            IERC20 erc20 = IERC20(_erc20);
            erc20.transferFrom(msg.sender, address(this), _principal);
        }
        
        return true; 
    }
    
    
    function cancelYieldGeneration(uint256 _txRef, uint256 _protocolCancellationFee) override external payable returns (bool _isCanceled, uint256 _totalAmount, uint256 _principal, address _erc20,  uint256 _percentageComplete, uint256 _earningsToDate){
        YieldProgress memory progress = yieldProgressByTxn[_txRef];
        progress.status = "cancelled";
        uint256 total = progress.earningsToDate+progress.principal;
        if(progress.erc20 !=  registry.getERC20Address("NATIVE")){
            yManager.depositYield(_txRef, total, progress.principal, progress.erc20,  progress.percentageComplete, progress.earningsToDate, progress.status);
        }
        else {
            yManager.depositYield{value :total }(_txRef, total, progress.principal, progress.erc20,  progress.percentageComplete, progress.earningsToDate, progress.status);
        }
        return (true, total, progress.principal, progress.erc20, progress.percentageComplete, progress.earningsToDate);
    }
    
    function getProtocolCancellationFee(uint256 _txRef) override external returns (uint256 _protocolCancellationFee){
        return 100; 
    }
    
    
    function checkProgress(uint256 _txRef) override external view returns (uint256 _principal,  address _erc20, uint256 _yieldPercentage, uint256 _deliveryDate, uint256 _percentageComplete, uint256 _earningsToDate){
        YieldProgress memory progress = yieldProgressByTxn[_txRef];
        return (progress.principal, progress.erc20, progress.yieldPercentage, progress.deliveryDate, progress.percentageComplete, progress.earningsToDate);
    }
    
    
    function getEarningsView(uint256 _txRef) override external view returns(uint256 _earningsToDate){
        return earningsToDateByTxn[_txRef];
    }
    
	function pushPayout(uint256 _txRef) external payable returns (uint256 total) {
		YieldProgress memory progress = yieldProgressByTxn[_txRef];
		IERC20 erc20 = IERC20(progress.erc20); 
		
		uint256 target = (1e18+((progress.yieldPercentage*1e18)/100))*progress.principal;
		uint256 total_ = progress.earningsToDate+progress.principal;
		uint256 earningsToTarget = target - total;
		if(progress.erc20 !=  registry.getERC20Address("NATIVE")){
			erc20.transferFrom(msg.sender, address(this), earningsToTarget);
		}
		else {			
            // do nothing balance updated 
		}
					
		progress.status = "complete"; 
		progress.percentageComplete = (total/target) *100; 
		if(progress.erc20 !=  registry.getERC20Address("NATIVE")){
            yManager.depositYield(_txRef, total, progress.principal, progress.erc20,  progress.percentageComplete, progress.earningsToDate, progress.status);
        }
        else {
            yManager.depositYield{value :total }(_txRef, total, progress.principal, progress.erc20,  progress.percentageComplete, progress.earningsToDate, progress.status);
        }
		return total_;
	} 
	
    
    function updateEarnings(uint256 _txRef, uint256 _mockEarningsAmount) external payable returns(uint256 _total) {
		YieldProgress memory progress = yieldProgressByTxn[_txRef];
		if(progress.erc20 !=  registry.getERC20Address("NATIVE")) {
			IERC20 erc20 = IERC20(progress.erc20); 
			erc20.transferFrom(msg.sender, address(this), _mockEarningsAmount); 
		}
		else {
			// do nothing balance updated
		}		
		progress.earningsToDate+= _mockEarningsAmount; 
		uint256 target_ = ((1000000000000000000+(progress.yieldPercentage*10000000000000000))*progress.principal)/1000000000000000000;
		uint256 total_ = progress.earningsToDate+progress.principal;
		progress.percentageComplete = (total_/target_)*100; 
		return total_; 
	}

    function setYieldManagerAddress(address _yieldManagerAddress) external returns (bool _isSet){
        isAdminOnly(); 
        yieldManagerAddress = _yieldManagerAddress;
        yManager = YieldManager(yieldManagerAddress);
        return true; 
    }
    
    // internal functions
    function isAdminOnly() internal view returns (bool _isAdmin){
        require(msg.sender == administrator, " iao 00 - administrator only ");
        return true; 
    }
}