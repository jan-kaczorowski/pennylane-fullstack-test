import PropTypes from 'prop-types'
import React, { useState } from 'react'

const Hello = props => (
  <>
    <div>Hello {props.name}!</div>
    <input type='text' name="typeahead"/>
  </>

)

Hello.defaultProps = {
  name: 'David'
}

Hello.propTypes = {
  name: PropTypes.string
}

export default Hello;