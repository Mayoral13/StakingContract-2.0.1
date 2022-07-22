pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./SafeMath.sol";
contract Staking is ERC20{
  using SafeMath for uint;
  address owner;
  address[]Stakeholders;
  mapping(address => uint)private stakes;
  mapping(address => uint)private rewards;
  constructor()
  ERC20("MAYOGG","MAYO")
  {
    _mint(address(this),1000000000);
    
    owner = msg.sender;

  } 
   
  

  function CheckStakeholder(address _user)public view returns(bool success){
    for (uint i = 0; i<Stakeholders.length;i++){
      if (_user == Stakeholders[i])
      return true;
    }

  }
  
  function CheckStake(address _user)public view returns (uint){
    return stakes[_user];
  }

  function CreateStake(uint _value)public returns (bool success){
    require(CheckStakeholder(msg.sender) == true,"Not a Stakeholder");
    require (balanceOf(msg.sender) >= _value,"Insufficient Funds");
    require(rewards[msg.sender] == 0 ,"Remove your Rewards first");
    _burn(msg.sender, _value);
    stakes[msg.sender] = stakes[msg.sender].add(_value);
    return true;
    
  }

  function RemoveStake(uint _value)public  returns(bool success){
    require(CheckStakeholder(msg.sender) == true,"Not a Stakeholder");
    require(stakes[msg.sender] != 0,"You must have a Stake");
    require(rewards[msg.sender] == 0 ,"Remove your Rewards first");
    stakes[msg.sender] = stakes[msg.sender].sub(_value);
   if (stakes[msg.sender] == 0){
       RemoveStakeholder(msg.sender);
   }
     _mint(msg.sender, _value);
    return true;
  }

  function AddStakeholder(address _user) public  returns (bool success){
    require(msg.sender == _user,"Not User");
    require(CheckStakeholder(_user) == false,"Already a Stakeholder");
    Stakeholders.push(_user);
    return true;
  }

  function RemoveStakeholder(address _user) public  returns (bool success){
    require(rewards[_user] == 0,"Remove Your Reward First");
      require(msg.sender == _user,"Not User");
    require(CheckStakeholder(_user) == true,"Not a Stakeholder");
       for (uint i = 0; i<Stakeholders.length;i++){
         require(stakes[_user] == 0,"You cannot remove an active stake");
      if (_user == Stakeholders[i]){
      Stakeholders.pop();
      }
       }
       return true;
  }


  function CheckTotalStakes()public view  returns(uint){
    uint TotalStakes = 0;
    for(uint i = 0; i<Stakeholders.length;i++){
      TotalStakes = TotalStakes.add(stakes[Stakeholders[i]]);
    }
    return TotalStakes;
  }

  function CheckReward(address _user) public view returns (uint){
    require(CheckStakeholder(_user) == true,"Only Stakeholders can check rewards");
     return rewards[_user];
  }

 

  function TotalReward()public view returns (uint){
    uint totalRewards = 0;
     for(uint i = 0; i<Stakeholders.length;i++){
      totalRewards = totalRewards.add(rewards[Stakeholders[i]]);
    }
    return totalRewards;
  }

  function WithdrawRewards(address _user,uint _value)public  returns(bool success){
    require(msg.sender == _user,"Not User");
     require(CheckStakeholder(_user) == true,"Not a Stakeholder");
     require(_value == rewards[_user],"Withdraw entire reward");
    rewards[_user] = rewards[_user].sub(_value);
    RemoveStakeholder(_user);
    _mint(_user,_value);
    return true;
  }
  
  function CalculateRewards(address _user)public view returns(uint){
     require(msg.sender == _user,"Not User");
    require(CheckStakeholder(_user) == true,"Not a Stakeholder");
    return stakes[_user].div(500);
  }
  

   function DistributeRewards()public 
    {
      uint reward = 0;
        for (uint i = 0; i < Stakeholders.length; i++){
            address stakeholder = Stakeholders[i];
            reward = CalculateRewards(stakeholder);
            rewards[stakeholder] = rewards[stakeholder].add(reward);
        }
    }
  


 
 




}
