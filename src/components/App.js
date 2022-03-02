import React, { Component } from 'react';
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from "../abis/KryptoBird.json";
import "./App.css"

class App extends Component {
  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  //detect eth provider
  async loadWeb3() {
    const provider = await detectEthereumProvider();

    if(provider) {
      console.log("eth wallet is connected")
      window.web3 = new Web3(provider)
    } else {
      console.log("no ethereum wallet detected")
    }

  }

  async loadBlockchainData() {
    const web3 = window.web3
    const accounts = await web3.eth.getAccounts();
    this.setState({account:accounts[0]})
    console.log(this.state.account)

    //create a constant js networkId which is set to the blockchain network Id
    const networkId = await web3.eth.net.getId();
    const networkData = KryptoBird.networks[networkId]
    if(networkData) {
      const abi = KryptoBird.abi
      const address = networkData.address
      let contract = new web3.eth.Contract(abi, address)

      this.setState({contract: contract})
      //getting the total supply from the KryptoBird contract
      let totalSupply = await contract.methods.totalSupply().call();
      this.setState({totalSupply})
      for(let i = 0; i < totalSupply; i++) {
        const KryptoBird = await contract.methods.kryptoBirdz(i).call()
        this.setState({
          kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]
        })
      }
    } else {
      window.alert("Smart contract not deployed")
    }
  }

  //creating the mint function from the contract in the state and we fire the function only once

  mint = (KryptoBird) => {
    this.state.contract.methods.mint(KryptoBird).send({from: this.state.account})
    .once('receipt', (receipt) => {
      this.setState({
        kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]
      })
    })
  }

  constructor(props) {
    super(props);
    this.state = {
      account: "",
      contract: "",
      totalSupply: 0,
      kryptoBirdz: [],
    }
  }

  render() {
    return (
      <div>
        <h1>NFT MARKETPLACE</h1>
        <p>{this.state.account}</p>

        <form onSubmit={(e) =>{
          e.preventDefault();
          const kryptoBird = this.kryptoBird.value
          this.mint(kryptoBird)
        }}>
            <input 
              type="text" 
              placeholder='Add file url' 
              ref={(input) => this.kryptoBird = input}
            />
            <input type='submit' value="MINT"/>
        </form>

        {/* Display NFTs */}
        {this.state.kryptoBirdz.map((NFT, index) => {
          return(
            <div key={index}>
              <img className="image" style={{height: 200, width: 150}} src={NFT}/>
            </div>
            )
        })}
      </div>
    )
  }
}

export default App; 
