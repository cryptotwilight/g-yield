// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.5.0 <0.9.0; 

import "../core/IOracle.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


contract Chainlink is IOracle { 

	address internal administrator; 
	uint256 chainlinkBalance; 
	
	uint256 version = 1; 
	string name = "CHAINLINK";
	
	string chain = "RINKEBY";

    mapping(string=>bool)allowedChainsByName; 

    mapping(string=>address) marketAddressByMarket; 
    
    address linkAddress; 
    IERC20 link;
    
    string []markets ;

	constructor (address _administrator, address _linkAddress) { 
		administrator = _administrator;
	    linkAddress = _linkAddress; 
	    link = IERC20(linkAddress);
	    loadMarksts();
	    allowedChainsByName["MAINNET"] = true; 
	    allowedChainsByName["RINKEBY"] = true; 
	}


    function getPrice(string memory _market) override external view returns (uint256 _price){
        
        AggregatorV3Interface priceFeed = AggregatorV3Interface(marketAddressByMarket[_market]);
             (   uint80 roundId, int256 answer,uint256 startedAt,uint256 updatedAt, uint80 answeredInRound) = priceFeed.latestRoundData();
        if(answer < 0) {
            _price = uint256( answer * -1);
        }
        else { 
            _price = uint256(answer *1);    
        }
        return _price; 

    }
    
    function hasCredit() override external view returns (bool _hasCredit){
        return link.balanceOf(address(this)) > 0;
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

    function loadMarksts() internal  returns (bool _loaded) {
        uint256 x = 0;
	    markets[x] = "1INCH / ETH";
        markets[x++] = "1INCH / USD";
        markets[x++] = "AAVE / ETH";
        markets[x++] = "AAVE / USD";
        markets[x++] = "ADA / USD";
        markets[x++] = "ADX / USD";
        markets[x++] = "AKRO / USD";
        markets[x++] = "ALPHA / ETH";
        markets[x++] = "AMP / USD";
        markets[x++] = "AMPL / ETH";
        markets[x++] = "AMPL / USD";
        markets[x++] = "AMZN / USD";
        markets[x++] = "ANKR / USD";
        markets[x++] = "ANT / ETH";
        markets[x++] = "APY TVL";
        markets[x++] = "AUCTION / USD";
        markets[x++] = "AUD / USD";
        markets[x++] = "AUTO / USD";
        markets[x++] = "AVAX / USD";
        markets[x++] = "BADGER / ETH";
        markets[x++] = "BADGER / USD";
        markets[x++] = "BAL / ETH";
        markets[x++] = "BAND / ETH";
        markets[x++] = "BAND / USD";
        markets[x++] = "BAT / ETH";
        markets[x++] = "BAT / USD";
        markets[x++] = "BCH / USD";
        markets[x++] = "BNB / ETH";
        markets[x++] = "BNB / USD";
        markets[x++] = "BNT / ETH";
        markets[x++] = "BNT / USD";
        markets[x++] = "BOND / ETH";
        markets[x++] = "BRL / USD";
        markets[x++] = "BTC / ARS";
        markets[x++] = "BTC / ETH";
        markets[x++] = "BTC / USD";
        markets[x++] = "BTC / height";
        markets[x++] = "BTC Difficulty";
        markets[x++] = "BTM / USD";
        markets[x++] = "BUSD / ETH";
        markets[x++] = "BUSD / USD";
        markets[x++] = "BZRX / ETH";
        markets[x++] = "CAD / USD";
        markets[x++] = "CEL / ETH";
        markets[x++] = "CELO / USD";
        markets[x++] = "CNY / USD";
        markets[x++] = "COIN / USD";
        markets[x++] = "COMP / ETH";
        markets[x++] = "COVER / ETH";
        markets[x++] = "COVER / USD";
        markets[x++] = "CREAM / ETH";
        markets[x++] = "CRO / ETH";
        markets[x++] = "CRO / USD";
        markets[x++] = "CRV / ETH";
        markets[x++] = "CRV / USD";
        markets[x++] = "CV / Index";
        markets[x++] = "DAI / ETH";
        markets[x++] = "DAI / USD";
        markets[x++] = "DIA / USD";
        markets[x++] = "DIGG / BTC";
        markets[x++] = "DNT / ETH";
        markets[x++] = "DOGE / USD";
        markets[x++] = "DOT / USD";
        markets[x++] = "DPI / ETH";
        markets[x++] = "DPI / USD";
        markets[x++] = "ENJ / ETH";
        markets[x++] = "EOS / USD";
        markets[x++] = "EPS / USD";
        markets[x++] = "ETC / USD";
        markets[x++] = "ETH / USD";
        markets[x++] = "ETH / XDR";
        markets[x++] = "EUR / USD";
        markets[x++] = "EURS RESERVES";
        markets[x++] = "FB / USD";
        markets[x++] = "FEI / ETH";
        markets[x++] = "FIL / ETH";
        markets[x++] = "FIL / USD";
        markets[x++] = "FRAX / ETH";
        markets[x++] = "FRONT / USD";
        markets[x++] = "FTM / ETH";
        markets[x++] = "FTSE / GBP";
        markets[x++] = "FTT / ETH";
        markets[x++] = "FXS / USD";
        markets[x++] = "Fast Gas / Gwei";
        markets[x++] = "GBP / USD";
        markets[x++] = "GNO / ETH";
        markets[x++] = "GOOGL / USD";
        markets[x++] = "GRT / ETH";
        markets[x++] = "HBAR / USD";
        markets[x++] = "HEGIC / ETH";
        markets[x++] = "HEGIC / USD";
        markets[x++] = "HT / USD";
        markets[x++] = "HUSD / ETH";
        markets[x++] = "INJ / USD";
        markets[x++] = "IOST / USD";
        markets[x++] = "IWM / USD";
        markets[x++] = "JPY / USD";
        markets[x++] = "KNC / ETH";
        markets[x++] = "KNC / USD";
        markets[x++] = "KP3R / ETH";
        markets[x++] = "KRW / USD";
        markets[x++] = "KSM / USD";
        markets[x++] = "LDO / ETH";
        markets[x++] = "LINK / ETH";
        markets[x++] = "LON / ETH";
        markets[x++] = "LRC / ETH";
        markets[x++] = "LRC / USD";
        markets[x++] = "LTC / USD";
        markets[x++] = "MANA / ETH";
        markets[x++] = "MATIC / USD";
        markets[x++] = "MKR / ETH";
        markets[x++] = "MLN / ETH";
        markets[x++] = "MSFT / USD";
        markets[x++] = "MTA / ETH";
        markets[x++] = "MTA / USD";
        markets[x++] = "N225 / JPY";
        markets[x++] = "NEAR / USD";
        markets[x++] = "NFLX / USD";
        markets[x++] = "NGN / USD";
        markets[x++] = "NMR / ETH";
        markets[x++] = "NMR / USD";
        markets[x++] = "NU / ETH";
        markets[x++] = "NZD / USD";
        markets[x++] = "OCEAN / USD";
        markets[x++] = "OKB / USD";
        markets[x++] = "OMG / ETH";
        markets[x++] = "OMG / USD";
        markets[x++] = "ONT / USD";
        markets[x++] = "ORN / ETH";
        markets[x++] = "OXT / USD";
        markets[x++] = "Orchid";
        markets[x++] = "PAX / ETH";
        markets[x++] = "PAX / RESERVES";
        markets[x++] = "PAXG / ETH";
        markets[x++] = "PAXG / RESERVES";
        markets[x++] = "PERP / ETH";
        markets[x++] = "PHP / USD";
        markets[x++] = "PUNDIX / USD";
        markets[x++] = "QQQ / USD";
        markets[x++] = "RAI / ETH";
        markets[x++] = "RAMP / USD";
        markets[x++] = "RARI / ETH";
        markets[x++] = "RCN / BTC";
        markets[x++] = "REN / ETH";
        markets[x++] = "REN / USD";
        markets[x++] = "REP / ETH";
        markets[x++] = "REP / USD";
        markets[x++] = "RGT / ETH";
        markets[x++] = "RLC / ETH";
        markets[x++] = "RUB / USD";
        markets[x++] = "RUNE / USD";
        markets[x++] = "SAND / USD";
        markets[x++] = "SFI / ETH";
        markets[x++] = "SGD / USD";
        markets[x++] = "SNX / ETH";
        markets[x++] = "SNX / USD";
        markets[x++] = "SPY / USD";
        markets[x++] = "SRM / ETH";
        markets[x++] = "STAKE / ETH";
        markets[x++] = "STMX / USD";
        markets[x++] = "SUSD / ETH";
        markets[x++] = "SUSHI / ETH";
        markets[x++] = "SUSHI / USD";
        markets[x++] = "SWAP / ETH";
        markets[x++] = "SXP / USD";
        markets[x++] = "TOMO / USD";
        markets[x++] = "TRIBE / ETH";
        markets[x++] = "TRU / USD";
        markets[x++] = "TRX / USD";
        markets[x++] = "TRY / USD";
        markets[x++] = "TSLA / USD";
        markets[x++] = "TUSD / ETH";
        markets[x++] = "TUSD Reserves";
        markets[x++] = "TUSD Supply";
        markets[x++] = "Total Marketcap / USD";
        markets[x++] = "UMA / ETH";
        markets[x++] = "UNI / ETH";
        markets[x++] = "UNI / USD";
        markets[x++] = "USDC / ETH";
        markets[x++] = "USDC / USD";
        markets[x++] = "USDK / USD";
        markets[x++] = "USDN / USD";
        markets[x++] = "USDT / ETH";
        markets[x++] = "USDT / USD";
        markets[x++] = "UST / ETH";
        markets[x++] = "VSP / ETH";
        markets[x++] = "VXX / USD";
        markets[x++] = "WAVES / USD";
        markets[x++] = "WING / USD";
        markets[x++] = "WNXM / ETH";
        markets[x++] = "WOM / ETH";
        markets[x++] = "WOO / ETH";
        markets[x++] = "WTI / USD";
        markets[x++] = "XAG / USD";
        markets[x++] = "XAU / USD";
        markets[x++] = "XHV / USD";
        markets[x++] = "XMR / USD";
        markets[x++] = "XRP / USD";
        markets[x++] = "XTZ / USD";
        markets[x++] = "XVS / USD";
        markets[x++] = "YFI / ETH";
        markets[x++] = "YFI / USD";
        markets[x++] = "YFII / ETH";
        markets[x++] = "ZAR / USD";
        markets[x++] = "ZEC / USD";
        markets[x++] = "ZRX / ETH";
        markets[x++] = "ZRX / USD";
        markets[x++] = "sCEX / USD";
        markets[x++] = "sDEFI / USD";
        markets[x++] = "sUSD / USD";
     
        return true;   
    }

    function setChain(string memory _chainName) external returns (bool _set){
        chain = _chainName;
    }

} 