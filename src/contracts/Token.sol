//This token is built on the ERC-20 standards for Ethereum
//Set the version of solidity being used
pragma solidity ^0.5.0;
//import the openzeppelin library for handling math functions
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
//name the contract for Token
contract Token {
	//SafeMath is from openzeppelin library
    using SafeMath for uint;

    // Variables
    string public name = "Mythological";
    string public symbol = "MYTH";
    uint256 public decimals = 18; //18 is the default for Ethereum so easiest to use this
    uint256 public totalSupply;

    //track balances with mapping which is an associative array or hash or dictionary
    //mapping lets you create key value pairs
    //address is an account on the blockchain
    //public exposes a function to access the balanceOf 
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events
    // Events are used to allow external users to subscribe to events to know something happened
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    //use the constructor to set the value of variables at instantiation
    constructor() public {
        totalSupply = 1000000 * (10 ** decimals);
        //assign the totalSupply to the person who deployed the smart contract
        //msg is a solidity global variable
        //the sender property of msg is the person who is deploying this smart contract
        balanceOf[msg.sender] = totalSupply;
    }

    //the transfer function is used to send tokens to another account
    //it needs the address to send to and the value of tokens to send
    //it requires that the sender has enough tokens to send
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        _transfer(msg.sender, _to, _value);
        return true;
    }
    //this is additional functionality to update the balances when tokens are sent
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0));
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(_from, _to, _value);
    }
    //the approve is used to allow another account to spend tokens
    //it sets an allowance of tokens that can be transferred
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0));
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    //this allows transfers from one account to another
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        return true;
    }
}
