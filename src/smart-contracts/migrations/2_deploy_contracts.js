const MedexToken = artifacts.require('./MedexToken.sol'); 
const CitizenHealthVotingPlatform = artifacts.require('./CitizenHealthVotingPlatform.sol');
const CitizenHealth = artifacts.require('./CitizenHealth.sol');

module.exports = function(deployer) {

  deployer.deploy(MedexToken).then(function () {
    return deployer.deploy(CitizenHealthVotingPlatform, MedexToken.address)
  }).then(function () {
    return deployer.deploy(CitizenHealth, MedexToken.address, CitizenHealthVotingPlatform.address , {gas: 6000000});
  });  
};
