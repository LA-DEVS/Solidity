// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0


pragma solidity ^0.8.0;
import "//contracts/ERC20.sol";
abstract contract Stakingcontract is ERC20{
    ERC20 public token;
    uint256 public rewardRate = 100; // Beispiel-Belohnungsrate
    uint256 public totalStake;
    uint256 public stakingPeriod;
    bool public paused;
    address public owner;
    address[] public Staker;
    mapping(address => uint256) public stakedAmounts;
    mapping(address => uint256) public rewardBalances;
    mapping(address => uint256) public lastStakedTime;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public isStaker;

//verschiedene Events
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event EmergencyWithd(address indexed user, uint256 amount);
    event Restaked(address indexed user , uint256 amount);

//modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Staking is paused");
        _;
    }

//constructor
    constructor(ERC20 _token) {
        token = _token;
        owner = msg.sender;
    }

    function stake(uint256 amount) external whenNotPaused {
        require(amount > 0, "Amount must be greater than 0"); //mindest-Amount
        token._transfer(msg.sender, address(this), amount); //Transfer-Befehl
        stakedAmounts[msg.sender] += amount;  // Mappen des neu-gestaketen Amounts auf den Key-Value (Empfangsadresse)
        totalStake += amount; // Insgesamt gestaketen coins von allen Usern
        lastStakedTime[msg.sender] = block.timestamp; //Mappen der Zeit des Stakes auf den Empfänger-Key
        //Staker.push(msg.sender);  //Adresse wird zu adressen der Staker hinzugefügt

        //Alternative weniger gas fees
        if (!isStaker[msg.sender]) {  // Überprüfen ob der Benutzer bereits ein Staker ist
            isStaker[msg.sender] = true;
        }
        emit Staked(msg.sender, amount);   // Hier wird ein log gespeichert
    }
    function unstake(uint256 amount)external whenNotPaused{
        require( amount > 0  && amount <= stakedAmounts[msg.sender], "Amount must be greater than 0 and smaller then the staked Amount"); //mindest-Amount
        _updateReward(msg.sender);
        stakedAmounts[msg.sender] -= amount;
        totalStake -= amount;
        token._transfer(address(this), msg.sender, amount);
        emit Unstaked(msg.sender, amount);
    }
    function restake(uint256 amount)external whenNotPaused{
        require ( amount > 0 /*&& isStaker[msg.sender] = true*/, "Amount must be greater than 0" );
        token._transfer(msg.sender, address(this), amount);
        _updateReward(msg.sender);
        stakedAmounts[msg.sender] += amount;
        totalStake += amount;
        emit Restaked(msg.sender, amount);

    }
    function calcReward(address user)public view returns(uint256){
        uint256 stakedTime = block.timestamp - lastStakedTime(user) ;
        uint256 stakedAmount = stakedAmounts(user);
        return stakedAmount * stakedTime * rewardRate / 1e18;
    }
    function distributeReward(address user) external onlyOwner{
        if (isStaker[user]){
            _updateReward(user);
        }
    }
    function setRewardRate(uint256 Rate)external onlyOwner{
        rewardRate = Rate;
    }
    function SetStakingPeriod(uint256 period) external onlyOwner{
        stakingPeriod = period;
    }
    function pause() external onlyOwner{
        paused = true;
    }
    function unpause() external onlyOwner{
        paused = false;
    }
    function stakedAm(address user) external view returns(uint256){
        return stakedAmounts[user];
    }
    function totalStaked()external view returns(uint256){
        return totalStake;
    }
    function rewardBalance(address user)external view returns (uint256){
        return rewardBalances[user];
    }
    function EmergencyWithdraw(uint256 amount) external whenNotPaused{
        amount = stakedAmounts[msg.sender];
        require(amount > 0, "No staked amount");
        stakedAmounts[msg.sender] = 0;
        totalStake -= amount;
        token.transfer(msg.sender, amount);
        emit EmergencyWithd(msg.sender, amount);}
//function AddtoWhitelist(){}
//function RemovefromWhielist(){}
    function _updateReward(address user) internal{
        uint256 reward = calcReward(user);
        rewardBalances[user] += reward;
        lastStakedTime[user] = block.timestamp;
    }
}