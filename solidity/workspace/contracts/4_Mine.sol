// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

// ERC-20
contract Mint {
    uint256 constant private MAX_UINT256 = 2**256 - 1;

    bool private _mintingFinished = false;

    address private _owner;
    
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowed;

    uint256 private _totalSupply;

    string public _name;
    uint8 public _decimals;    
    string public _symbol;

    event Transfer(address from, address to, uint256 value);
    event Approve(address from, address spender, uint256 value);
    event MiningFinished();

    modifier onlyOwner() {
        require(_owner == msg.sender);
        _;
    }
    modifier onlyBeforeMintingFinished() {
        require(!_mintingFinished);
        _;
    }
    
    constructor(uint256 initNumber, string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals) {
        _owner = tx.origin;
        _totalSupply = initNumber;
        _name = tokenName;
        _symbol = tokenSymbol;
        _decimals = tokenDecimals;
        _balances[tx.origin] = initNumber;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(_balances[msg.sender] >= value);

        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        uint256 allowanced = _allowed[from][msg.sender];
        require(_balances[from] >= value && allowanced >= value);

        _balances[from] -= value;
        _balances[to] += value;
        if (allowanced < MAX_UINT256) {
            _allowed[from][msg.sender] -= value;
        }
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        _allowed[msg.sender][spender] = value;
        emit Approve(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    function getOwner() public view returns (address) {
        return _owner;
    }

    function mintingFinished() public view returns (bool) {
        return _mintingFinished;
    }

    function finishMinting() 
        public 
        onlyOwner 
        onlyBeforeMintingFinished 
        returns (bool) {
        _mintingFinished = true;
        emit MiningFinished();
        return true;
    }

    function mint(address to, uint256 value) 
        public 
        onlyOwner 
        onlyBeforeMintingFinished 
        returns (bool) {
        _balances[to] += value;
        _totalSupply += value;
        return true;
    }
}

contract App {

    // function new_mint(uint256 initNumber) public returns (address) {
    function new_mint(uint256 initNumber, string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals) public returns (address) {
        // address newMint = address(new Mint({initNumber: initNumber, tokenName: "filecoin-dog", tokenSymbol: "fdog", tokenDecimals: 18}));
        address newMint = address(new Mint({initNumber: initNumber, tokenName: tokenName, tokenSymbol: tokenSymbol, tokenDecimals: tokenDecimals}));
        return newMint;
    }

    function mint2(uint256[] memory arr, string[] memory arr2, address[] memory arr3, uint256[2][2] memory arr4, uint8[][2] memory arr5) public {

    }

    function mint3(bytes memory arg, bytes32 arg2, bytes30 arg42,int8 arg3, int arg4, int104 arg5) public {

    }

    function mint4(uint256 ar1, uint arg2, uint8 arg3, uint32 arg4, uint64 arg5, uint128 arg6) public  {

    }

    function mint5(bytes memory arg, bytes32 arg2, bytes[] memory arg3, bytes32[] memory arg4) public  {

    }
}
