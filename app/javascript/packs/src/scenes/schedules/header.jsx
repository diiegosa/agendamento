import React from 'react';
import ReactDOM from 'react-dom';

export default class Header extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }

    render() {
        return (
            <div className="box box-widget widget-user">
                <div className="widget-user-header bg-black" style={{backgroundImage: 'url('+'/cbmpe_bg_images/4.jpg'+')', backgroundRepeat:'no-repeat', backgroundPosition: 'center center'}}>
                    <h3 className="widget-user-username"><b>Corpo de Bombeiros Militar de Pernambuco</b></h3>
                    <h4 className="widget-user-desc"><b>Agendamento Eletrônico</b></h4>
                </div>
                <div className="widget-user-image">
                    <img alt="Logo CBMPE" className="img-circle" src="/assets/logo_cbmpe.png" />
                </div>
                <div className="box-footer">
                        <div className="pull-left">
                            <a className="btn btn-lg btn-primary" href="/" role="button">
                                <i className="fa fa-home"></i> &nbsp;
                                Agendamento

                            </a>
                        </div>
                        <div className="pull-right">
                            <a className="btn btn-lg btn-primary" href="/schedules/search" role="button">
                                <i className="fa fa-search"></i> &nbsp;
                                Consultar <small>ou</small> cancelar atendimento
                            </a>
                        </div>

                </div>
            </div>
        );
    }
}

document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
        <Header />,
        document.getElementById('schedules_header')
    )
})
