class TypesHelper {
  static int toInt(dynamic val) {
    try {
      if (val == null) {
        return 0;
      }
      if ( val is int) {
        return val;
      }else {
        return val.toInt();
      }

    }catch(error) {
      print(error);
      return 0;
    }
  }
  static double toDouble(dynamic val) {
    try {
      if (val == null) {
        return 0;
      }
      if (val is double) {
        return val;
      }else {
        return val.toDouble();
      }

    }catch(error) {
      print(error);
      return 0;
    }
  }
  static String toStr(dynamic val) {
    try {
      if (val == null) {
        return "";
      }
      if (val is String) {
        return val;
      }else {
        return val.toString();
      }

    }catch(error) {
      print(error);
      return "";
    }
  }
}