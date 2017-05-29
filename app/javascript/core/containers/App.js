import React, { Component } from 'react';
import { render } from 'react-dom';
import Home from '../components/Home';
import Releases from '../components/Releases';
import Merch from '../components/Merch';
import Videos from '../components/Videos';
import {
  BrowserRouter as Router,
  Route,
  Link
} from 'react-router-dom'

class App extends Component {
  render() {
    return(
      <Router>
        <div>
          <ul>
            <li><Link to='/' >Home</Link></li>
            <li><Link to='/releases' >Releases</Link></li>
            <li><Link to='/videos' >Videos</Link></li>
            <li><Link to='/merch' >Merch</Link></li>
          </ul>

          <Route exact path="/" component={Home} />
          <Route path="/releases" component={Releases} />
          <Route path="/videos" component={Videos} />
          <Route path="/merch" component={Merch} />

        </div>
      </Router>
    )
  }
}

export default App
