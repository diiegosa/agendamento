import React from 'react';
import ReactDOM from 'react-dom';
import Axios from 'axios';
import MaskedInput from 'react-text-mask'

export default class New extends React.Component {
    static colorServiceButton = { warning: 'warning', default: 'default' };
    static expert_or_service_point_init = { title: 'Aguardando escolha do serviço', value: [], field_name: '' };
    constructor(props) {
        super(props)
        this.state = {
            services: [],
            service_points: [],
            experts: [],
            dates: [],
            times: [],
            expert_or_service_point: New.expert_or_service_point_init,
            selected_service: { id: null, name: null }
        }
        this.getServicesThatHaveServicePoint()
        $('.phone_with_ddd').mask('(00) 00000-0000');
        $('.cpf').mask('000.000.000-00', { reverse: false });
    }

    getServicesThatHaveServicePoint = () => {
        Axios.get('/all_services_that_have_service_point').then((response) => {
            response.data.services.forEach((service) => { service['buttonColor'] = New.colorServiceButton.warning });
            this.setState({ services: response.data.services });
        }).catch(error => {
            console.log(error);
        });
    }

    getServicePointsAndExpertsThatHaveAvailabilityByService = (serviceId) => {
        let serviceName = null
        this.state.services.forEach((service) => {
            if (service['id'] != serviceId) {
                service['buttonColor'] = New.colorServiceButton.default
            } else {
                service['buttonColor'] = New.colorServiceButton.warning
                serviceName = service['name']
            }
        });
        this.setState({
            service_points: [], experts: [], dates: [], times: [],
            expert_or_service_point: New.expert_or_service_point_init
        });

        Axios.get('/' + serviceId + '/get_service_points_and_experts_that_have_availability_by_service').then(response => {
            this.setState({ service_points: response.data.service_points, experts: response.data.experts, selected_service: { id: serviceId, name: serviceName } });
            this.renderIfExperts();
        }).catch(error => {
            console.log(error);
        });
    }

    renderIfExperts = () => {
        let expert_or_service_point = this.isExperts() ? { title: 'Especialista', value: this.state.experts, field_name: 'expert_id' }
            : { title: 'Ponto de Atendimento', value: this.state.service_points, field_name: 'service_point_id' }
        this.setState({
            expert_or_service_point: expert_or_service_point
        })
    }

    isExperts() {
        return this.state.experts.length > 0
    }

    getAvailableDates = (event) => {
        this.setState({ dates: [], times: [] });
        let service_point_or_expert_id = event.target.value;
        let routeName = '/' + service_point_or_expert_id + '/' + this.state.selected_service.id + '/get_available_dates_by_service_point_and_service'
        if (this.isExperts()) routeName = '/' + service_point_or_expert_id + '/get_available_dates_by_expert'

        if (service_point_or_expert_id) {
            Axios.get(routeName).then(response => {
                this.setState({ dates: response.data.dates });
            }).catch(error => {
                console.log(error);
            });
        }
    }

    getAvailableTimesByDate = (event) => {
        this.setState({ times: [] });
        let availability_or_expert_availability_date = event.target.value;
        let routeName = '/get_available_times_by_date'
        if (this.isExperts()) routeName = '/get_expert_available_times_by_date'
        if (availability_or_expert_availability_date) {
            Axios.get('/' + availability_or_expert_availability_date + routeName).then(response => {
                this.setState({ times: response.data.times });
            }).catch(error => {
                console.log(error);
            });
        }
    }

    showForm = () => {
        return this.state.service_points.length > 0 || this.state.experts.length > 0
    }

    formatLocaleDate(object, callback) {
        return Object.keys(object).map(function (key) {
            object[key].localeDateFormat = new Date(object[key].date + ' 00:00').toLocaleDateString()
            return callback(key, object[key]);
        });
    }

