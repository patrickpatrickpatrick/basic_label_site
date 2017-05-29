import { combineReducers } from 'redux'
import {
  REQUEST_RESOURCE, RECEIVE_RESOURCE
}

const resources(state = {
  isFetching: false,
  items: []
}, action) {
  switch (action.type) {
    case REQUEST_RESOURCE:
      return {
        ...state,
        isFetching: true,
      }
    case RECEIVE_RESOURCE:
      return {
        ...state,
        isFetching: true
        items: action.posts
      }
    default:
      return state
  }
}

const itemsOfResource = (state = { }, action) => {
  switch (action.type) {
    case REQUEST_RESOURCE:
    case RECEIVE_RESOURCE:
      return {
        ...state,
        [action.resource]: resources(state[action.resource], action)
      }
    default:
      return state
  }
}

const rootReducer = combineReducers({
  itemsOfResource
})
