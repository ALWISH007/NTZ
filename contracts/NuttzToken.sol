// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner,address indexed spender, uint256 value);
    function TotalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns(bool);
    function Allowance(address owner, address spender) external view returns(uint256);
    function Approve(address spender, uint256 amount) external returns(bool);
    function TransferFrom( address from, address to, uint256 amount) external returns(bool);

}


contract NUTTZ is IERC20 {

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    
    uint256 private totalSupply;
    string private name;
    string private symbol;
    uint256 private decimals;

    constructor (string memory _name, string memory _symbol, uint256  _decimals,uint256 amount) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply+=amount;
        balances[msg.sender]+=amount;
    }

    function Name() public view returns (string memory){
        return name;
    }

    function Symbol() public view returns (string memory){
        return symbol;
    }

    function Decimals() public view returns (uint256){
        return decimals;
    }

    function TotalSupply() external view override returns (uint256){
        return totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
        require(recipient != address(0),"Receiver can not be a  zero address");
        require(balanceOf(msg.sender) >= amount,"Amount must be less than sender's account balance");
        balances[msg.sender] -=amount;
        balances[recipient] +=amount;
        emit Transfer(msg.sender,recipient,amount);
        return true;

    }
    //The allowance function allows anyone to check any allowance
    function Allowance(address owner,address spender) public view virtual override returns(uint256){
        return allowances[owner][spender];
    } 
    
    function Approve(address spender, uint256 amount) public virtual override  returns (bool){
        require(spender != address(0),"Spender can not be a zero address");
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }

    function TransferFrom( address from, address to, uint256 amount) external override returns(bool){
        require(from != address(0),"from address can not be a zero address");
        require(to != address(0),"to address can not be a zero address");
        require(msg.sender != address(0),"Spender can not be zero address");
        require(balances[from] >= amount," Balance of owner is less than the amount");
        require(allowances[from][msg.sender] >= amount,"Caller is not allowed to transfer the amount from owner to receiver");
        balances[from]-=amount;
        balances[to]+=amount;
        emit Transfer(from,to,amount);
        allowances[from][msg.sender]-=amount;
        emit Approval(from,msg.sender,allowances[from][msg.sender]);
        return true;
    }

}

