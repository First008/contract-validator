// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16;

contract Passport {
    
    // Admin
    
    struct Admin{
        uint id;
        string username;
        uint pwd;
    }
    
    // PassWord
    
    struct Pass{
        string PassNumber;
        string Name;
        uint expireDate;
    }

    // Passports hash
    struct PassHash{
        bytes32 hashOfPass;
    }



    // Store expired Passports
    mapping(bytes32 => uint) public expires; // TODO - It is unnecessary i think
    mapping(bytes32 => bool) public expired; 

    // Store Passports
    mapping(uint => PassHash) public passhashes; // TODO - rename this. It holds ids of passhashes
    mapping(bytes32 => bool) public passhashes2; // TODO - rename this. It holds the passhashes
    

    // Store Admins
    // TODO - check if mappings can reducible
    mapping(uint => Admin) public adminsId;
    mapping(address => bool) public adminsAddress;
    mapping(uint => address) public adminIdToAddress;

    // TODO - check if there is unnecessary ones
    uint public adminCount      = 0;
    uint public passpCount      = 0;
    uint public expiredCount    = 0;

    // TODO - removeable
    string returnMessage; 
    bool returnBool;

    // Default admins are created
    constructor () public {

        addDefaultAdmin(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, "Ahmet", 123);
        addDefaultAdmin(0xf604eB5610a9Cd54d96355126177E8BEd0Bb8DAb, "Yusuf", 123);
    }

    // write hash of passport on blockchain
    event hashedEvent (bytes32 indexed _hashedpass);
    
    // Default admin creator function
    function addDefaultAdmin(address _newAdminAddress, string memory _username, uint _pwd) public {
        // require that only adminsId can create new admin.
        adminCount++;

        adminsId[adminCount] = Admin(adminCount, _username, _pwd);
        adminsAddress[_newAdminAddress] = true;
        adminIdToAddress[adminCount] = _newAdminAddress;
    }

    // Adds admin (requires an admin to do this)
    function addAdmin(address _newAdminAddress, string memory _username, uint _pwd) public {
        // require that only adminsId can create new admin.
        require(adminsAddress[msg.sender]);

        adminCount++;

        adminsId[adminCount] = Admin(adminCount, _username, _pwd);
        adminsAddress[_newAdminAddress] = true;
        adminIdToAddress[adminCount] = _newAdminAddress;
    }

    /* TODO - addPassport ile admin yeni bir passport oluşturup hashi kişiye özel 
        oluşturulan bir hesaba atancak 
    */

    // Adds passports hash on blockchain (requires an admin to do this, requires that there is no exact 
    // same hash already on blockchain)
    function addPassport(bytes32 _hashedPass, uint _expireDate) public {
        require(adminsAddress[msg.sender]);

        require(!passhashes2[_hashedPass]);
        passpCount++;

        expires[_hashedPass] = _expireDate;

        // IDEA - Hash yeni oluşturulacak bir adrese tanımlanabilir.
        passhashes2[_hashedPass] = true;
        passhashes[passpCount] = PassHash(_hashedPass);
        emit hashedEvent(_hashedPass);
        
    }

    // TODO - controlPass ile Passaport bilgileri kişiden alınıp hashi kişiye verilen adres ile doğrulanacak
    // Controls if there is a hash on blockchain which is exactly same as hash of given parameters 
    // requires that the passport not expired
    function controllPassport(bytes32 _hashedPass, uint _currentDate) public {
        //require(admins2[msg.sender]); // IDEA - Bence admin yerine herkes kontrol edebilmeli

        require(passhashes2[_hashedPass], "This passport does never existed");
        
        require(!expired[_hashedPass], "This passport already expired");

        require(expires[_hashedPass] > _currentDate, "This passport expired");
    }
    
    // TODO - This function not used yet. But it will be!
    function isAccountAdmin() public returns (bool) {
        if (adminsAddress[msg.sender] == true){ return true; }
        else {return false;}
    }
}

