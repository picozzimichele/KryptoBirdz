const { assert } = require('chai');
// eslint-disable-next-line no-undef
const KryptoBird = artifacts.require("Kryptobird");

//check for chai
require('chai')
    .use(require('chai-as-promised'))
    .should()

// eslint-disable-next-line no-undef
contract('KryptoBird', accounts => {
    let contract

    describe('deployment', async() => {
        
        it('deploys successfully', async() => {
            contract = await KryptoBird.deployed()
            const address = contract.address;
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        })

        it('name of the contract matches', async() => {
            contract = await KryptoBird.deployed()
            const contractName = await contract.name();
            assert.equal(contractName, 'KryptoBird');
        })

        it('name of the symbol matches', async() => {
            contract = await KryptoBird.deployed()  
            const contractSymbol = await contract.symbol();
            assert.equal(contractSymbol, 'KBIRDZ');
        })
    })
});