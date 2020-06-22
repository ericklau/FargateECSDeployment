import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  render() {
    var ip = require("ip");
    console.log( ip.address() );
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React</h1>
        </header>
        <p className="App-intro">
          hello from {window.location.hostname} at {window.location.port}
        </p>
      </div>
    );
  }
}

export default App;
