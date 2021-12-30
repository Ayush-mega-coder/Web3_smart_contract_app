require('@nomiclabs/hardhat-waffle');

module.exports = {
  solidity: '0.8.0',
  networks: {
    rinkeby: {
      url: 'https://eth-rinkeby.alchemyapi.io/v2/ihXFSdvrOkn7rF55Zlln78pLul8usya8',
      accounts: ['fd4102aa981f8c26fd6bbe650a2445b320b8cfa794811d4ed63097dfa7a6f7a4'],
    },
  },
};