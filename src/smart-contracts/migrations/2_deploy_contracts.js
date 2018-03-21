const CitizenHealth = artifacts.require('./CitizenHealth.sol');

module.exports = function(deployer) {
  deployer.deploy(CitizenHealth, {gas: 6000000});
};
