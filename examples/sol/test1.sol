pragma solidity >=0.8.0;

contract sendETH{
    
    DeletableMapping deleteMapp = new DeletableMapping();
    
    address _owner;
    
    
    
    mapping (address => uint256) private _balances;
    
    constructor() public {
        _owner = msg.sender;
    }
    
    fallback () external payable {
        
    }

    // Use this function to learn how much money came in total from the message sender account    
    function balanceOf() public view returns (uint256) {
        return deleteMapp.get_balances(msg.sender);
    }
    
    // Use this function to learn  contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance / 1000000000000000000;
    }
    
    // You should enter ether type amount when running it will convert that value to wei.
    function deposit() payable public {
        // amount = amount * 1000000000000000000; // 1 ether = 10^-18 wei (Etherscan)
        // require(msg.value == amount);
        //_balances[msg.sender] += amount; 
        deleteMapp.add_balances(msg.sender, msg.value);
    }
    
    // Gives all the balace to one account
    function withdrawAllToOneAccount() public payable {
        payable(msg.sender).transfer(address(this).balance);
        deleteMapp.deleteAll_balances();

    }
    
    // Pays exact same amount ether back to the account
    function withdrawBack() public payable {
        // payable(msg.sender).transfer(_balances[msg.sender]);
        // _balances[msg.sender] = 0;
        payable(msg.sender).transfer(deleteMapp.get_balances(msg.sender));
        deleteMapp.set_balances(msg.sender, 0);
        
    }

}

contract DeletableMapping {
    // Input is keccak256(uint32 mappingVersion, string _account)
    mapping (bytes32 => uint256) internal _balances;
    uint32 currentMappingVersion;
    
    constructor() public {
        
    }

    // Use this function for getting the order with _account
    function get_balances(address _account) external view returns(uint256) {
        bytes32 key = keccak256(abi.encode(currentMappingVersion, _account));
        return _balances[key];
    }
    
    // This function for setting new _balances.
    function set_balances(address  _account, uint256 _amount) external {
        bytes32 key = keccak256(abi.encode(currentMappingVersion, _account));
        _balances[key] = _amount;
    }
    
    function add_balances(address  _account, uint256 _amount) external {
        bytes32 key = keccak256(abi.encode(currentMappingVersion, _account));
        _balances[key] += _amount;
    }

    // This is the miracle function. In order to delete all _balances it's just increasing its' value with 1.
    function deleteAll_balances() external {
        currentMappingVersion++;
    }

    // This function for deleting the older order which is still there because of an error. (I guess)
    function recoverGas(uint32 _version, address _account) external {
        require(_version < currentMappingVersion);
        bytes32 key = keccak256(abi.encode(_version, _account));
        delete(_balances[key]);
    }
}