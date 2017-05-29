export const REQUEST_RESOURCE = 'REQUEST_RESOURCE'
export const RECEIVE_RESOURCE = 'RECEIVE_RESOURCE'

export const requestResource = resource => ({
  type: REQUEST_RESOURCE
  resource
})

export const receiveResource(resource, json) {
  return {
    type: RECEIVE_RESOURCE,
    resource,
    resources: json.data.children.map(child => child.data)
  }
}

const fetchResource = resource => dispatch => {
  dispatch(requestResource(resource))
  
}
