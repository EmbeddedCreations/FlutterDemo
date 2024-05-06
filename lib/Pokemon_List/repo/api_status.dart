class Success{
  int code;
  Object resp;
  Success({required this.code,required this.resp});
  int get getCode => code;
  Object get getResp => resp;
}

class Failure{
  int code;
  Object errResp;
  Failure({required this.code,required this.errResp});
  int get getCode => code;
  Object get getErrResp => errResp;
}