
class MoneyUtility{
  static String numberToString(String number) {
    String sNumber = number.toString();
    // Tao mot bien tra ve
    String sReturn = "";
    // Tim chieu dai cua chuoi
    int iLen = sNumber.length;
    // Lat nguoc chuoi nay lai
    String sNumber1 = "";
    for (int i = iLen - 1; i >= 0; i--) {
      //sNumber1 += sNumber.charAt(i);
      sNumber1 += sNumber[i];
    }
    // Tao mot vong lap de doc so
    // Tao mot bien nho vi tri cua sNumber
    int iRe = 0;
    do {
      // Tao mot bien cat tam
      String sCut = "";
      if (iLen > 3) {
        sCut = sNumber1.substring((iRe * 3), (iRe * 3) + 3);
        sReturn = Read(sCut, iRe) + sReturn;
        iRe++;
        iLen -= 3;
      } else {
        sCut = sNumber1.substring((iRe * 3), (iRe * 3) + iLen);
        sReturn = Read(sCut, iRe) + sReturn;
        break;
      }
    } while (true);
    if(sReturn.length > 1){
      sReturn = sReturn.substring(0,1).toUpperCase() + sReturn.substring(1);
    }
    //sReturn = sReturn + "đồng";

    // xu ly lan cuoi voi 220 000 tỷ 000 000 000 000 000 HUTTV ADDED 3 OCT
    if(sNumber.length>12)
    {
      // tren gia tri can xu ly, kiem tra xem don vi TY co = 000 khong
      int begin = sNumber.length-9;
      String donviTy = sNumber.substring(begin-3, (begin-3)+3);
      if(donviTy=="000")
      {
        sReturn = sReturn.replaceFirst("ngàn", "ngàn tỷ");
      }
    }

    return sReturn;
  }

// Khoi tao ham Read
  static String Read(String sNumber, int iPo) {
    // Tao mot bien tra ve
    String sReturn = "";
    // Tao mot bien so
    Set<String> sPo = { "", "ngàn" + " ",
      "triệu" + " ", "tỷ" + " ",  "ngàn" + " "};
    Set<String> sSo = { "không" + " ", "một" + " ",
      "hai" + " ", "ba" + " ",
      "bốn" + " ", "năm" + " ",
      "sáu" + " ", "bảy" + " ",
      "tám" + " ", "chín" + " " };
    Set<String> sDonvi = { "", "mươi" + " ", "trăm" + " " };
    // Tim chieu dai cua chuoi
    int iLen = sNumber.length;
    // Tao mot bien nho vi tri doc
    int iRe = 0;
    // Tao mot vong lap de doc so
    for (int i = 0; i < iLen; i++) {
      String sTemp = "" + sNumber[i];
      int iTemp = int.tryParse(sTemp);
      // Tao mot bien ket qua
      String sRead = "";
      // Kiem tra xem so nhan vao co = 0 hay ko
      if (iTemp == 0) {
        switch (iRe) {
          case 0:
            break;// Khong lam gi ca
          case 1: {
            if (int.tryParse("" + sNumber[0]) != 0) {
              sRead = "lẻ" + " ";
            }
            break;
          }
          case 2: {
            if (int.tryParse("" + sNumber[0]) != 0
                && int.tryParse("" + sNumber[1]) != 0) {
              sRead = "không trăm" + " ";
            }
            break;
          }
        }
      } else if (iTemp == 1) {
        switch (iRe) {
          case 1:
            sRead = "mười" + " ";
            break;
          default:
            sRead = "một" + " " + sDonvi.elementAt(iRe);
            break;
        }
      } else if (iTemp == 5) {
        switch (iRe) {
          case 0: {
            if(sNumber.length <= 1){
              sRead = "năm" + " ";
            }
            else if (int.tryParse("" + sNumber[1]) != 0) {
              sRead = "lăm" + " ";
            } else
              sRead = "năm" + " ";
            break;
          }
          default:
            sRead = sSo.elementAt(iTemp) + sDonvi.elementAt(iRe);
        }
      } else {
        sRead = sSo.elementAt(iTemp) + sDonvi.elementAt(iRe);
      }

      sReturn = sRead + sReturn;
      iRe++;
    }
    if (sReturn.length > 0) {
      sReturn += sPo.elementAt(iPo);
    }
    // xu ly lan cuoi voi 220 000 tỷ 000 000 000 000 000
    if(sNumber.length>12)
    {
      // tren gia tri can xu ly, kiem tra xem don vi TY co = 000 khong
      print(sNumber.substring(11, 8));
    }
    return sReturn;
  }
}