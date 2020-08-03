import React from 'react';
import ReactDOM from 'react-dom';

export default class Modal extends React.Component {

    constructor(props) {
        super(props)
        this.state = {
            title: '',
            modal_header_className: ''
        }
    }

    componentWillReceiveProps(nextProps) {
        switch (nextProps.type) {
            case 'warning':
                this.setState({ title: 'Atenção', modal_header_className: 'alert-warning' });
                break;
            case 'error':
                this.setState({ title: 'Erro', modal_header_className: 'alert-danger' });
                break;
            case 'success':
                this.setState({ title: 'Sucesso', modal_header_className: 'alert-success' });
                break;
            default:
                this.setState({ title: 'Algo inesperado aconteceu', modal_header_className: 'alert-warning' });
        }
    }

    render() {
        return (
            <div className="modal fade" id={this.props.id} tabIndex="-1" role="dialog" aria-labelledby={this.props.id+"Label"} aria-hidden="true">
                <div className="modal-dialog" role="document">
                    <div className="modal-content">
                        <div className={"modal-header " + this.state.modal_header_className}>
                            <h5 className="modal-title" id={this.props.id+"Label"}>{this.state.title}</h5>
                        </div>
                        <div className="modal-body">
                            {this.props.message}
                        </div>
                        <div className="modal-footer">
                            <button type="button" className="btn btn-secondary" data-dismiss="modal">&times;</button>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}
