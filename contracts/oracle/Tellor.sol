// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/tellor-io/usingtellor/blob/master/contracts/UsingTellor.sol";
import "../core/IOracle.sol";

contract Tellor is UsingTellor, IOracle {
    
    address tellorAddress; 
    address administrator; 
    
    mapping(string=>uint256) marketIdByMarket; 
    string [] markets; 
    
    string name = "TELLOR";
    uint256 version = 2; 
    uint256 tbalance; 
    
    
    constructor (address _administrator, address payable _tellorAddress) UsingTellor(_tellorAddress){
        administrator = _administrator; 
        tellorAddress = _tellorAddress; 
        loadValues(); 
    }
    
    function getPrice(string memory _market) override external view returns (uint256 _price){
        
        bool ifRetrieve;  
        
        uint256 timestamp; 
        (ifRetrieve, _price, timestamp) = getCurrentValue(marketIdByMarket[_market]);
        if(!ifRetrieve) {
          //  _price = 0; 
            
        }
        return _price; 
    }
    
    function hasCredit() override external view returns (bool _hasCredit){
        return tbalance > 0; 
    }
      
    	
	function getMarkets() override external view returns (string [] memory _markets){
	    return markets; 
	}
	
        
    function getVersion() override  external view returns(uint256 _version){
        return version; 
    }

	function getName() override  external view returns (string memory _name){
	    return name; 
	}
	
	function loadValues() internal returns (bool _loaded) { 
	    marketIdByMarket["ETH/USD"] = 1;
        marketIdByMarket["BTC/USD"] = 2;
        marketIdByMarket["BNB/USD"] = 3;
        marketIdByMarket["BTC/USD 24 Hour TWAP"] = 4;
        marketIdByMarket["ETH/BTC"] = 5;
        marketIdByMarket["BNB/BTC"] = 6;
        marketIdByMarket["BNB/ETH"] = 7;
        marketIdByMarket["ETH/USD 24 Hour TWAP"] = 8;
        marketIdByMarket["ETH/USD EOD Median"] = 9;
        marketIdByMarket["AMPL/USD Custom"] = 10;
        marketIdByMarket["ZEC/ETH"] = 11;
        marketIdByMarket["TRX/ETH"] = 12;
        marketIdByMarket["XRP/USD"] = 13;
        marketIdByMarket["XMR/ETH"] = 14;
        marketIdByMarket["ATOM/USD"] = 15;
        marketIdByMarket["LTC/USD"] = 16;
        marketIdByMarket["WAVES/BTC"] = 17;
        marketIdByMarket["REP/BTC"] = 18;
        marketIdByMarket["TUSD/ETH"] = 19;
        marketIdByMarket["EOS/USD"] = 20;
        marketIdByMarket["IOTA/USD"] = 21;
        marketIdByMarket["ETC/USD"] = 22;
        marketIdByMarket["ETH/PAX"] = 23;
        marketIdByMarket["ETH/BTC 24 Hour TWAP"] = 24;
        marketIdByMarket["USDC/USDT"] = 25;
        marketIdByMarket["XTZ/USD"] = 26;
        marketIdByMarket["LINK/USD"] = 27;
        marketIdByMarket["ZRX/BNB"] = 28;
        marketIdByMarket["ZEC/USD"] = 29;
        marketIdByMarket["XAU/USD"] = 30;
        marketIdByMarket["MATIC/USD"] = 31;
        marketIdByMarket["BAT/USD"] = 32;
        marketIdByMarket["ALGO/USD"] = 33;
        marketIdByMarket["ZRX/USD"] = 34;
        marketIdByMarket["COS/USD"] = 35;
        marketIdByMarket["BCH/USD"] = 36;
        marketIdByMarket["REP/USD"] = 37;
        marketIdByMarket["GNO/USD"] = 38;
        marketIdByMarket["DAI/USD"] = 39;
        marketIdByMarket["STEEM/BTC"] = 40;
        marketIdByMarket["USPCE"] = 41;
        marketIdByMarket["BTC/USD EOD Median"] = 42;
        marketIdByMarket["TRB/ETH"] = 43;
        marketIdByMarket["BTC/USD 1 Hour TWAP"] = 44;
        marketIdByMarket["TRB/USD EOD Median"] = 45;
        marketIdByMarket["ETH/USD 1 Hour TWAP"] = 46;
        marketIdByMarket["BSV/USD"] = 47;
        marketIdByMarket["MAKER/USD"] = 48;
        marketIdByMarket["BCH/USD 24 Hour TWAP"] = 49;
        marketIdByMarket["TRB/USD"] = 50;
        marketIdByMarket["XMR/USD"] = 51;
        marketIdByMarket["XFT/USD"] = 52;
        marketIdByMarket["BTCDominance"] = 53;   
        marketIdByMarket["WAVES/USD"] = 54;
        marketIdByMarket["OGN/USD"] = 55;
        marketIdByMarket["VIXEOD"] = 56;
        marketIdByMarket["DEFITVL"] = 57;
        marketIdByMarket["DEFICAP"] = 58;
        
        markets.push("ZERO");
        markets.push("ETH/USD");
        markets.push("BTC/USD");
        markets.push("BNB/USD");
        markets.push("BTC/USD 24 Hour TWAP");
        markets.push("ETH/BTC");
        markets.push("BNB/BTC");
        markets.push("BNB/ETH");
        markets.push("ETH/USD 24 Hour TWAP");
        markets.push("ETH/USD EOD Median");
        markets.push("AMPL/USD Custom");
        markets.push("ZEC/ETH");
        markets.push("TRX/ETH");
        markets.push("XRP/USD");
        markets.push("XMR/ETH");
        markets.push("ATOM/USD");
        markets.push("LTC/USD");
        markets.push("WAVES/BTC");
        markets.push("REP/BTC");
        markets.push("TUSD/ETH");
        markets.push("EOS/USD");
        markets.push("IOTA/USD");        
        markets.push("ETC/USD");
        markets.push("ETH/PAX");
        markets.push("ETH/BTC 24 Hour TWAP");
        markets.push("USDC/USDT");
        markets.push("XTZ/USD");
        markets.push("LINK/USD");
        markets.push("ZRX/BNB");
        markets.push("ZEC/USD");
        markets.push("XAU/USD");
        markets.push("MATIC/USD");
        markets.push("BAT/USD");
        markets.push("ALGO/USD");
        markets.push("ZRX/USD");
        markets.push("COS/USD");
        markets.push("BCH/USD");
        markets.push("REP/USD");
        markets.push("GNO/USD");
        markets.push("DAI/USD");        
        markets.push("STEEM/BTC");
        markets.push("USPCE");
        markets.push("BTC/USD EOD Median");
        markets.push("TRB/ETH");
        markets.push("BTC/USD 1 Hour TWAP");
        markets.push("TRB/USD EOD Median");      
        markets.push("ETH/USD 1 Hour TWAP");
        markets.push("BSV/USD");
        markets.push("MAKER/USD");
        markets.push("BCH/USD 24 Hour TWAP");
        markets.push("TRB/USD");
        markets.push("XMR/USD");
        markets.push("XFT/USD");
        markets.push("BTCDominance");
        markets.push("WAVES/USD");
        markets.push("OGN/USD");
        markets.push("VIXEOD");
        markets.push("DEFITVL");
        markets.push("DEFICAP");
     
        return true;   
	}
}