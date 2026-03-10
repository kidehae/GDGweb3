// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {

    /* =============================================================
                            STEP 1
       Create the Campaign struct.
       It must store:
       - owner (address)
       - goal (uint256)
       - pledged amount (uint256)
       - start time (uint256)
       - end time (uint256)
       - claimed status (bool)
    ============================================================= */
    
    // TODO: Define struct here

    struct Campaign{
        address owner;
        uint256 goal;
        uint256 pledged;
        uint256 start;
        uint256 end;
        bool claimed;
    }



    /* =============================================================
                            STEP 2
       Create state variables:
       - campaignCount (uint256)
       - mapping from campaignId to Campaign
       - nested mapping to track how much each address pledged
    ============================================================= */
    
    // TODO: Declare 
    uint256 public campaignCount;

    
    // TODO: Declare campaigns mapping
    mapping(uint256 => Campaign) public campaigns;
    
    // TODO: Declare pledgedAmount nested mapping
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount;



    /* =============================================================
                            STEP 3
       Create the create() function.
       It should:
       - Accept goal and duration
       - Increment campaignCount
       - Create a new Campaign struct
       - Set owner to msg.sender
       - Set pledged to 0
       - Set startAt to current block.timestamp
       - Set endAt to block.timestamp + duration
       - Set claimed to false
    ============================================================= */
    
    // TODO: Implement create()
     function create(uint256 goal, uint256 duration) external {
        require(goal > 0, "Goal must be greater than zero.");
        require(duration > 0, "Duration must be greater than zero.");

        campaignCount++;

        campaigns[campaignCount] = Campaign({
            owner: msg.sender,
            goal: goal,
            pledged: 0,
            start: block.timestamp,
            end: block.timestamp + duration,
            claimed: false
        });
    }


    /* =============================================================
                            STEP 4
       Create the pledge() function.
       It should:
       - Be payable
       - Take campaign ID
       - Check campaign has not ended
       - Increase total pledged
       - Increase user’s pledged amount
    ============================================================= */
    
    // TODO: Implement pledge()
    function pledge(uint256 _cid) external payable {
        require(_cid <= campaignCount && _cid > 0, "Invalid campaign ID");
        require(msg.value > 0, "Pledge amount should be greater than zero");

        Campaign storage campaign = campaigns[_cid];
        require(block.timestamp < campaign.end, "Campaign has ended");

        campaign.pledged += msg.value;
        pledgedAmount[_cid][msg.sender] += msg.value;
    }



    /* =============================================================
                            STEP 5
       Create the claim() function.
       It should:
       - Allow only campaign owner
       - Require campaign ended
       - Require goal reached
       - Require not already claimed
       - Mark claimed = true
       - Transfer total pledged to owner
    ============================================================= */
    
    // TODO: Implement claim()

     function claim(uint256 _cid) external {
        require(_cid <= campaignCount && _cid > 0, "Invalid campaign ID");

        Campaign storage campaign = campaigns[_cid];

        require(block.timestamp >= campaign.end, "Campaign has not ended");
        require(!campaign.claimed, "Campaign already claimed");
        require(campaign.owner == msg.sender, "Only accessed by campaign owner");
        require(campaign.pledged >= campaign.goal, "Goal not reached");

        campaign.claimed = true;

        (bool success, ) = payable(campaign.owner).call{value: campaign.pledged}("");
        require(success, "Transfer failed");
    }



    /* =============================================================
                            STEP 6
       Create the refund() function.
       It should:
       - Require campaign ended
       - Require goal NOT reached
       - Get user pledged amount
       - Set user pledged amount to 0
       - Transfer ETH back to user
    ============================================================= */
    
    // TODO: Implement refund()
   function refund(uint256 _cid) external {
        require(_cid <= campaignCount && _cid > 0, "Invalid campaign ID");

        Campaign storage campaign = campaigns[_cid];

        require(block.timestamp >= campaign.end, "Campaign has not ended");
        require(campaign.pledged < campaign.goal, "Goal has been reached");

        uint256 amount = pledgedAmount[_cid][msg.sender];
        require(amount > 0, "No funds to refund");

        pledgedAmount[_cid][msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

}
