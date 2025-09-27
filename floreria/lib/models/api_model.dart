class ApiModel<T> {
  final bool success;
  final String message;
  final T? data;

  ApiModel({this.success = false, this.message = '', this.data});
}
