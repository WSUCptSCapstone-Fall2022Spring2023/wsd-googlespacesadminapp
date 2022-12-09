abstract class DataRetrievalStatus {
  const DataRetrievalStatus();
}

class InitialRetrievalStatus extends DataRetrievalStatus {
  const InitialRetrievalStatus();
}

class DataRetrieving extends DataRetrievalStatus {}

class RetrievalSuccess extends DataRetrievalStatus {}

class RetrievalFailed extends DataRetrievalStatus {
  final Exception exception;

  RetrievalFailed(this.exception);
}
