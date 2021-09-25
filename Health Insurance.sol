pragma solidity ^0.8.7;

contract HealthInsurance{
    
    address Insurer;
    
    struct User{
        bool Authorised;
        string Name;
        uint InsuranceAmount;
    }
    
    mapping(address=>User) public Usermapping;
    mapping(address=>bool) public Doctormapping;
    
    constructor() public{
        Insurer = msg.sender; 
    }
    
    modifier Insurance(){
        require(Insurer == msg.sender);
        _;
    }
    
    function  setDoctor(address _address) 
    public Insurance{
        require(!Doctormapping[_address]);
        Doctormapping[_address] = true;
    }
    
    function setUser(string memory _Name,uint _InsuranceAmount) 
    public Insurance returns (address){
        address userid = address(bytes20(sha256(abi.encodePacked(msg.sender,block.timestamp))));
        require(!Usermapping[userid].Authorised);
        Usermapping[userid].Authorised = true;
        Usermapping[userid].Name = _Name;
        Usermapping[userid].InsuranceAmount  = _InsuranceAmount;
        
        return userid;
    }
    
    function InsuranceClaim(address _userid,uint _InsuranceAmountUsed) 
    public returns (string memory)
    {
        require(!Doctormapping[msg.sender]);
        if(Usermapping[_userid].InsuranceAmount < _InsuranceAmountUsed){
            revert();
    }
        
        Usermapping[_userid].InsuranceAmount -= _InsuranceAmountUsed;
        return "Amount has been debited from your insurance";
    }
}
