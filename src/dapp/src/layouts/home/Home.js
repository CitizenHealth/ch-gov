import React, { Component } from 'react'
import { Tabs, TabLink, TabContent } from 'react-tabs-redux'
import { ContractData, ContractForm } from 'drizzle-react-components'
import logo from '../../ch-logo.png'

class Home extends Component {

  constructor(props, context) {
    super(props)
    console.log(context);
    const { web3 } = context.drizzle
    const { accounts } = props
    const Medex = context.drizzle.contracts.MedexToken
    this.state = {
      web3,
      data: {
        decimals: Medex.methods.decimals.cacheCall(),
        period: Medex.methods.currentPeriod.cacheCall(),
        balance: Medex.methods.balanceOf.cacheCall(accounts[0])
      }
    }
  }

  getBalance() {
    if (this.props.drizzleStatus.initialized) {
      if (this.state.data.decimals in this.props.MedexToken.decimals &&
          this.state.data.balance in this.props.MedexToken.balanceOf){
        var decimals =  this.props.MedexToken.decimals[this.state.data.decimals].value;
        var balance =  this.props.MedexToken.balanceOf[this.state.data.balance].value;
        return balance / Math.pow(10, decimals);
      }
    }
    return "...";
  }

  getDecimals() {
    if (this.props.drizzleStatus.initialized) {
      if (this.state.data.decimals in this.props.MedexToken.decimals){
        return this.props.MedexToken.decimals[this.state.data.decimals].value;
      }
    }
    return "...";
  }

  getPeriod() {
    if (this.props.drizzleStatus.initialized) {
      if (this.state.data.period in this.props.MedexToken.currentPeriod) {
        return this.props.MedexToken.currentPeriod[this.state.data.period].value;
      }
    }
    return "";
  }
  
  render() {
    console.log(this.state);
    console.log(this.props);

    return (
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1 header">
            <img src={logo} alt="drizzle-logo" />
            <h1>Citizen Health Governance Portal</h1>
            <p>Vote on Citizen Health Governance using Medex Tokens</p>
        <p><strong>Current Medex Balance</strong>: <ContractData contract="MedexToken" method="balanceOf" methodArgs={[this.props.accounts[0]]} /> </p>
        <br/>
        <Tabs className="tabs">
        <div className="tab-links">
            <TabLink to="tab1">Current Votes</TabLink>
            <TabLink to="tab2">Upcoming Votes</TabLink>
            <TabLink to="tab3">Previous Votes</TabLink>
        </div>
 <TabContent for="tab1">
          <div className="pure-u-1-1">
        <p>Current Period: {this.getPeriod()}</p>
            <p>Vote on the following issues</p>
            <br/><br/>
          </div>
</TabContent>

<TabContent for="tab2">
  <div className="pure-u-1-1">            
            <p>View upcoming votes and add proposals</p>
            <br/><br/>
          </div>
</TabContent>

<TabContent for="tab3">

          <div className="pure-u-1-1">
            <p>View the results of previous votes</p>
          </div>

</TabContent>        
        </Tabs>
          </div>       
        

        
        </div>
      </main>
    )
  }
}

export default Home
