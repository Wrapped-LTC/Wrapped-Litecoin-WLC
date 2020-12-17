pragma solidity ^0.7.5;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";

contract WrappedLitecoin {
    uint256 public TokenCap;
    uint256 private TotalSupply;
    string public name;
    string public symbol;
    uint8 public decimals;
    address private owner;
    uint256 private MaxBurntSupply;
    uint256 public BurntSupply;
    address private ZeroAddress;
    AggregatorV3Interface internal priceFeed;
    //variable Declarations
    
    
    
    mapping (address => uint256) private AddressBal;
    
    
    constructor(uint256 _TokenCap, uint256 _TokenSupply, string memory _name, string memory _symbol, uint8 _decimals,address _OwnerAddress, uint256 _MaxBurn){
    TokenCap = _TokenCap;
    TotalSupply = _TokenSupply;
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    MaxBurntSupply = _MaxBurn;
    owner = _OwnerAddress;
    priceFeed = AggregatorV3Interface(0x4d38a35C2D87976F334c2d2379b535F1D461D9B4);
    //Deployment Constructor
    }
    
    //functions
    
    function totalSupply() public view returns(uint256){
        return TotalSupply;
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance){
        return AddressBal[_owner];
    }
    
    function transfer(address _to, uint256 _value) public returns(bool success){
        require (AddressBal[msg.sender] >= _value);
        AddressBal[msg.sender] -= _value;
        AddressBal[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return success;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        require (AddressBal [_from] >= _value);
        require (msg.sender == owner);
        AddressBal [_from] -= _value;
        AddressBal [_to] += _value;
        emit Transfer(_from, _to, _value);
        return success;
        
    }
        
    function approve(address _spender, uint256 _value) public returns (bool success){
        emit Approval(owner, _spender, _value);
        return success;
        
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        
    }

        
    function Mint(address _MintTo, uint256 _MintAmount) public {
        require (msg.sender == owner);
        require (TotalSupply + _MintAmount <= TokenCap);
        AddressBal[_MintTo] += _MintAmount;
        TotalSupply += _MintAmount;
        ZeroAddress = 0x0000000000000000000000000000000000000000;
        emit Transfer(ZeroAddress ,_MintTo, _MintAmount);
    }
    
    function Burn(uint256 _BurnAmount) public {
        require (AddressBal [msg.sender] >= _BurnAmount);
        require (MaxBurntSupply >= BurntSupply + _BurnAmount);
        AddressBal[msg.sender] -= _BurnAmount;
        TotalSupply -= _BurnAmount;
        BurntSupply += _BurnAmount;
        emit Transfer(msg.sender, owner, _BurnAmount);
        
    }
    
    function GetLTCPrice() external view returns(int256){
     (, int256 answer,,,) = priceFeed.latestRoundData();
    return answer;
    }
        
     //Event Declarations   
    event Transfer(address indexed from, address indexed to, uint256 value);    
    event Approval(address indexed owner, address indexed spender, uint256 value);
    

    
    //
    
    
}


