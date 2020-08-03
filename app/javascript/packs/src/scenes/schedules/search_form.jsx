import React from 'react';
import ReactDOM from 'react-dom';
import Axios from 'axios';
import Warning from '../../components/alerts/warning';
import Modal from '../../components/modal';

export default class SearchForm extends React.Component {

    constructor(props) {
        super(props)
        this.state = {
            clientEmail: '',
            schedules: { list: [], error: null },
            modal: { type: '', message: '' },
        }

        this.isRender = {
            errorEmailMessage: () => {
                return this.state.schedules.error != null
            },
            table: () => {
                return this.state.schedules.list.length > 0
            }
        }

    }

    handleClientEmailInputChange = (event) => {
        this.setState({ clientEmail: event.target.value });
    };

    getSchedulesByEmail = () => {
        Axios.post('/get_schedules_by_email', { client_email: this.state.clientEmail }).then(response => {
            this.setState({ schedules: response.data.schedules });
        }).catch(error => {
            console.log('Error: ', error);
        });
    }

    scheduleCancel = (schedule_id) => {
        let scheduleProtocol = $('#schedule_protocol_' + schedule_id + '_id').val();
        if (scheduleProtocol) {
            Axios.post('/schedule_cancel', { schedule_protocol: scheduleProtocol, schedule_id: schedule_id }).then(response => {
                this.getSchedulesByEmail();
                this.showModal(response.data.message);
            }).catch(error => {
                console.log('Error: ', error);
            });
        }
    }

    showModal = (message) => {
        this.setState({ modal: { type: Object.keys(message)[0], message: Object.values(message)[0] }});
        $('#modalId').modal('show');
    }

    handleEmailSubmit = (e) => {
        e.preventDefault();
        this.getSchedulesByEmail();
    }

    handleScheduleCancelSubmit = (e) => {
        e.preventDefault();
    }

    sendEmail = (schedule_id) => {
        Axios.post('/send_schedule_information_by_email', { schedule_id: schedule_id }).then(response => {
            this.showModal(response.data.message);
        }).catch(error => {
            console.log('Error: ', error);
        });
    }

    render() {
        return (
            <div>
                <div id="modalDiv">
                    <Modal id="modalId"
                        type={this.state.modal.type}
                        message={this.state.modal.message}
                    />
                </div>
                {this.isRender.errorEmailMessage() && <Warning message={this.state.schedules.error} />}
                <div className="box box-danger">
                    <div className="box-body">
                        <form onSubmit={this.handleEmailSubmit}>
                            <div className="form-group col-md-5">
                                <label htmlFor="client_email">Informe o email utilizado no agendamento</label>
                                <div className="input-group">
                                    <input type="email" className="form-control" name="client_email" onChange={this.handleClientEmailInputChange} required="required"></input>
                                    <span className="input-group-btn">
                                        <button className="btn btn-primary btn-flat">Consultar!</button>
                                    </span>
                                </div>
                            </div>
                            <div className="form-group col-md-7">
                                <div className="alert alert-danger" role="alert">
                                    <h4 className="alert-heading">Deseja cancelar o agendamento?</h4>
                                    <p>Consulte seus agendamentos. No agendamento que deseja cancelar digite o número do agendamento que você recebeu por email e clique em 'Cancelar'.</p>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                {this.isRender.table() &&
                    <div className="jumbotron">
                        <div className="panel panel-default">
                            <div className="panel-body">
                                <table className="table table-hover">
                                    <tbody>
                                        <tr>
                                            <th>Nome</th>
                                            <th>Serviço</th>
                                            <th>Local</th>
                                            <th>Data/Hora</th>
                                            <th>Receber informações no email</th>
                                            <th>Cancelar agendamento</th>
                                        </tr>
                                        {
                                            this.state.schedules.list.map(function (schedule, key) {
                                                return ([
                                                    <tr key={key}>
                                                        <td>{schedule.client_name}</td>
                                                        <td>{schedule.service_name}</td>
                                                        <td>{schedule.local}</td>
                                                        <td>{schedule.datetime}</td>
                                                        <td><button onClick={() => this.sendEmail(schedule.id)} className="btn btn-info btn-flat">Receber informações!</button></td>
                                                        <td>
                                                            <form onSubmit={this.handleScheduleCancelSubmit}>
                                                                <div className="input-group">
                                                                    <input type="text" className="form-control" placeholder="Nº do agendamento" id={"schedule_protocol_" + schedule.id + "_id"} name={"schedule_protocol_" + schedule.id + "_name"} required="required"></input>
                                                                    <span className="input-group-btn">
                                                                        <button onClick={() => this.scheduleCancel(schedule.id)} className="btn btn-danger btn-flat">Cancelar agendamento!</button>
                                                                    </span>
                                                                </div>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                ])
                                            }, this)
                                        }
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                }


            </div>
        );
    }
}

document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
        <SearchForm />,
        document.getElementById('schedules_search_form')
    )
})
