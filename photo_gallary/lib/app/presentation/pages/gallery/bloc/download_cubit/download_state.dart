

enum DownloadStatus {initial, downloading, success, error}

class DownloadState {
  final DownloadStatus status;
  final bool isPhotoSelected;
  final String? errorMessage;
  final int? progress;

  const DownloadState({
    this.status = DownloadStatus.initial,
    this.errorMessage,
    this.progress,
    this.isPhotoSelected = false,
  });

  DownloadState copyWith({
    DownloadStatus? status,
    String? errorMessage,
    int? progress,
    bool? isPhotoSelected,
  }) {
    return DownloadState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
      isPhotoSelected: isPhotoSelected ?? this.isPhotoSelected,
    );
  }
}