import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

const MaterialColor Colors_of_the_app = const MaterialColor(
    0xFF4A148C,
    const <int, Color>{
      50: const Color(0xFF4A148C),
      100: const Color(0xFF4A148C),
      200: const Color(0xFF4A148C),
      300: const Color(0xFF4A148C),
      400: const Color(0xFF4A148C),
      500: const Color(0xFF4A148C),
      600: const Color(0xFF4A148C),
      700: const Color(0xFF4A148C),
      800: const Color(0xFF4A148C),
      900: const Color(0xFF4A148C),
    }
);

const MaterialColor body_background = const MaterialColor(
    0xFFFAFAFA,
    const <int, Color>{
      50: const Color(0xFFFAFAFA),
      100: const Color(0xFFFAFAFA),
      200: const Color(0xFFFAFAFA),
      300: const Color(0xFFFAFAFA),
      400: const Color(0xFFFAFAFA),
      500: const Color(0xFFFAFAFA),
      600: const Color(0xFFFAFAFA),
      700: const Color(0xFFFAFAFA),
      800: const Color(0xFFFAFAFA),
      900: const Color(0xFFFAFAFA),
    }
);


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Receive',
      debugShowCheckedModeBanner:false, //to remove the red debug banner
      home: MyHomePage(title: 'MQTT Receive'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //vars that use for communicat with MQTT broker
  String broker;
  int port;
  String port_string;
  String username;
  String passwd;
  String clientIdentifier;
  String topic_string;
  //JSon file read
  List settings_broker_data;
  Future<String> loadJsonData() async{
    var data_from_Json_as_string= await rootBundle.loadString('assets/broker_info.json');
    Map<String, dynamic> data_from_Json = jsonDecode(data_from_Json_as_string);
    //print('broker_ip is, ${user['broker_ip']}!');
    broker           = data_from_Json['broker_ip'];
    port_string=data_from_Json['port'];
    port                = int.parse(data_from_Json['port']); //just convert here from string to int
    username         = data_from_Json['username'];
    passwd           = data_from_Json['passwd'];
    clientIdentifier = data_from_Json['clientIdentifier'];
    topic_string = data_from_Json['topic'];

  }

@override
void initState(){
    this.loadJsonData();
}

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;

  double _temp = 20;

  StreamSubscription subscription;

  String message_display = 'non message';
  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic.trim()}');
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  //the app theme
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor:Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors_of_the_app,
        title: Text(widget.title),
      ),

      body: Center(  
        child: Text(message_display,style: TextStyle(color: Colors.white,fontSize: 40),),//this print the messegers
        ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors_of_the_app,
        onPressed: _connect,
        tooltip: 'Play',
        child: Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(), // this line to fix Notch for Docked FloatingActionButton Missing in BottomAppBar
                                        //found it in https://stackoverflow.com/questions/51251722/notch-for-docked-floatingactionbutton-missing-in-bottomappbar
      elevation: 5.0,
      color: body_background,
      child: new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          IconButton(
            color: Colors.black54,
            icon: Icon(Icons.menu),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    title: new Text("broker settings"),
                    content: new Text("current settings: \n "+
                    "broker ip/server:"+
                    broker+
                    " \n "+
                    "port:"+
                    port_string+
                    " \n "+
                    " username: "+
                    username+
                    " \n "+
                    "Password: "+
                    passwd+
                    " \n "+
                    "clientIdentifier: "+
                    clientIdentifier+
                    " \n "+
                    "topic: "+
                    topic_string),
                  
                  actions: <Widget>[
                    FlatButton(
                     child: Text('change the settings',textAlign: TextAlign.center,),
                     onPressed: () {},
                    ),],




                  )
              );
            },
          ),
          IconButton(color: Colors.black54,icon: Icon(Icons.info), onPressed: () {
            showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  title: new Text("About",textAlign: TextAlign.center,),
                  content:new Text("open source MQTT Receive application"+
                   " \n "+
                   "for test the reveive from topic"+ 
                   "\n"+
                   "developed by Walid Amriou"+ 
                   "\n"+
                   "www.walidamriou.com"+ 
                   "\n"+
                   "github.com/walidamriou"+ 
                   "\n",style: TextStyle(color: Colors.black54,fontSize: 16),textAlign: TextAlign.center,),
                )
            );
          },
          ),
        ],
      ),
    ),
    );
  }

  void _connect() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    ///
    client = mqtt.MqttClient(broker, '');
    client.port = port;

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    /// client.useWebSocket = true;
    /// client.port = 80;  ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

    /// Set logging on if needed, defaults to off
    client.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.

    try {
      await client.connect(username, passwd);
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState = client.connectionState;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client.updates.listen(_onMessage);

    _subscribeToTopic(topic_string);
  }

  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      connectionState = client.connectionState;
      client = null;
      subscription.cancel();
      subscription = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
    event[0].payload as mqtt.MqttPublishMessage;
    final String message = mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    message_display = message;
    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: ${message}");
    setState(() {
      _temp = double.parse(message);
    });
  }
}


Future<String> _asyncInputDialog(BuildContext context) async {
  String teamName = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter current team'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Team Name', hintText: 'eg. Juventus F.C.'),
                  onChanged: (value) {
                    teamName = value;
                  },
                ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(teamName);
            },
          ),
        ],
      );
    },
  );
}

