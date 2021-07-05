// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <=0.9.0; 

import "@umb-network/toolbox/dist/contracts/IChain.sol";
import "@umb-network/toolbox/dist/contracts/lib/ValueDecoder.sol";
import "@umb-network/toolbox/dist/contracts/IRegistry.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "../core/IOracle.sol";

contract Umbrella is IOracle { 

    using ValueDecoder for bytes;


    address internal umbTokenAddress = 0x6fC13EACE26590B80cCCAB1ba5d51890577D83B2; 
    address internal registryAddress = 0x968A798Be3F73228c66De06f7D1109D8790FB64D; // Ropsten

    address administrator; 
    
    IERC20 umbToken; 
    
    string name = "UMBRELLA";
    uint256 version = 1; 

    uint256 uBalance; 
    
    IRegistry registry; 
    
    string [] markets = ["ETH-USD","BTC-USD","LINK-USD","FIXED_DAFI-TVL","UNI-USD","BNB-USD","UMB-USD","DAI-BNB","GVol-BTC-IV-28days","GVol-ETH-IV-28days"]; 

    string [] marketsL2 = ["BTC-USD","ETH-USD","BTC-JPY","BTC-EUR","ADA-USDT","XRP-USDT","DOT-USDT","ETH-BTC","LTC-USDT","BUSD-USDT","EOS-USDT","ETH-EUR","BNB-BUSD","BTC-USDC","TRX-USDT","IOST-USDT","XLM-USDT","DOGE-USDT","BNB-BTC","ADA-BTC","ATOM-USDT","XRP-BTC","LTC-USD","HT-USDT","BTC-GBP","USDT-USD","LTC-BTC","ZEC-USDT","ETC-USDT","NEO-USDT","SRM-USDT","BSV-USDT","USDC-USDT","ETH-JPY","DASH-USDT","SOL-USDT","XEM-BTC","ONT-USDT","DOT-BTC","FTM-USDT","SUSHI-USDT","XLM-USD","ADA-USD","BTT-USDT","UNI-USD","BNB-USD","VET-USDT","BCH-BTC","FIXED_DAFI-TVL","LINK-USD","UMB-USD","ZDEX-USDT","ZDEX-EUR","DAI-BNB","ETH-USD-TWAP-1day","AMPL-USD-VWAP-1day","GVol-BTC-IV-1day","GVol-BTC-IV-28days","GVol-ETH-IV-1day","GVol-ETH-IV-28days","EQ:TSLA","EQ:FB","EQ:AMZN","EQ:AAPL","EQ:GOOG","EQ:IBM","EQ:COIN","EQ:ABNB"]; 

    constructor(address _administrator) {
        administrator = _administrator; 
        registry        = IRegistry(registryAddress);
        umbToken        = IERC20(umbTokenAddress);
    }

    function getPrice(string memory _market) override external view returns (uint256 _price){
        
        bytes32  key_ = convert(_market);
        uint256 timestamp; 
        (_price, timestamp) = _chain().getCurrentValue(key_);
        
        return _price; 
    }
    
    function hasCredit() override external view returns (bool _hasCredit){
       return umbToken.balanceOf(address(this)) > 0; 
    }
	
	function getMarkets() override external view returns (string [] memory _markets){
	    return markets; 
	}
	
	function getVersion() override external view returns(uint256 _version){
        return version; 
    }

	function getName() override external view returns (string memory _name){
	    return name; 
	}

    function _chain() internal view returns (IChain umbChain) {
        umbChain = IChain(registry.getAddress("Chain"));
    }
    
    function convert(string memory _market) internal pure returns (bytes32 _key){
        assembly {
            _key := mload(add(_market, 32))
        }
        return _key;     
    }

}