## About

**FundMe is a simple Foundry project to enable users deposit funds into a smart contract, it makes use of an Aggregator Interface to get price feed from Chainlink address in order to get the value of the minimum amount in USD a user can donate, There is also a Price Converter contract to that checks the current price of Eth from the Aggregator and converts to the required value in USD**

The Project consist of:
  - **SRC**: This Contains all the contracts available in the Repo.
  - **Script**: This Contains the scripts required to deploy and interact with the Contrats.
  - **Test**: This Contains a folder for Integration test, Unit Test and Mock Aggregator Contract for local deployment.
  - **Gas-Snapshot**: This contains a gas report from all the contracts in the Project.
  - **Makefile**: This Contains all Make commands to use when interacting or deploying the contract locally.


