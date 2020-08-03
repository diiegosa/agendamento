import React from 'react';
import ReactDOM from 'react-dom';
import Axios from 'axios';

export default class FormNew extends React.Component {

    constructor(props) {
        super(props)
        this.state = {
            service_points: [],
            services: []
        }
        this.getServicePoints = this.getServicePoints.bind(this);
        this.getServices = this.getServices.bind(this);
        this.getServicePoints();
    }

    getServicePoints() {
        let self = this;
        Axios.get('/all_service_points').then(function (response) {
            self.setState({ service_points: response.data.service_points });
        }).catch(function (error) {
            console.log(error);
        });
    }

    getServices(event) {
        let self = this;
        Axios.get('/' + event.target.value + '/get_services_without_expert_by_service_point').then(function (response) {
            self.setState({ services: response.data.services });
        }).catch(function (error) {
            console.log(error);
        });
    }

    render() {
        return (
                <div>
                    <div className="form-group">
                        <label className="col-sm-2 control-label">Ponto de Atendimento *</label>
                        <div className="col-sm-9">
                            <select className="form-control" name="availability[service_point]" onChange={this.getServices} required="required">
                                <option value="0">Selecionar ...</option>
                                {
                                    this.state.service_points.map( function (service_point) {
                                        return <option key={service_point.id} value={service_point.id}>{service_point.name}</option>
                                    })
                                }
                            </select>
                        </div>
                    </div>
                    <div className="form-group">
                        <label className="col-sm-2 control-label">Serviços *</label>
                        <div className="col-sm-9">
                            <select className="form-control" multiple="multiple" name="availability[service_ids][]" required="required">
                                {
                                    this.state.services.map(function (service) {
                                        return <option key={service.id} value={service.id}>{service.name}</option>
                                    })
                                }
                            </select>
                        </div>
                    </div>
                    <div className="form-group">
                        <label className="col-sm-2 control-label">Turno *</label>
                        <div className="col-sm-9">
                            <select className="form-control" multiple="multiple" name="availability[shift][]" required="required">
                                <option value="1">Manhã</option>
                                <option value="2">Tarde</option>
                            </select>
                        </div>
                    </div>
                    <div className="form-group">
                        <label className="col-sm-2 control-label">Datas *</label>
                        <div className="col-sm-9">
                            <div className="col-md-2">
                                <div className="form-group">
                                    <div className="input-group date" id="datetimepicker6">
                                        <input type="text" name="initial_date" className="form-control" placeholder="Inicial" required="required" />
                                        <span className="input-group-addon">
                                            <span className="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div className="col-md-1">
                                <p align="center">-</p>
                            </div>
                            <div className="col-md-2">
                                <div className="form-group">
                                    <div className="input-group date" id="datetimepicker7">
                                        <input type="text" name="final_date" className="form-control" placeholder="Final" required="required" />
                                        <span className="input-group-addon">
                                            <span className="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div className="col-md-7">
                                <div className="form-group">
                                    <label className="col-sm-3 control-label">Atendentes *</label>
                                    <div className="col-sm-9">
                                        <input type="number" name="attendant_number" className="form-control" required="required" placeholder="Quantidade" />
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
    ReactDOM.render(
        <FormNew />,
        document.getElementById('availability_form_new')
    )
})