    render() {
        return (
            <div>
                <div className="box box-danger">
                    <div className="box-header">
                        <h3>Escolha um serviço</h3>
                    </div>
                    <div className="box-body">
                        <div className="row">
                            {
                                this.state.services.map((service) => {
                                    return ([
                                        <div title={service.name} className="col-sm-4" key={service.id}>
                                            <a className={'btn btn-block btn-social btn-' + service.buttonColor} onClick={() => this.getServicePointsAndExpertsThatHaveAvailabilityByService(service.id)}>
                                                <i className={'fa ' + service.fa_icon }></i>{service.name}
                                            </a>
                                        </div>
                                    ])
                                })
                            }
                        </div>
                    </div>
                </div>

                {this.showForm() &&
                    <div className="jumbotron">
                        <div className="panel panel-default">
                            <div className="panel-body">
                                <div className="form-group col-md-6">
                                    <label htmlFor="service_name">Serviço*</label>
                                    <input id="service_id" name="schedule[service_id]" type="hidden" value={this.state.selected_service.id} />
                                    <div id="service_name" name="service_name">
                                        <span className="label label-warning" style={{ fontSize: 14 }}>{this.state.selected_service.name}</span>
                                    </div>
                                </div>
                                <div className="form-group col-md-6">
                                    <label htmlFor={this.state.expert_or_service_point.field_name}>{this.state.expert_or_service_point.title}*</label>
                                    <select className="form-control" name={"schedule[" + this.state.expert_or_service_point.field_name + "]"} disabled={!this.state.expert_or_service_point.value.length}
                                        onChange={this.getAvailableDates} required="required">
                                        <option value="">Selecionar...</option>
                                        {
                                            this.state.expert_or_service_point.value.map(function (service_point) {
                                                return <option key={service_point.id} value={service_point.id}>{service_point.name}</option>
                                            })
                                        }
                                    </select>
                                </div>
                                <div className="form-group col-md-6">
                                    <label htmlFor="date">Data*</label>
                                    <select className="form-control" name="schedule[date]" disabled={!this.state.dates.length}
                                        onChange={this.getAvailableTimesByDate} required="required">
                                        <option value="" id="0">Selecionar...</option>
                                        {
                                            this.formatLocaleDate(this.state.dates, function (key, availability) {
                                                return <option key={key} value={availability.date}>{availability.localeDateFormat}</option>
                                            })
                                        }
                                    </select>
                                </div>
                                <div className="form-group col-md-6">
                                    <label htmlFor="time">Horário*</label>
                                    <select className="form-control" name="schedule[time]" disabled={!this.state.times.length} required="required">
                                        <option value="">Selecionar...</option>
                                        {
                                            this.state.times.map(function (time) {
                                                return <option key={time} value={time}>{time}</option>
                                            })
                                        }
                                    </select>
                                </div>
                                <div className="form-group col-md-6">
                                    <label htmlFor="property_sequential_or_protocol">Sequencial do imóvel ou Protocolo*</label>
                                    <input defaultValue={this.props.schedule.property_sequential_or_protocol} className="form-control" placeholder="Digite o sequencial ou o protocolo" type="text" name="schedule[property_sequential_or_protocol]" id="property_sequential_or_protocol" required="required"></input>
                                </div>
                                <div className="form-group col-md-6">
                                    <label htmlFor="description">Descrição da solicitação (caso julgue necessário)</label>
                                    <textarea defaultValue={this.props.schedule.description} name="schedule[description]" className="form-control"></textarea>
                                </div>
                            </div>
                        </div>

                        <div className="panel panel-default">
                            <div className="panel-body">
                                <div className="form-group col-md-4">
                                    <label htmlFor="client_name">Nome*</label>
                                    <input defaultValue={this.props.schedule.client_name} className="form-control" placeholder="Digite seu nome" required="required" type="text" name="schedule[client_name]" id="schedule_client_name"></input>
                                </div>
                                <div className="form-group col-md-4">
                                    <label htmlFor="schedule_client_cpf">CPF*</label>
                                    <MaskedInput
                                        mask={[/\d/, /\d/, /\d/, '.', /\d/, /\d/, /\d/, '.', /\d/, /\d/, /\d/, '-', /\d/, /\d/]}
                                        className="form-control"
                                        placeholder="Digite seu CPF (só números)"
                                        required="required"
                                        id="schedule_client_cpf"
                                        name="schedule[client_cpf]"
                                        type="text"
                                        defaultValue={this.props.schedule.client_cpf}
                                    />
                                </div>
                                <div className="form-group col-md-4">
                                    <label htmlFor="schedule_client_cellphone_number">Celular*</label>
                                    <MaskedInput
                                        mask={['(', /\d/, /\d/, ')', ' ', /\d/, /\d/, /\d/, /\d/, /\d/, '-', /\d/, /\d/, /\d/, /\d/]}
                                        className="form-control"
                                        placeholder="(00) 00000-0000"
                                        required="required"
                                        id="schedule_client_cellphone_number"
                                        name="schedule[client_cellphone_number]"
                                        type="text"
                                        defaultValue={this.props.schedule.client_cellphone_number}
                                    />
                                </div>
                                <div className="form-group col-md-6">
                                    <label htmlFor="client_email">Email*</label>
                                    <input defaultValue={this.props.schedule.client_email} className="form-control" placeholder="Digite seu email" required="required" type="email" name="schedule[client_email]" id="schedule_client_email"></input>
                                    
                                </div>
                                <div className="form-group col-md-6">
                                    <label htmlFor="client_email_confirmation">Confirme seu email*</label>
                                    <input className="form-control" placeholder="Confirme seu email" required="required" type="email" name="schedule[client_email_confirmation]" id="client_email_confirmation"></input>
                                </div>
                            </div>
                        </div>

                        <div className="panel panel-default">
                            <div className="panel-body">
                                <span className="label label-info pull-left" style={{ fontSize: 16 }}>*AS INFORMAÇÕES SOBRE O AGENDAMENTO SERÃO ENVIADAS PARA O EMAIL CADASTRADO ACIMA.</span>
                                <button type="submit" className="btn btn-primary pull-right">AGENDAR</button>
                            </div>
                        </div>
                    </div>
                }
            </div>
        );
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const node = document.getElementById('schedules_new_id')
    ReactDOM.render(
        <New schedule={JSON.parse(node.getAttribute('data'))} />,
        document.getElementById('schedules_new')
    )
})
