// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    
    mapping(address => uint256) public addressToAmtFunded;
    
    address[] public funders;
    
    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    
    function fund() public payable {
        // $50
        uint256 minUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minUSD, "Must contruct additional pylons.");
    addressToAmtFunded[msg.sender] += msg.value;  
    // eth - > usd converstion rate
    
    funders.push(msg.sender);
    }
    
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
        }
        
        function getPrice() public view returns(uint256) {
            AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
            (,int price,,,) = priceFeed.latestRoundData();
        return uint256(price * 10000000000);
           
        }
        function getConversionRate(uint256 ethAmount) public view returns(uint256) {
            uint256 ethPrice = getPrice();
            uint256 ethAmountInUsd = (ethPrice * ethAmount);
            return ethAmountInUsd;
        }
        
        modifier onlyOwner {
              require(msg.sender == owner);
              _;
        }
        
        
        
        
        function withdraw() payable onlyOwner public {
                       
            msg.sender.transfer(address(this).balance);
            for (uint256 fundersIndex=0; fundersIndex <funders.length; fundersIndex++){
                address funder = funders[fundersIndex];
                addressToAmtFunded[funder] = 0;
            }
            funders = new address[](0);
        }
}