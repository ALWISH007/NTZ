// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

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
    
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint256 private _decimals;

    constructor (string memory name, string memory symbol, uint256  decimals,uint256 amount) {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply+=amount;
        balances[msg.sender]+=amount;
    }

    function Name() public view returns (string memory){
        return _name;
    }

    function Symbol() public view returns (string memory){
        return _symbol;
    }

    function Decimals() public view returns (uint256){
        return _decimals;
    }

    function TotalSupply() external view override returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
        _transfer(msg.sender,recipient, amount);
        return true;

    }
    function _transfer(address from, address to,uint256 amount) internal virtual {
        require(to != address(0),"Receiver can not be a  zero address");
        require(balanceOf(from) >= amount,"Amount must be less than caller's account balance");
        balances[from] -=amount;
        balances[to] +=amount;
        emit Transfer(from,to,amount);
    }
    //The allowance function allows anyone to check any allowance
    function Allowance(address owner,address spender) public view virtual override returns(uint256){
        return allowances[owner][spender];
    } 
    
    function Approve(address spender, uint256 amount) public virtual override  returns (bool){
        _approve(msg.sender,spender,amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(spender != address(0),"Spender can not be a zero address");
        allowances[owner][spender] = amount;
        emit Approval(owner,spender,amount);
    }

    function TransferFrom( address from, address to, uint256 amount) external override returns(bool){
        require(allowances[from][msg.sender] >= amount,"Caller is not allowed to transfer the amount from owner to receiver");
        _transfer(from, to, amount);
        _approve(from,msg.sender,allowances[from][msg.sender]-amount);
        return true;
    }

}

