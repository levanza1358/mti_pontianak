                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (c.isUpdateAvailable.value)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton.icon(
                                onPressed: c.isDownloading.value
                                    ? null
                                    : c.downloadAndInstall,
                                icon: const Icon(Icons.download_rounded),
                                label: Text(
                                  c.isDownloading.value
                                      ? (c.progressText.value.isNotEmpty
                                            ? 'Mengunduh ${c.progressText.value}'
                                            : 'Mengunduh...')
                                      : 'Unduh & Pasang',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF22c55e),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                              if (c.isDownloading.value)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LinearProgressIndicator(
                                        value: c.downloadPercent.value == 0
                                            ? null
                                            : c.downloadPercent.value,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Progress: ${c.progressText.value}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        if (c.errorText.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'Error: ${c.errorText.value}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color softText,
    required Color strongText,
    Widget? trailing,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, color: softText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value.isEmpty ? '-' : value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: strongText,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _notesCard({
    required String name,
    required String notes,
    required Color softText,
    required Color strongText,
    VoidCallback? onOpenRelease,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEEBC8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Icon(Icons.new_releases_rounded, color: Color(0xFFDD6B20)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Rilis Terbaru',
                    style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
                  ),
                ),
                if (onOpenRelease != null)
                  TextButton.icon(
                    onPressed: onOpenRelease,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF3182CE),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text('Lihat'),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              name.isEmpty ? '-' : name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: strongText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                notes.isEmpty ? 'Belum ada catatan rilis.' : notes,
                style: const TextStyle(fontSize: 13, color: Color(0xFF4A5568), height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
