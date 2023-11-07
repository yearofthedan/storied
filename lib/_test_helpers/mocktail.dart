Future<T> reflectFirstArgAsFuture<T>(invocation) =>
    Future.value(invocation.positionalArguments[0]);
