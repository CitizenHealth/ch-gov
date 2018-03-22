module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "devnet",
      port: 8545,
      network_id: "*" // Match any network id
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 500
    }
  } 
};
