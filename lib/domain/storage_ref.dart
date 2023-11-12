const localPath = '/';

enum StorageType {
  local;

  static StorageType fromJson(String? value) {
    if (value == 'local') {
      return StorageType.local;
    } else {
      return StorageType.local; // Default value
    }
  }

  String toJson() {
    switch (this) {
      case StorageType.local:
        return 'local';
    }
  }
}

class StorageRef {
  final String path;
  final StorageType type;

  StorageRef({required this.path, required this.type});

  StorageRef.fromJson(Map<String, dynamic> json)
      : path = json['path'] ?? localPath,
        type = StorageType.fromJson(json['type']);

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': type.toJson(),
    };
  }
}
