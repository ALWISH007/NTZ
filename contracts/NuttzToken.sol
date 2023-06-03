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

interface IStakeContract {
    // @Will introduce all the staking contract functions after coding staking contract
    function update(uint256 amount) external ;
}
contract NUTTZ is IERC20 {

    string private _name;
    string private _symbol;
    uint256 private _decimals;
    uint256 private _totalSupply;
    uint256 private _taxPercentage;
    address private _stakeContract;
    address private _owner;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor (string memory name, string memory symbol, uint256  decimals,uint256 initialSupply,uint256 taxPercentage,address stakeContract) {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;//
        _owner=msg.sender;
        _taxPercentage=taxPercentage;
        _totalSupply+=initialSupply;
        _stakeContract=stakeContract;
        _balances[msg.sender]+=initialSupply;
    }
    
    modifier onlyOwner() {
        require(msg.sender == _owner,"Caller is not the owner of the contract");
        _;
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

    function TaxPercentage() public view returns (uint256){
        return _taxPercentage;
    }
    
    function StakeContract() public view returns (address){
        return _stakeContract;
    }
    
    function TotalSupply() external view override returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
        _transfer(msg.sender,recipient, amount);
        return true;
    }

    function _transfer(address from, address to,uint256 amount) internal virtual {
        require(to != address(0),"Receiver can not be a  zero address");//
        require(balanceOf(from) >= amount,"Amount must be less than caller's account balance");//
        _beforeTokenTransfer( from,  to,  amount);
        _burn(from,_taxFee(amount));
        _balances[from] -=amount-_taxFee(amount);
        _balances[to] +=amount-_taxFee(amount);
        IStakeContract(_stakeContract).update(_taxFee(amount));
        emit Transfer(from,to,amount);
    }
    //The allowance function allows anyone to check any allowance
    function Allowance(address owner,address spender) public view virtual override returns(uint256){
        return _allowances[owner][spender];
    } 
    
    function Approve(address spender, uint256 amount) public virtual override  returns (bool){
        _approve(msg.sender,spender,amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(spender != address(0),"Spender can not be a zero address");//
        _allowances[owner][spender] = amount;
        emit Approval(owner,spender,amount);
    }

    function _taxFee(uint256 taxableAmount) internal view returns(uint256) {
        return (taxableAmount*_taxPercentage)/100;
    }
    
    function TransferFrom( address from, address to, uint256 amount) external override returns(bool){
        require(_allowances[from][msg.sender] >= amount,"Caller is not allowed to transfer the amount from owner to receiver");
        _transfer(from, to, amount);
        _approve(from,msg.sender,_allowances[from][msg.sender]-amount);
        return true;
    }

    function mint(address account,uint256 amount) external onlyOwner returns(bool){
        _mint(account,amount-_taxFee(amount));
        return true;
    }

    function _mint(address account,uint256 amount) internal virtual {
        require(account != address(0),"ERC20: Mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply+=amount;
        _balances[account]+=amount;
        emit Transfer(address(0),account,amount);
    }

    // burn own tokens
    function burn(uint256 amount) external returns(bool){
        _burn(msg.sender,amount);
        return true;
    }

    // burn tokens from another address(wallet)
    function burnFrom(address account, uint256 amount) external returns(bool){
        require(Allowance(account,msg.sender) >= amount, "Caller is not allowed to burn the amount from owner to receiver");
        _burn(account,amount);
        _approve(account,msg.sender,Allowance(account,msg.sender)-amount);
        return true;
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0),"ERC20: Burn from the zero address");
        require(balanceOf(account) >= amount, "Burn amount exceeds account balance");//
        _beforeTokenTransfer(account, address(0), amount); 
        _totalSupply-=amount;
        _balances[account]-=amount;
        emit Transfer(account,address(0),amount);
    }

    //
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {

    }

}

