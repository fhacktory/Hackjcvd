  final byte MACOSX = 0;
  final byte WINDOWS = 1;
  final byte LINUX = 2;
  final byte OTHER = 3;

class Tools {

  byte getOS() {
    String platformName = System.getProperty("os.name");
    platformName = platformName.toLowerCase();
    if (platformName.indexOf("mac") != -1) {
      return MACOSX;
    } else if (platformName.indexOf("windows") != -1) {
      return WINDOWS;
    } else if (platformName.indexOf("linux") != -1) { // true for the ibm vm
      return LINUX;
    } else {
      return OTHER;
    }
  }
}
