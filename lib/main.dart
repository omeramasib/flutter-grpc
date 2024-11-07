import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart' as grpc;

import 'proto/service.pbgrpc.dart';

class GrpcClient {
  late final grpc.ClientChannel channel;
  late final GreeterClient stub;

  GrpcClient() {
    channel = grpc.ClientChannel(
      //10.10.100.124
      '10.10.100.124', 
      port: 50051,
      options: const grpc.ChannelOptions(credentials: grpc.ChannelCredentials.insecure()),
    );
    stub = GreeterClient(channel);
  }

  Future<String> sayHello(String name) async {
    final request = HelloRequest()..name = name;
    try {
      final response = await stub.sayHello(request);
      return response.message;
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<void> shutdown() async {
    await channel.shutdown();
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final client = GrpcClient();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('gRPC with Flutter')),
        body: Center(
          child: FutureBuilder<String>(
            future: client.sayHello("Omer"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data ?? "No response");
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:grpc/grpc.dart';

// import 'proto/service.pbgrpc.dart';


// class GrpcClient {
//   ClientChannel channel;
//   GreeterClient stub;

//   GrpcClient()
//       : channel = ClientChannel(
//           'http://127.0.0.1:8000', // Use your server IP here
//           port: 50051,
//           options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
//         ),
//         stub = GreeterClient(channel);

//   Future<String> sayHello(String name) async {
//     final request = HelloRequest()..name = name;
//     try {
//       final response = await stub.sayHello(request);
//       return response.message;
//     } catch (e) {
//       return 'Error: $e';
//     }
//   }

//   Future<void> shutdown() async {
//     await channel.shutdown();
//   }
// }

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   final client = GrpcClient();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('gRPC with Flutter')),
//         body: Center(
//           child: FutureBuilder<String>(
//             future: client.sayHello("Omer"),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return Text(snapshot.data ?? "No response");
//               } else {
//                 return CircularProgressIndicator();
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }