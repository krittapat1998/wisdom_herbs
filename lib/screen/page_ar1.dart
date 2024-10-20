// import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
// import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
// import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin/datatypes/node_types.dart';
// import 'package:ar_flutter_plugin/models/ar_node.dart';
// import 'package:ar_flutter_plugin/models/ar_hittest_result.dart'; // For handling hit test results
// import 'package:vector_math/vector_math_64.dart';
// import 'dart:async'; // For using Timer

// class PageAR1 extends StatefulWidget {
//   PageAR1({Key? key}) : super(key: key);

//   @override
//   _PageAR1State createState() => _PageAR1State();
// }

// class _PageAR1State extends State<PageAR1> {
//   ARSessionManager? arSessionManager;
//   ARObjectManager? arObjectManager;
//   ARAnchorManager? arAnchorManager;
//   ARNode? localObjectNode;
//   Timer? rotationTimer;
//   double _rotationAngle = 0.0; // Track rotation angle

//   @override
//   void dispose() {
//     rotationTimer?.cancel(); // Cancel the timer when the widget is disposed
//     arSessionManager?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AR Object with Auto Rotation'),
//       ),
//       body: Stack(
//         children: [
//           ARView(
//             onARViewCreated: onARViewCreated,
//             planeDetectionConfig: PlaneDetectionConfig
//                 .horizontalAndVertical, // Detect both horizontal and vertical planes
//           ),
//         ],
//       ),
//     );
//   }

//   void onARViewCreated(
//       ARSessionManager arSessionManager,
//       ARObjectManager arObjectManager,
//       ARAnchorManager arAnchorManager,
//       ARLocationManager arLocationManager) {
//     this.arSessionManager = arSessionManager;
//     this.arObjectManager = arObjectManager;
//     this.arAnchorManager = arAnchorManager;

//     this.arSessionManager?.onInitialize(
//           showFeaturePoints: false,
//           showPlanes: true, // Enable plane detection
//           customPlaneTexturePath:
//               null, // You can add a custom texture for detected planes
//           showWorldOrigin: false, // Hide world origin (axes)
//           handleTaps: true, // Enable tap handling
//         );

//     this.arObjectManager?.onInitialize();
//     this.arSessionManager?.onPlaneOrPointTap =
//         onPlaneTapped; // Handle taps on detected planes
//   }

//   // Called when the user taps on a detected plane
//   Future<void> onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
//     if (hitTestResults.isNotEmpty) {
//       var hit = hitTestResults.firstWhere(
//         (result) => result.type == ARHitTestResultType.plane,
//         orElse: () => hitTestResults.first,
//       );

//       if (localObjectNode != null) {
//         await arObjectManager?.removeNode(localObjectNode!);
//         localObjectNode = null;
//         rotationTimer?.cancel(); // Stop rotating the old object
//       }

//       // Create and add a new ARNode (3D model) on the tapped plane
//       var newNode = ARNode(
//         type: NodeType.localGLTF2,
//         uri: "assets/images/AR/Galangal.gltf", // Path to the 3D model
//         scale: Vector3(0.5, 0.5, 0.5),
//         position: hit.worldTransform
//             .getTranslation(), // Position based on the plane tap
//         rotation: Vector4(0.0, 1.0, 0.0, 0.0), // Initial rotation (optional)
//       );

//       bool? didAddNode = await arObjectManager?.addNode(newNode);
//       if (didAddNode == true) {
//         localObjectNode = newNode;
//         _startAutoRotation(); // Start rotating the object automatically
//         debugPrint("Object placed on plane and started rotating.");
//       } else {
//         debugPrint("Failed to place object on plane.");
//       }
//     }
//   }

//   // Automatically rotate the AR object over time
//   void _startAutoRotation() {
//     rotationTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
//       _rotationAngle += 0.01; // Incrementally rotate the object
//       if (localObjectNode != null) {
//         final Quaternion quaternion =
//             Quaternion.axisAngle(Vector3(0.0, 1.0, 0.0), _rotationAngle);
//         localObjectNode!.rotationFromQuaternion = quaternion;
//         debugPrint("Object rotated to $_rotationAngle radians.");
//       }
//     });
//   }
// }
