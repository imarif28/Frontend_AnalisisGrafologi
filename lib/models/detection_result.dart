class Detection {
  final String className;
  final double confidence;
  final List<double> box; // [x_min, y_min, x_max, y_max]

  Detection({
    required this.className,
    required this.confidence,
    required this.box,
  });

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      className: json['class_name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      box: (json['bounding_box'] as List).map((e) => (e as num).toDouble()).toList(),
    );
  }
}

class DetectionResult {
  final List<Detection> detections;
  final String narrative;
  final Map<String, double> allConfidences;

  DetectionResult({
    required this.detections,
    required this.narrative,
    required this.allConfidences,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    
    final detectionsList = data['detections'] as List;
    final List<Detection> detections = detectionsList
        .map((e) => Detection.fromJson(e as Map<String, dynamic>))
        .toList();
        
    final analysis = data['personality_analysis'] as Map<String, dynamic>;
    final narrative = analysis['narrative'] as String;
    
    final confsMap = data['all_confidences'] as Map<String, dynamic>? ?? {};
    final allConfidences = confsMap.map((key, value) => MapEntry(key, (value as num).toDouble()));

    return DetectionResult(
      detections: detections,
      narrative: narrative,
      allConfidences: allConfidences,
    );
  }
}
