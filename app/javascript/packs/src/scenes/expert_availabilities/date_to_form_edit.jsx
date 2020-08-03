import React from 'react';
import ReactDOM from 'react-dom';

export default class DateToFormEdit extends React.Component {

    constructor(props) {
        super(props)
        this.state = {}
    }

    getDate = () => {
        return new Date(this.props.date + ' 00:00').toLocaleDateString();
    }

    render() {
        return (
            <div className="form-group">
                <label className="col-sm-2 control-label">Data *</label>
                <div className="col-sm-9">
                    <div className="input-group date" id="datetimepicker6">
                        <input type="text" name="expert_availability[date]" defaultValue={this.getDate()} className="form-control" placeholder="Data" required="required" />
                        <span className="input-group-addon">
                            <span className="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>
            </div>
        );
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const node = document.getElementById('expert_availability_date_to_form_edit_node')
    ReactDOM.render(
        <DateToFormEdit date={JSON.parse(node.getAttribute('data'))} />,
        document.getElementById('expert_availability_date_to_form_edit')
    )
})
