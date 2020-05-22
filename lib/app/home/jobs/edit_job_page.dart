import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job}) : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context,listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobPage(database: database,job: job,),
      fullscreenDialog: true,
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;

  @override
  void initState(){
    super.initState();
    if (widget.job != null){
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async{
    if (_validateAndSaveForm()){
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((e) => e.name).toList();
        if (allNames.contains(_name)){
          PlatformAlertDialog(title: 'Name already used!', content: "Please choose a different job name",defaultActionText: 'OK',).show(context);
        }else{
          final job = Job(name: _name, ratePerHour: _ratePerHour);
          await widget.database.createJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(title: "Operation Failed", exception: e).show(context);
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? "New Job": "Edit Job"),
        actions: <Widget>[
          FlatButton(
              onPressed: _submit,
              child: Text('Save',
                  style: TextStyle(fontSize: 18.0, color: Colors.white)))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
      key: _formKey,
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Job name'),
        validator: (value)=> value.isNotEmpty ? null : "Name can\'t be empty",
        onSaved: (value)=> _name=value,
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? '$_ratePerHour': null,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        onSaved: (value)=> _ratePerHour=int.tryParse(value) ?? 0,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
      ),
    ];
  }
}