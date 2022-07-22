const staking = artifacts.require("Staking");

module.exports = function (deployer) {
  deployer.deploy(staking);
};
