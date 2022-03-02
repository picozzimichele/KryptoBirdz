const { assert } = require('chai');
// eslint-disable-next-line no-undef
const KryptoBird = artifacts.require("KryptoBird");

//check for chai
require('chai')
    .use(require('chai-as-promised'))
    .should()

// eslint-disable-next-line no-undef
contract('KryptoBird', (accounts) => {
    let contract

    //before runs first every test
    // eslint-disable-next-line no-undef
    before( async() => {
        contract= await KryptoBird.deployed()
    })
    

    describe('deployment', async() => {
        
        it('deploys successfully', async() => {
            const address = contract.address;
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        })

        it('name of the contract matches', async() => {
            const contractName = await contract.name();
            assert.equal(contractName, 'KryptoBird');
        })

        it('name of the symbol matches', async() => {
            const contractSymbol = await contract.symbol();
            assert.equal(contractSymbol, 'KBIRDZ');
        })
    })

    describe('minting', async() => {
        it("creates a new token", async() => {
            const result = await contract.mint('https...1')
            const totalSupply = await contract.totalSupply()
            
            //success
            assert.equal(totalSupply, 1)
            const event = result.logs[0].args
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'from is the contract')
            assert.equal(event._to, accounts[0], 'to is msg.sender')

            //failure
            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe('indexing', async() => {
        it('lists KryptoBirdz', async() => {
            await contract.mint('https...2')
            await contract.mint('https...3')
            await contract.mint('https...4')
            const totalSupply = await contract.totalSupply()

            //loop through list and grab KBirdz from list
            let result = []
            let KryptoBird

            for(let i = 0; i < totalSupply; i++) {
                KryptoBird = await contract.kryptoBirdz(i)
                result.push(KryptoBird)
            }
            //compare the arrays
            let expected = ['https...1', 'https...2', 'https...3', 'https...4']
            //we can compare 2 strings made from the arrays
            assert.equal(expected.join(','), result.join(','))
        })  
    })
});