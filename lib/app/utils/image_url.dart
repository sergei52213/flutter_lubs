const String _imageProxyBase = String.fromEnvironment('IMAGE_PROXY_BASE');

String resolveImageUrl(String url) {
  if (_imageProxyBase.isEmpty || url.isEmpty) return url;

  return '$_imageProxyBase${Uri.encodeComponent(url)}';
}
