abstract interface class UseCase<TResult, TParams> {
  Future<TResult> call(TParams params);
}