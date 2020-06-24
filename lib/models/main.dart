 
import 'package:scoped_model/scoped_model.dart';
import './connectedmodel.dart'; 

class MainModel extends Model with ConnectedModel, UserModel,WatervalModel, UtilityModel {
}
