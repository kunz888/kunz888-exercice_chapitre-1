
const ganache = require('ganache-cli');
const provider = ganache.provider();
const Web3 = require('web3');
const web3 = new Web3(provider);
const solc = require('solc');
const fs = require("fs");
const assert = require('assert');
const mocha = require('mocha');

const input = {
    language: 'Solidity',
    sources: {
        'Distributor.sol': {
            content: fs.readFileSync("./exercices/rush/sources/Distributor.sol", "utf-8")
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['*']
            }
        }
    }
};

const {contracts} = JSON.parse(solc.compile(JSON.stringify(input)));

const abi = contracts['Distributor.sol']['Distributor'].abi;
const bytecode = contracts['Distributor.sol']['Distributor'].evm.bytecode;

const getAccounts = async () => {
    return await web3.eth.getAccounts();
};
mocha.describe('Distributor', () => {
    const contractName = 'Distributor';
    let accounts = undefined;
    let contract = undefined;

    mocha.beforeEach(async () => {
        accounts = await web3.eth.getAccounts();
        contract = await new web3.eth.Contract(abi)
            .deploy({data: bytecode.object.toString()})
            .send({from: accounts[0], gas: 3000000});
           
    });

    mocha.it('Has been deployed', async () => {
        try {
       

            assert.ok(contract.options.address);

        } catch (e) {
            console.error(e);
        }
    })

    mocha.it('all variables are good', async () => {
        const item_quantity = await contract.methods.item_quantity().call();
        const account = await web3.eth.getAccounts();
        assert.equal(item_quantity, 9);
    });
    mocha.it('Buy Items', async () => {

        let balanceContractBeforeSend = await web3.eth.getBalance(contract.options.address);
        console.log("distributeur",balanceContractBeforeSend);
        let balanceReceiveBeforeSend = await web3.eth.getBalance(accounts[0]);
        console.log("compte client",balanceReceiveBeforeSend);
       //
       const tx= await contract.methods.payItem("Coca",5).send({from:accounts[0], gas: 3000000,value:5});
       console.log(tx);
       console.log(`Message: ${tx.gasUsed}`);

       const tx11= await contract.methods.payItem("Lion",2).send({from:accounts[0], gas: 3000000,value:4});
       console.log(tx11);
       console.log(`Message: ${tx11.gasUsed}`);

       const tx12= await contract.methods.payItem("Mars",2).send({from:accounts[0], gas: 3000000,value:4});
       console.log(tx12);
       console.log(`Message: ${tx12.gasUsed}`);

        let balanceContractAfterSend = await web3.eth.getBalance(contract.options.address);
        console.log("distributeur",balanceContractAfterSend);
        let balanceReceiveAfterSend = await web3.eth.getBalance(accounts[0]);
        console.log("compte client",balanceReceiveAfterSend);


       const tx1= await contract.methods.getMappingCustomer(accounts[0]).call();
        console.log(tx1);
        assert(tx1.Coca,5);

        const tx2= await contract.methods.getMappingRaw("Coca").call();
        console.log(`coca qty:${tx2.qty}`);
       assert(tx2.qty,7);
       
       const tx3= await contract.methods.getMappingRaw("Lion").call();
       console.log(`Lion qty:${tx3.qty}`);
      assert(tx3.qty,7);

      const tx4= await contract.methods.getMappingRaw("Mars").call();
      console.log(`Mars qty:${tx4.qty}`);
     assert(tx4.qty,7);

     const tx5= await contract.methods.costItem("Mars",2).call();
     console.log(`Mars price:${tx5.qty}`);
     assert(tx5,4);

     const tx6= await contract.methods.getMappingCustomer(accounts[0]).call();
     console.log(`User exist:${tx6.exist}`);
     assert(tx6.exist,true);

  
    })
    mocha.it('Get Customer Basket init', async () => {
        const tx1= await contract.methods.getMappingCustomer(accounts[0]).call();
        console.log(`nb Coca init:${tx1.qty}`);
        assert(tx1.Coca,0)
       
    });
    mocha.it('Get distributor items init', async () => {
        const tx= await contract.methods.payItem("Coca",5).send({from:accounts[0], gas: 3000000,value:5});
        console.log(tx);
        console.log(`Message: ${tx.gasUsed}`);
        const tx8= await contract.methods.getMappingRaw("Coca").call();
        console.log(`Nb Coca After recharge:${tx8.qty}`);
        assert(tx8.qty,10);
     
   

    });


   
});
