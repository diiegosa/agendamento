import React from 'react';

export default class Warning extends React.Component {

    constructor(props) {
        super(props)
        this.state = {}
    }

    render() {
        return (
            <div className="alert alert-warning alert-dismissible">
                <h4><i className="icon fa fa-exclamation-triangle"></i> Alerta</h4>
                <div id="error_explanation">
                    <ul><li>{this.props.message}</li></ul>
                </div>
            </div>
        );
    }
}
