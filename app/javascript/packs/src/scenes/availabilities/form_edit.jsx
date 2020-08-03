import React from 'react';
import ReactDOM from 'react-dom';
import Axios from 'axios';

export default class FormEdit extends React.Component {

    constructor(props) {
        super(props)
        this.state = {
            service_points: [],
            services: []
        }
        this.getServicePoints();
        this.getServicesInit();
    }

    getServicePoints = () => {
        let self = this;
        Axios.get('/all_service_points').then(function (response) {
            self.setState({ service_points: response.data.service_points });
        }).catch(function (error) {
            console.log(error);
        });
    }

    getServicesInit = () => {
        this.getServices(this.props.availability.service_point_id);
    }

    getServicesOnChange = (event) => {
        this.getServices(event.target.value);
    }

    getServices = (service_point_id) => {
        let self = this;
        Axios.get('/' + service_point_id + '/get_services_without_expert_by_service_point').then(function (response) {
            self.setState({ services: response.data.services });
        }).catch(function (error) {
            console.log(error);
        });
    }

    getDate = () => {
        return new Date(this.props.availability.date + ' 00:00').toLocaleDateString();
    }

    optionsToSelectMount(object, valueSelected, callback) {
        return Object.keys(object).map(function (key) {
            object[key].selected = object[key].id == valueSelected
            return callback(key, object[key]);
        });
    }

    render() {
        return (
            <div>
                <div className="form-group">
                    <label className="col-sm-2 control-label">Ponto de Atendimento *</label>
                    <div className="col-sm-9">
                        <select className="form-control" name="availability[service_point_id]" onChange={(event)=>this.getServicesOnChange(event)} required="required">
                            {
                                this.optionsToSelectMount(this.state.service_points, this.props.availability.service_point_id, function (key, service_point) {
                                    return <option key={key} value={service_point.id} selected={service_point.selected}>{service_point.name}</option>
                                })
                            }
                        </select>
                    </div>
                </div>
                <div className="form-group">
                    <label className="col-sm-2 control-label">Serviços *</label>
                    <div className="col-sm-9">
                        <select className="form-control" defaultValue={this.props.availability.service_id} name="availability[service_id]" required="required">
                            {
                                this.optionsToSelectMount(this.state.services, this.props.availability.service_id, function (key, service) {
                                    return <option key={key} value={service.id} selected={service.selected}>{service.name}</option>
                                })
                            }
                        </select>
                    </div>
                </div>
                <div className="form-group">
                    <label className="col-sm-2 control-label">Turno *</label>
                    <div className="col-sm-9">
                        <select className="form-control" defaultValue={this.props.availability.shift} name="availability[shift]" required="required">
                            <option value="1">Manhã</option>
                            <option value="2">Tarde</option>
                        </select>
                    </div>
                </div>
                <div className="form-group">
                    <label className="col-sm-2 control-label">Data *</label>
                    <div className="col-sm-9">
                        <div className="col-md-6">
                            <div className="form-group">
                                <div className="input-group date" id="datetimepicker6">
                                    <input type="text" name="availability[date]" defaultValue={this.getDate()} className="form-control" placeholder="Inicial" required="required" />
                                    <span className="input-group-addon">
                                        <span className="glyphicon glyphicon-calendar"></span>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div className="col-md-6">
                            <div className="form-group">
                                <label className="col-sm-3 control-label">Atendentes *</label>
                                <div className="col-sm-9">
                                    <input type="number" defaultValue={this.props.availability.attendant_number} name="availability[attendant_number]" className="form-control" required="required" placeholder="Quantidade" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const node = document.getElementById('availability_form_edit_node')
    ReactDOM.render(
        <FormEdit availability={JSON.parse(node.getAttribute('data'))} />,
        document.getElementById('availability_form_edit')
    )
})
